import os
import json
import re
import mysql.connector
import fitz  # PyMuPDF
from langchain_ollama import OllamaLLM

# Initialize Ollama model
ollama_model = OllamaLLM(base_url='http://localhost:11434', model='ats_model')

def extract_text_from_pdf(file_path):
    """Extracts text from a local PDF file."""
    text = ""
    try:
        doc = fitz.open(file_path)
        for page in doc:
            text += page.get_text()
        doc.close()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    return text

def get_matching_score(job_description, resume_text, resume_name):
    """Send job description and resume to Ollama model and get matching score."""
    prompt = f"""
        You are an AI-powered resume analysis agent.
        Given a job description, analyze resumes for relevance and extract key details.

        For each resume, **ONLY return the following JSON output**:

        {{
            "resume_name": "{resume_name}",
            "percentage": 90,
            "name": "[Candidate Full Name]",
            "email": "[Candidate Email Address]",
            "phone": "[Phone Number]"

        }}

        **DO NOT** provide additional analysis, keywords, explanations, or recommendations.

        Job Description: {job_description}
        Resume Text: {resume_text[:2000]}
        """

    ai_output = ollama_model.invoke(prompt)
    name, email,phone = extract_candidate_info(ai_output, resume_text)
    return ai_output.strip(), name, email, phone



def extract_candidate_info(ai_output, fallback_text):
    """Parses AI output JSON or falls back to regex if parsing fails."""
    try:
        name_match = re.search(r'"name":\s*"([^"]+)"', ai_output)
        email_match = re.search(r'"email":\s*"([^"]+)"', ai_output)
        phone_match = re.search(r'"phone":\s*"([^"]+)"', ai_output)

        if name_match and email_match and phone_match:
            return name_match.group(1), email_match.group(1), phone_match.group(1)
    except Exception as e:
        print("Error extracting from AI output:", e)

    # Fallback regex extraction
    name_fallback = re.search(r"Name:\s*(.*)", fallback_text)
    email_fallback = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", fallback_text)
    phone_fallback = re.search(r"Phone:\s*([\+]?[\d\s\-\(\)]+)", fallback_text)

    name = name_fallback.group(1).strip() if name_fallback else "Unknown"
    email = email_fallback.group(1).strip() if email_fallback else "Not found"
    phone = phone_fallback.group(1).strip() if phone_fallback else "Not found"

    return name, email, phone



def main():
    job_description = "Backend engineer skilled in Python, Django, REST APIs, and scalable systems."
    resume_dir = r"C:\Users\anand\OneDrive\Pictures\Documents\new_pixcel\hiring_backend\media\resumes"

    conn = mysql.connector.connect(
        host="pixeladvant.com",
        port=3307,
        user="myuser",
        password="PixelAdvant@123",
        database="pixeladvant_hiring"
    )
    update_cursor = conn.cursor()

    for filename in os.listdir(resume_dir):
        if not filename.lower().endswith(".pdf"):
            continue

        file_path = os.path.join(resume_dir, filename)
        resume_text = extract_text_from_pdf(file_path)
        raw_score, name, email,phone = get_matching_score(job_description, resume_text, filename)
        print(name, email,phone)

        try:
            parsed = json.loads(raw_score)
            score = parsed.get("percentage", 0)
        except Exception as e:
            print(f"⚠️ Error parsing response for {filename}: {e}")
            score = 0

        print(f"{filename}: {score}% match")

        # 🔄 Update Score in DB
        update_cursor.execute(
            "UPDATE candidates SET Score = %s, Name = %s, Email = %s, Phone_no = %s WHERE Resume = %s",
            (score, name, email, phone, filename)
        )

        # 🔍 Verify update using separate cursor
        verify_cursor = conn.cursor(dictionary=True)
        verify_cursor.execute(
            "SELECT CandidateID, Name, Score FROM candidates WHERE Resume = %s",
            (filename,)
        )
        result = verify_cursor.fetchone()

        # ✅ Consume remaining result set — even if unused
        while verify_cursor.nextset():
            pass

        if result:
            print(f"🧾 Updated: {result['CandidateID']} | {result['Name']} | Score: {result['Score']}")
        else:
            print(f"⚠️ No candidate record found for {filename}")

        verify_cursor.close()



    conn.commit()
    update_cursor.close()
    conn.close()
    print("✅ All resumes processed and scores updated.")

if __name__ == "__main__":
    main()
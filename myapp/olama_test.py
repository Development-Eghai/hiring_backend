import os
import json
import re
import subprocess
import requests
import mysql.connector
import fitz  # PyMuPDF
from langchain_ollama import OllamaLLM

# 🧠 Initialize Ollama model
ollama_model = OllamaLLM(base_url='http://localhost:11434', model='ats_model')

# 📁 Define paths
LOCAL_DOWNLOAD_FOLDER = os.path.join(os.getcwd(), "media", "resumes")
os.makedirs(LOCAL_DOWNLOAD_FOLDER, exist_ok=True)

# 📄 Resume to process
resume_filename = "Naukri_KiranGade.pdf"
local_resume_path = os.path.join(LOCAL_DOWNLOAD_FOLDER, resume_filename)

# 🌐 SCP download from server
def download_resume_via_scp(resume_name):
    server_path = f"/root/project/hiring_backend/media/resumes/{resume_name}"
    scp_command = [
        "scp",
        f"root@178.16.139.167:{server_path}",
        local_resume_path
    ]
    try:
        subprocess.run(scp_command, check=True)
        print(f"✅ Successfully downloaded {resume_name}")
    except subprocess.CalledProcessError as e:
        print(f"❌ SCP failed for {resume_name}: {e}")
        return False
    return True

# 📄 Extract text from PDF
def extract_text_from_pdf(file_path):
    text = ""
    try:
        doc = fitz.open(file_path)
        for page in doc:
            text += page.get_text()
        doc.close()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    return text

# 🌐 Parse resume via external API
def parse_resume_via_api(pdf_path):
    url = "https://h2gynslegk.execute-api.us-east-1.amazonaws.com/prod/parse-resume"
    headers = {"Content-Type": "application/pdf"}
    try:
        with open(pdf_path, "rb") as f:
            response = requests.post(url, headers=headers, data=f)
        response.raise_for_status()
        parsed_data = response.json()
        print("🧠 Resume parsed via API:", parsed_data)
        return parsed_data
    except Exception as e:
        print("❌ Resume parsing API failed:", e)
        return {}

# 🔍 AI-based scoring + name/email/phone extraction
def get_matching_score(job_description, resume_text, resume_name):
    prompt = f"""
    You are an AI-powered resume analysis agent.
    Given a job description and resume content, extract relevance score and candidate contact info.

    Return ONLY this JSON:
    {{
        "resume_name": "{resume_name}",
        "percentage": "Your estimate of match percentage (integer) between 0 and 100 inclusive",
        "candidate_first_name": "Extracted first name",
        "candidate_last_name": "Extracted last name",
        "email": "Extracted email address",
        "phone": "Extracted phone number"
    }}

    Do NOT include any extra commentary or formatting.

    Job Description:
    {job_description}

    Resume Text:
    {resume_text[:5000]}
    """
    ai_output = ollama_model.invoke(prompt)
    first_name, last_name, email, phone = extract_candidate_info(ai_output, resume_text)
    return ai_output.strip(), first_name, last_name, email, phone

# 🛠️ Extract from AI output or fallback regex
def extract_candidate_info(ai_output, fallback_text):
    try:
        first_name = re.search(r'"candidate_first_name":\s*"([^"]+)"', ai_output)
        last_name = re.search(r'"candidate_last_name":\s*"([^"]+)"', ai_output)
        email = re.search(r'"email":\s*"([^"]+)"', ai_output)
        phone = re.search(r'"phone":\s*"([^"]+)"', ai_output)

        if first_name and last_name and email and phone:
            return (
                first_name.group(1).strip(),
                last_name.group(1).strip(),
                email.group(1).strip(),
                phone.group(1).strip()
            )
    except Exception as e:
        print("Parse error:", e)

    # 🔁 Fallback regex if AI output fails
    name_fallback = re.search(r"Name:\s*(\w+)\s*(\w*)", fallback_text)
    email_fallback = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", fallback_text)
    phone_fallback = re.search(r"Phone:\s*([\+]?[\d\s\-\(\)]+)", fallback_text)

    first_name = name_fallback.group(1) if name_fallback else "Unknown"
    last_name = name_fallback.group(2) if name_fallback and name_fallback.group(2) else ""
    email = email_fallback.group(1).strip() if email_fallback else "Not found"
    phone = phone_fallback.group(1).strip() if phone_fallback else "Not found"
    print(first_name, last_name, email, phone)
    return first_name, last_name, email, phone

# 🚀 Main Execution
def main():
    if not download_resume_via_scp(resume_filename):
        return

    job_description = "Backend engineer skilled in Python, Django, REST APIs, and scalable systems."
    resume_text = extract_text_from_pdf(local_resume_path)

    # 🧠 AI scoring
    raw_score, ai_first, ai_last, ai_email, ai_phone = get_matching_score(job_description, resume_text, resume_filename)

    try:
        parsed = json.loads(raw_score)
        score = parsed.get("percentage", 0)
    except Exception as e:
        print("⚠️ JSON parse failed:", e)
        score = 0

    # 🌐 API parsing
    parsed_resume = parse_resume_via_api(local_resume_path)
    api_name = parsed_resume.get("name", "")
    api_email = parsed_resume.get("email", "")
    api_skills = parsed_resume.get("skills", [])

    # 🧬 Merge AI + API
    first_name = api_name.split()[0] if api_name else ai_first
    last_name = api_name.split()[1] if api_name and len(api_name.split()) > 1 else ai_last
    email = api_email or ai_email
    phone = ai_phone  # API doesn't return phone

    print(f"📊 {resume_filename}: {score}% match | Name: {first_name} {last_name} | Email: {email} | Phone: {phone}")
    print(f"🛠️ Skills: {api_skills}")

    # 🔄 Update DB
    conn = mysql.connector.connect(
        host="pixeladvant.com",
        port=3307,
        user="myuser",
        password="PixelAdvant@123",
        database="pixeladvant_hiring"
    )
    update_cursor = conn.cursor()

    update_cursor.execute("""
        UPDATE candidates
        SET Score = %s,
            candidate_first_name = %s,
            candidate_last_name = %s,
            Email = %s,
            Phone_no = %s
        WHERE Resume = %s
    """, (score, first_name, last_name, email, phone, resume_filename))

    conn.commit()
    update_cursor.close()
    conn.close()
    print("✅ Database updated successfully.")

if __name__ == "__main__":
    main()
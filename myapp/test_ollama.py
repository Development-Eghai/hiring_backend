import os
import json
import re
import subprocess
import mysql.connector
import fitz  # PyMuPDF
from langchain_ollama import OllamaLLM

# 🧠 Initialize Ollama model
ollama_model = OllamaLLM(base_url='http://localhost:11434', model='ats_model')

# 📁 Define paths
LOCAL_DOWNLOAD_FOLDER = os.path.join(os.getcwd(), "media", "resumes")
os.makedirs(LOCAL_DOWNLOAD_FOLDER, exist_ok=True)

# 📄 Resume to process
resume_filename = "NITIN BANSAL - Resume (1).pdf"
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

# 🔍 AI-based scoring + name/email/phone extraction
def get_matching_score(job_description, resume_text, resume_name):
    prompt = f"""
    You are an AI-powered resume analysis agent.
    Given a job description, analyze resumes for relevance and extract key details.

    Return ONLY this JSON:
    {{
        "resume_name": "{resume_name}",
        "percentage": 90,
        "name": "[Candidate Full Name]",
        "email": "[Candidate Email Address]",
        "phone": "[Phone Number]"
    }}

    Do NOT include additional analysis.

    Job Description: {job_description}
    Resume Text: {resume_text[:2000]}
    """
    ai_output = ollama_model.invoke(prompt)
    name, email, phone = extract_candidate_info(ai_output, resume_text)
    return ai_output.strip(), name, email, phone

# 🛠️ Extract from AI output or fallback regex
def extract_candidate_info(ai_output, fallback_text):
    try:
        name = re.search(r'"name":\s*"([^"]+)"', ai_output)
        email = re.search(r'"email":\s*"([^"]+)"', ai_output)
        phone = re.search(r'"phone":\s*"([^"]+)"', ai_output)
        if name and email and phone:
            return name.group(1), email.group(1), phone.group(1)
    except Exception as e:
        print("Parse error:", e)

    name_fallback = re.search(r"Name:\s*(.*)", fallback_text)
    email_fallback = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", fallback_text)
    phone_fallback = re.search(r"Phone:\s*([\+]?[\d\s\-\(\)]+)", fallback_text)

    name = name_fallback.group(1).strip() if name_fallback else "Unknown"
    email = email_fallback.group(1).strip() if email_fallback else "Not found"
    phone = phone_fallback.group(1).strip() if phone_fallback else "Not found"

    return name, email, phone

# 🚀 Main Execution
def main():
    if not download_resume_via_scp(resume_filename):
        return

    job_description = "Backend engineer skilled in Python, Django, REST APIs, and scalable systems."
    resume_text = extract_text_from_pdf(local_resume_path)
    raw_score, name, email, phone = get_matching_score(job_description, resume_text, resume_filename)

    try:
        parsed = json.loads(raw_score)
        score = parsed.get("percentage", 0)
    except Exception as e:
        print("⚠️ JSON parse failed:", e)
        score = 0

    print(f"📊 {resume_filename}: {score}% match | Name: {name} | Email: {email} | Phone: {phone}")

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
        SET Score = %s, Name = %s, Email = %s, Phone_no = %s
        WHERE Resume = %s
    """, (score, name, email, phone, resume_filename))

    conn.commit()
    update_cursor.close()
    conn.close()
    print("✅ Database updated successfully.")

if __name__ == "__main__":
    main()
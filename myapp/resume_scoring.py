import os
import json
import re
import subprocess
import getpass
import mysql.connector
import fitz  # PyMuPDF
import requests
from langchain_ollama import OllamaLLM
# from langchain_community.llms import Ollama


def download_ats_model(model_name: str = "ats_model", base_url: str = "http://localhost:11434"):
    """
    Download the ATS model using Ollama if not already available.

    Args:
        model_name: Name of the model to download (default: "ats_model")
        base_url: Base URL for Ollama API (default: "http://localhost:11434")

    Returns:
        bool: True if model is available, False otherwise
    """
    # Check if Ollama is running
    try:
        response = requests.get(base_url, timeout=5)
    except (requests.exceptions.ConnectionError, requests.exceptions.Timeout):
        print("❌ Ollama is not running or not accessible. Please make sure Ollama is running with:")
        print("   ollama serve")
        return False

    # Check if model is already available
    try:
        tags_response = requests.get(f"{base_url}/api/tags")
        tags_response.raise_for_status()
        available_models = [model["name"] for model in tags_response.json().get("models", [])]

        if any(model_name in model for model in available_models):
            print(f"✅ Model '{model_name}' is already available")
            return True

        # Try to pull the model
        print(f"⏳ Downloading model '{model_name}'...")
        pull_response = requests.post(
            f"{base_url}/api/pull",
            json={"name": model_name, "stream": False},
            timeout=300  # 5 minutes timeout
        )
        pull_response.raise_for_status()
        print(f"✅ Successfully downloaded '{model_name}'")
        return True

    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 404:
            print(f"❌ Model '{model_name}' not found in Ollama model registry")
            print("\nAvailable models:")
            for model in available_models:
                print(f"  - {model}")
            print("\nYou may need to create a custom model or use an existing one.")
            return False
        else:
            print(f"❌ Error downloading model: {str(e)}")
            return False
    except Exception as e:
        print(f"❌ Unexpected error: {str(e)}")
        return False

# Initialize Ollama model with local ATs model
# ollama_model = OllamaLLM(model_path=download_ats_model())

ollama_model = OllamaLLM(base_url='http://localhost:11434', model='ats_model')

# 📁 Define paths
RESUME_BASE_DIR = "media"
RESUME_DIR = "resumes"
SERVER_ROOT_DIR = "/root/project/hiring_backend/"
SERVER_SCP_URL = "root@178.16.139.167"
CMD_SCP = "scp"

LOCAL_DOWNLOAD_FOLDER = os.path.join(os.getcwd(), RESUME_BASE_DIR, RESUME_DIR)
os.makedirs(LOCAL_DOWNLOAD_FOLDER, exist_ok=True)

# 🔐 Cached SSH password (prompt once per run)
_SSH_PASSWORD_CACHE = None

def get_ssh_password():
    global _SSH_PASSWORD_CACHE
    if _SSH_PASSWORD_CACHE is None:
        prompt_host = SERVER_SCP_URL
        _SSH_PASSWORD_CACHE = getpass.getpass(f"Enter SSH password for {prompt_host}: ")
    return _SSH_PASSWORD_CACHE


#
# SCP download from server
# Returns the local destination path if successful, otherwise None
def download_resume_via_scp(resume_filename: str):
    remote_path = f"{SERVER_ROOT_DIR}/{RESUME_BASE_DIR}/{RESUME_DIR}/{resume_filename}"
    local_path = os.path.join(LOCAL_DOWNLOAD_FOLDER, resume_filename)

    # Ensure local directory exists
    os.makedirs(LOCAL_DOWNLOAD_FOLDER, exist_ok=True)

    password = get_ssh_password()
    # Escape spaces for remote shell (avoid quoting which may cause protocol mismatch)
    remote_path_escaped = remote_path.replace(" ", r"\ ")
    remote_spec = f"{SERVER_SCP_URL}:{remote_path_escaped}"
    scp_command = [
        "sshpass", "-p", password,
        CMD_SCP, "-O", "-T",  # Legacy scp protocol and disable strict filename checking
        remote_spec,
        local_path
    ]

    try:
        subprocess.run(scp_command, check=True)
        print(f"✅ Successfully downloaded to {local_path}")
        return local_path
    except subprocess.CalledProcessError as e:
        print(f"❌ SCP failed for {resume_filename}: {e}")
        return None

#
# 📋 List resumes available on the server via SSH
#
def list_remote_resumes():
    remote_dir = f"{SERVER_ROOT_DIR}/{RESUME_BASE_DIR}/{RESUME_DIR}"
    password = get_ssh_password()
    ssh_command = [
        "sshpass", "-p", password,
        "ssh",
        SERVER_SCP_URL,
        f'ls -1 "{remote_dir}"'
    ]
    try:
        result = subprocess.run(ssh_command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        files = [line.strip() for line in result.stdout.splitlines() if line.strip()]
        # Filter common resume file types
        exts = (".pdf", ".doc", ".docx")
        files = [f for f in files if f.lower().endswith(exts)]
        return files
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to list resumes via SSH: {e.stderr or e}")
        return []

#
# 🧭 Prompt user to pick a resume interactively
#
def pick_resume_interactively(files):
    if not files:
        print("No resumes found on the server.")
        return None
    print("Available resumes:")
    for idx, fname in enumerate(files, start=1):
        print(f"  {idx}. {fname}")
    while True:
        choice = input("Enter the number of the resume to process (or 'q' to quit): ").strip()
        if choice.lower() in ("q", "quit", "exit"):
            return None
        if not choice.isdigit():
            print("Please enter a valid number.")
            continue
        idx = int(choice)
        if 1 <= idx <= len(files):
            return files[idx - 1]
        print("Number out of range. Try again.")

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

#
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
class ResumeProcessor:
    def __init__(self, job_description: str | None = None):
        self.job_description = job_description or (
            "Backend engineer skilled in Python, Django, REST APIs, and scalable systems."
        )

    def run(self):
        # 1) List resumes on server and let user pick
        resumes = list_remote_resumes()
        chosen_resume = pick_resume_interactively(resumes)
        if not chosen_resume:
            print("No resume selected. Exiting.")
            return

        # 2) Download selected resume
        local_resume_path = download_resume_via_scp(chosen_resume)
        if not local_resume_path:
            return

        # 3) Extract and score
        resume_text = extract_text_from_pdf(local_resume_path)

        raw_score, first_name, last_name, email, phone = get_matching_score(
            self.job_description, resume_text, chosen_resume
        )

        try:
            parsed = json.loads(raw_score)
            score = parsed.get("percentage", 0)
        except Exception as e:
            print("⚠️ JSON parse failed:", e)
            score = 0

        print(
            f"📊 {chosen_resume}: {score}% match | Name: {first_name} {last_name} | Email: {email} | Phone: {phone}"
        )

        # 4) 🔄 Update DB
        conn = mysql.connector.connect(
            host="pixeladvant.com",
            port=3307,
            user="myuser",
            password="PixelAdvant@123",
            database="pixeladvant_hiring",
        )

        try:
            where_clause_resume_filename = chosen_resume.strip()

            update_cursor = conn.cursor()

            update_cursor.execute(
                """
                UPDATE candidates
                SET Score                = %s,
                    candidate_first_name = %s,
                    candidate_last_name  = %s,
                    Email                = %s,
                    Phone_no             = %s
                WHERE Resume = %s
                """,
                (score, first_name, last_name, email, phone, where_clause_resume_filename),
            )

            # Commit explicitly
            conn.commit()

            # Check how many rows were affected
            rows_affected = update_cursor.rowcount
            print(f"Rows updated: {rows_affected}")

        except Exception as e:
            conn.rollback()  # Roll back on error
            print("Error while updating candidate:", e)
        finally:
            update_cursor.close()
            conn.close()

        print("✅ Database updated successfully.")

def main():
    try:
        print("⬇️  Checking/downloading ATS model...")
        if download_ats_model():
            print("✅ ATS model is ready to use")
            processor = ResumeProcessor()
            processor.run()
        else:
            print("❌ Failed to setup ATS model. Please check the error messages above.")
    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    # resume_filename = "Naukri_KiranGade.pdf"
    # resume_filename = "S K IMRAN_CV.pdf"
    resume_filename = "Amit_KumarMestri_Resume.pdf"
    resume_filename_escaped = resume_filename.replace(" ", "\\ ")
    resume_path = os.path.join(LOCAL_DOWNLOAD_FOLDER, resume_filename_escaped)

    main()

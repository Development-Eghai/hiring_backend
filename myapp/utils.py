import re
import ollama
import re
import pdfplumber
import requests


def extract_info_from_resume(file_path):
    text = extract_text_from_pdf(file_path)  # Extract text from PDF
    response = ollama.chat(model="ats_model", messages=[{"role": "user", "content": f"Extract name and email from this resume: {text}"}])
    
    extracted_data = response['message']['content']
    name_match = re.search(r"Name:\s*(.*)", extracted_data)
    email_match = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", extracted_data)

    name = name_match.group(1) if name_match else "Unknown"
    email = email_match.group(1) if email_match else "Not found"

    return name, email

def extract_text_from_pdf(file_path):
    text = ""
    with pdfplumber.open(file_path) as pdf:
        for page in pdf.pages:
            text += page.extract_text() + "\n"
    return text

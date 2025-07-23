# import os
# import ollama
# import fitz  # PyMuPDF

# def extract_text_from_pdf(pdf_path):
#     """Extract text from a PDF file."""
#     doc = fitz.open(pdf_path)
#     text = "\n".join([page.get_text() for page in doc])
#     return text

# def get_score(job_description, resume_text):
#     """Get compatibility score for a resume text."""
#     model = 'ats_model'  # Replace with the correct Ollama model name
#     prompt = (
#         "Evaluate the compatibility of the following resume with the job description provided. "
#         "Return only a numerical compatibility score between 0 and 10. Do not include explanations.\n\n"
#         f"Job Description:\n{job_description}\n\n"
#         f"Resume:\n{resume_text}\n\n"
#         "Output format: Only return the number."
#     )
    
#     response = ollama.generate(model=model, prompt=prompt)
#     return response['text'] if 'text' in response else response

# def process_resumes(job_description, folder_path):
#     """Process all PDF resumes in a folder."""
#     for filename in os.listdir(folder_path):
#         if filename.endswith(".pdf"):
#             resume_path = os.path.join(folder_path, filename)
#             resume_text = extract_text_from_pdf(resume_path)
#             score = get_score(job_description, resume_text)
#             print(f"{filename}: compatibility score {score.response}")  # Print compatibility score for each resume

# def main():
#     job_description = "Looking for a Python developer with experience in AI and machine learning."
#     folder_path = r"C:\Users\anand\OneDrive\Pictures\Documents\hiring_backend\hiring_backend\media\resumes"  # Replace with actual folder path
    
#     process_resumes(job_description, folder_path)

# if __name__ == "__main__":
#     main()

import openpyxl
from openpyxl import Workbook

wb = Workbook()
ws = wb.active
ws.title = "Interviewers"

# 🧭 Header row
ws.append([
    "req_id", "client_id", "first_name", "last_name", "job_title",
    "interview_mode", "interviewer_stage", "email", "contact_number",
    "date", "start_time", "end_time"
])

# 📌 Sample rows with repeated interviewer + multiple slots
ws.append([
    "RQ0001", "ABC", "Kumar", "Sachidanand", "PM",
    "Online", "Technical Round-1 & 2", "kumar.sachidanand11@gmail.com",
    "8904957029", "2025-06-25", "10:00:00", "12:00:00"
])

ws.append([
    "RQ0001", "ABC", "Kumar", "Sachidanand", "PM",
    "Online", "Technical Round-1 & 2", "kumar.sachidanand11@gmail.com",
    "8904957029", "2025-06-25", "15:00:00", "17:00:00"
])

# 💾 Save locally
wb.save("sample_interviewers.xlsx")
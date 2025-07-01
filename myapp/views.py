# Import necessary modules and models
from argparse import Action
import jwt
import base64
import datetime
from io import BytesIO
import os
from pyexpat.errors import messages
from django.http import HttpResponse,JsonResponse
from django.shortcuts import get_object_or_404, render, redirect
import fitz
import ollama
from rest_framework import generics
from rest_framework.generics import ListAPIView
# from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.decorators import login_required
# from django.contrib.auth.models import Us
from django.contrib.auth import logout
from django.db import connection
from django.conf import settings
from django.contrib.auth.hashers import check_password
from .models import Approver, CandidateInterviewStages, CandidateReview, InterviewDesignScreen, InterviewReview, InterviewSchedule, Interviewer, OfferNegotiation, Posting, RequisitionDetails, StageAlertResponsibility, UserDetails,Candidates,UserroleDetails
from rest_framework.parsers import MultiPartParser, FormParser
from django.views.decorators.csrf import csrf_exempt
import json
from .models import JobRequisition
from django.db import transaction


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import json
from django.views.decorators.http import require_POST
from django.core.mail import send_mail
from django.conf import settings
from django.http import JsonResponse
from django.core.serializers.json import DjangoJSONEncoder
from .models import JobRequisition
import PyPDF2 as pdf
from langchain_ollama import OllamaLLM
from .serializers import ApproverSerializer, CandidateInterviewStagesSerializer, InterviewDesignParametersSerializer, InterviewDesignScreenSerializer, InterviewerSerializer, JobRequisitionCompactSerializer, JobRequisitionSerializer,JobRequisitionSerializerget, JobTemplateSerializer, OfferNegotiationSerializer, StageAlertResponsibilitySerializer
from rest_framework import viewsets
from .models import Candidate
# from .utils import extract_info_from_resume  # Import the parsing function
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from .models import Candidate
import re
import fitz 
from concurrent.futures import ThreadPoolExecutor
from django.utils.crypto import get_random_string
from django.contrib.auth.hashers import make_password
from .models import InterviewRounds,HiringPlan
from .serializers import HiringInterviewRoundsSerializer,HiringSkillsSerializer,HiringPlanSerializer
SECRET_KEY = settings.SECRET_KEY
from rest_framework.decorators import api_view
from rest_framework_simplejwt.tokens import RefreshToken
from .jwt_token import jwt_required,api_json_response_format
from rest_framework.views import APIView
from rest_framework.response import Response
from .google_calendar import schedule_google_meet
from datetime import datetime, timedelta
import pytz

from datetime import datetime
import pytz
# from sentence_transformers import SentenceTransformer, util
# import torch
import re
from .serializers import JobRequisitionDetailSerializer

# ollama.base_url = "http://ollama:11434"


class ApproverCreateListView(generics.ListCreateAPIView):
    queryset = Approver.objects.all()
    serializer_class = ApproverSerializer

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            serializer = self.get_serializer(queryset, many=True)
            return Response(api_json_response_format(
                True,
                "Approvers retrieved successfully!",
                200,
                serializer.data
            ), status=status.HTTP_200_OK)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error retrieving approvers. {str(e)}",
                500,
                []
            ), status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            return Response(api_json_response_format(
                True,
                "Approver created successfully!",
                201,
                serializer.data
            ), status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error creating approver. {str(e)}",
                500,
                {}
            ), status=status.HTTP_200_OK)


class ApproverFilterView(APIView):
    def post(self, request, *args, **kwargs):
        try:
            hiring_plan_id = request.data.get("hiring_plan")
            if not hiring_plan_id:
                return Response(api_json_response_format(
                    False,
                    "hiring_plan is required in request body",
                    400,
                    []
                ), status=status.HTTP_200_OK)

            approvers = Approver.objects.filter(hiring_plan_id=hiring_plan_id)
            serializer = ApproverSerializer(approvers, many=True)
            return Response(api_json_response_format(
                True,
                "Approvers filtered by hiring plan retrieved successfully!",
                200,
                serializer.data
            ), status=status.HTTP_200_OK)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error filtering approvers. {str(e)}",
                500,
                []
            ), status=status.HTTP_200_OK)

class OfferNegotiationViewSet(viewsets.ModelViewSet):
    queryset = OfferNegotiation.objects.prefetch_related('benefits').all()
    serializer_class = OfferNegotiationSerializer

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.filter_queryset(self.get_queryset())
            serializer = self.get_serializer(queryset, many=True)
            return Response(api_json_response_format(True, "Job requisitions retrieved successfully!", 200, serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, f"Error retrieving job requisitions. {str(e)}", 500, {}), status=200)

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            return Response(api_json_response_format(True, "Offer negotiation created successfully!", 201, serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, f"Error creating offer negotiation. {str(e)}", 500, {}), status=200)


class GetInterviewScheduleAPIView(APIView):
    def post(self, request):
        try:
            email = request.data.get("email")
            if not email:
                return Response(api_json_response_format(False, "Missing interviewer email", 400, {}), status=400)

            schedules = InterviewSchedule.objects.filter(
                interviewer__email=email
            ).select_related('candidate', 'candidate__Req_id_fk')

            data = []
            for schedule in schedules:
                candidate = schedule.candidate
                requisition = candidate.Req_id_fk

                data.append({
                    "Schedule ID": schedule.id,
                    "Candidate Name": candidate.Name,
                    "Requisition ID": requisition.RequisitionID,
                    "Position Title": requisition.PositionTitle,
                    "Interview Date": schedule.date.strftime("%Y-%m-%d"),
                    "Start Time": schedule.start_time.strftime("%H:%M"),
                    "End Time": schedule.end_time.strftime("%H:%M"),
                    "Round Name": schedule.round_name,
                    "Meet Link": schedule.meet_link
                })

            return Response(api_json_response_format(True, "Fetched scheduled interviews", 200, data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Failed to fetch interviews: {e}", 500, {}), status=500)
        
        
class InterviewReportAPIView(APIView):
    def post(self, request):
        req_id = request.data.get("requisition_id")
        if not req_id:
            return Response(api_json_response_format(False, "Missing requisition_id", 400, {}), status=400)

        interviewers = Interviewer.objects.filter(req_id=req_id)
        data = []

        for interviewer in interviewers:
            interviews = InterviewSchedule.objects.filter(
                interviewer=interviewer,
                candidate__Req_id_fk_id=req_id
            ).select_related('candidate')

            for interview in interviews:
                candidate = interview.candidate
                reviews = interview.reviews.all()
                latest_review = reviews.latest("reviewed_at") if reviews.exists() else None

                data.append({
                    "Schedule ID": interview.id,
                    "Req ID": req_id,
                    "Client ID": interviewer.client_id,
                    "First Name": interviewer.first_name,
                    "Last Name": interviewer.last_name,
                    "Job Title": interviewer.job_title,
                    "Interview Mode": interviewer.interview_mode,
                    "Interviewer Stage": interviewer.interviewer_stage,
                    "Email ID": interviewer.email,
                    "Candidate ID": candidate.CandidateID,
                    "Candidate First Name": candidate.Name.split()[0] if candidate.Name else "",
                    "Candidate Last Name": candidate.Name.split()[-1] if candidate.Name else "",
                    "Role": candidate.Req_id_fk.PositionTitle if candidate.Req_id_fk else "",
                    "Feedback": latest_review.feedback if latest_review else "",
                    "Interview Results": latest_review.result if latest_review else "",
                    "Contact Number": interviewer.contact_number,
                    "Round Name": interview.round_name,
                    "Interview Date": interview.date.strftime("%Y-%m-%d"),
                    "Start Time": interview.start_time.strftime("%H:%M"),
                    "End Time": interview.end_time.strftime("%H:%M"),
                    "Meet Link": interview.meet_link
                })

        return Response(api_json_response_format(
            True, "Fetched full interview report", 200, data
        ), status=200)
    

class SubmitInterviewReviewView(APIView):
    def post(self, request):
        try:
            schedule_id = request.data.get("schedule_id")
            feedback = request.data.get("feedback", "")
            result = request.data.get("result", "")

            if not schedule_id:
                return Response(api_json_response_format(False, "Missing schedule_id", 400, {}), status=400)

            schedule = InterviewSchedule.objects.get(id=schedule_id)

            InterviewReview.objects.create(
                schedule=schedule,
                feedback=feedback,
                result=result
            )

            return Response(api_json_response_format(True, "Feedback saved", 200, {}), status=200)

        except InterviewSchedule.DoesNotExist:
            return Response(api_json_response_format(False, "Schedule not found", 404, {}), status=404)

        except Exception as e:
            return Response(api_json_response_format(False, f"Failed to save review: {e}", 500, {}), status=500)

class ScheduleContextAPIView(APIView):
    def post(self, request, *args, **kwargs):
        req_id = request.data.get("req_id")
        if not req_id:
            return Response(
                api_json_response_format(False, "Missing requisition_id", 400, {}),
                status=status.HTTP_400_BAD_REQUEST
            )
        try:
            instance = JobRequisition.objects.prefetch_related(
                'candidates', 'interviewer__slots'
            ).get(RequisitionID=req_id)
        except JobRequisition.DoesNotExist:
            return Response(
                api_json_response_format(False, "Requisition not found", 404, {}),
                status=200
            )

        serializer = JobRequisitionDetailSerializer(instance)
        rounds = InterviewRounds.objects.filter(requisition_id=req_id).order_by('id')
        round_names = [r.round_name for r in rounds]

        response_data = serializer.data
        response_data["round_names"] = round_names 

        return Response(
            api_json_response_format(True, "Fetched scheduling context successfully", 200, {"data" :response_data}),
            status=200
        )


class InterviewerListCreateAPIView(generics.ListCreateAPIView):
    queryset = Interviewer.objects.prefetch_related('slots').all()
    serializer_class = InterviewerSerializer

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(
                api_json_response_format(True, "Created successfully", 200, {}),
                status=200
            )
        except Exception as e:
            return Response(
                api_json_response_format(False, str(e), 400, {}),
                status=200
            )



class ScheduleMeetView(APIView):
    def post(self, request):
        try:
            candidate_id = request.data.get("candidate_id")
            interviewer_id = request.data.get("interviewer_id")
            start_str = request.data.get("start_datetime")
            end_str = request.data.get("end_datetime")
            round_name = request.data.get("round_name")  # ✅ New
            summary = request.data.get("summary", "Candidate Interview")
            
            if candidate_id is None or interviewer_id is None or not start_str or not end_str or not round_name:
                return Response(api_json_response_format(
                    False, "Missing required fields", 400, {}
                ), status=400)

            tz = pytz.timezone("Asia/Kolkata")
            start = tz.localize(datetime.fromisoformat(start_str))
            end = tz.localize(datetime.fromisoformat(end_str))

            candidate = Candidate.objects.get(CandidateID=candidate_id)
            interviewer = Interviewer.objects.get(interviewer_id=interviewer_id)

            meet_link = schedule_google_meet(
                summary,
                start.isoformat(),
                end.isoformat(),
                attendees=[candidate.Email, interviewer.email]
            )

            InterviewSchedule.objects.create(
                candidate=candidate,
                interviewer=interviewer,
                date=start.date(),
                start_time=start.time(),
                end_time=end.time(),
                round_name=round_name,
                meet_link=meet_link
            )

            return Response(api_json_response_format(
                True, "Interview scheduled successfully", 200,
                {"meet_link": meet_link}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, f"Failed to schedule: {e}", 500, {}
            ), status=500)



RESUME_STORAGE_FOLDER = "media/resumes"
DISPLAY_TO_MODEL_FIELD1 = {
    "Position/Role": "job_position",
    "Tech": "tech_stacks",
    "JD": "jd_details",
    "Experience": "experience_range",
    "Designation": "designation",
    "Target": "target_companies",
    "Compensation/Benefits": "compensation",
    "Working": "working_model",
    "Interview Status": "interview_status",
    "Place": "location",
    "Educational": "education_decision",
    "Relocation": "relocation",
    "Travel": "travel_opportunities",
    "Visa": "visa_requirements",
    "Domain": "domain_knowledge",
    "Background": "background_verification",
    "Shift": "shift_timings",
    "Role Type": "role_type",
    "Job Type": "job_type",
    "Communication": "communication_language",
    "Notice Period": "notice_period",
    "Career Gap": "career_gap",
    "Sabbatical": "sabbatical",
    "Screening Questions": "screening_questions",
    "Job Health Requirements": "job_health_requirements",
    "Social Media": "social_media_links",
    "Language Proficiency": "language_proficiency",
    "Additional Compensation": "additional_comp",
    "Citizenship Requirement": "citizen_requirement"
}
DISPLAY_TO_MODEL_FIELD = {
    "id": "RequisitionID",
    "Position/Role": "details__job_position",
    "Tech": "Planning_id__tech_stacks",
    "JD": "Planning_id__jd_details",
    "Experience": "Planning_id__experience_range",
    "Designation": "Planning_id__designation",
    "Target": "Planning_id__target_companies",
    "Interviewer": "details__interviewer_teammate_employee_id",
    "Interview": "details__client_interview",
    "Compensation/Benefits": "Planning_id__compensation",
    "Duration/Timeline": ["details__contract_start_date", "details__contract_end_date"],
    "Place": "details__location",
    "Working": "details__working_model",
    "Educational": "Planning_id__education_decision",
    "Relocation": "Planning_id__relocation",
    "Travel": "Planning_id__travel_opportunities",
    "Visa": "Planning_id__visa_requirements",
    "Domain": "Planning_id__domain_knowledge",
    "Background": "Planning_id__background_verification",
    "Shift": "Planning_id__shift_timings",
    "Role Type": "Planning_id__role_type",
    "Job Type": "Planning_id__job_type",
    "Communication": "Planning_id__communication_language",
    "Notice Period": "Planning_id__notice_period",
    "Career Gap": "Planning_id__career_gap",
    "Sabbatical": "Planning_id__sabbatical",
    "Screening Questions": "Planning_id__screening_questions",
    "Job Health Requirements": "Planning_id__job_health_requirements",
    "Social Media": "Planning_id__social_media_links",
    "Language Proficiency": "Planning_id__language_proficiency",
    # Fields like "CIBIL", "Valid", "Govt", etc. will return null
    "job_position" : "details__job_position",
    "Recruiter": "Recruiter",
    "division": "details__division",
    "department": "details__department",
    "location": "details__location",
    "status": "Status"

}

# Initialize Ollama model
ollama_model = OllamaLLM(base_url='http://ollama:11434', model='ats_model')
# model = SentenceTransformer("models/paraphrase-MiniLM-L6-v2")

def extract_text_from_pdf(uploaded_file):
    reader = pdf.PdfReader(uploaded_file)
    text = ""
    for page in reader.pages:
        text += str(page.extract_text())
    return text


def extract_info_from_text(text):
    """Attempts AI-based name & email extraction, with fallback regex."""
    prompt = f"""
    Extract only the full name and email address from this resume.
    Return data in JSON format: 
    {{
        "name": "[Full Name]",
        "email": "[Email Address]"
    }}
    Resume Content: {text}"""

    try:
        ai_output = ollama_model.invoke(prompt)
    except Exception as e:
        print("Ollama Error:", e)
        ai_output = ""

    except Exception as e:
        print("Ollama Error:", e)
        ai_output = ""

    print("AI Response:\n", ai_output)

    # Try extracting using AI response JSON
    name_match = re.search(r'"name":\s*"([^"]+)"', ai_output)
    email_match = re.search(r'"email":\s*"([^"]+)"', ai_output)

    if name_match and email_match:
        return name_match.group(1), email_match.group(1)

    # Fallback regex extraction if AI fails
    name_fallback = re.search(r"Name:\s*(.*)", text)
    email_fallback = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", text)

    name = name_fallback.group(1) if name_fallback else "Unknown"
    email = email_fallback.group(1) if email_fallback else "Not found"

    return name, email

def process_resume(file_req_tuple):
    file, req_id = file_req_tuple

    # Ensure the resume directory exists
    os.makedirs(RESUME_STORAGE_FOLDER, exist_ok=True)

    # Save file locally
    file_path = os.path.join(RESUME_STORAGE_FOLDER, file.name)
    with open(file_path, "wb") as f:
        f.write(file.read())

    # Extract text and info
    resume_text = extract_text_from_pdf(file)
    name, email = extract_info_from_text(resume_text)

    # Build Candidate instance
    return Candidate(
        Name=name,
        Email=email,
        Resume=file_path,
        Req_id_fk=req_id
    )

class BulkUploadResumeView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        try:
            req_id = request.data.get("req_id")
            files = request.FILES.getlist("files")

            if not files:
                return Response(api_json_response_format(
                    False, "No files were uploaded.", 400, {}
                ), status=200)

            try:
                job_req = JobRequisition.objects.get(pk=req_id)
            except JobRequisition.DoesNotExist:
                return Response(api_json_response_format(
                    False, "Invalid requisition ID.", 400, {}
                ), status=200)

            file_req_pairs = [(file, job_req) for file in files]
            num_workers = min(len(files), os.cpu_count())

            with ThreadPoolExecutor(max_workers=num_workers) as executor:
                candidates = list(executor.map(process_resume, file_req_pairs))

            Candidate.objects.bulk_create(candidates, batch_size=100)

            return Response(api_json_response_format(
                True,
                f"{len(candidates)} resumes processed and candidates stored successfully.",
                201,
                {"processed_count": len(candidates)}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Failed to process bulk resume upload. " + str(e),
                500,
                {}
            ), status=200)


# def extract_info_from_text(text):
#     """Attempts AI-based name & email extraction, with fallback regex."""
#     prompt = f"""
#     Extract only the full name and email address from this resume.
#     Return data in JSON format: 
#     {{
#         "name": "[Full Name]",
#         "email": "[Email Address]"
#     }}
#     Resume Content: {text}
#     """
#     # ollama_model = OllamaLLM(base_url='http://ollama:11434', model='ats_model')
#     # response = ollama.chat(model='ats_model', messages=[{"role": "user", "content": prompt}])
#     # ai_output = response['message']['content']
#     # ai_output = ollama_model.invoke(prompt)
#     # return response.strip()
#     # Print AI response for debugging
#     try:
#         ai_output = ollama_model.invoke(prompt)
#     except Exception as e:
#         print("Ollama Error:", e)

#     print("AI Response:\n", ai_output)

#     # Try extracting using AI response JSON
#     name_match = re.search(r'"name":\s*"([^"]+)"', ai_output)
#     email_match = re.search(r'"email":\s*"([^"]+)"', ai_output)

#     if name_match and email_match:
#         return name_match.group(1), email_match.group(1)

#     # Fallback regex extraction if AI fails
#     name_fallback = re.search(r"Name:\s*(.*)", text)
#     email_fallback = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", text)

#     name = name_fallback.group(1) if name_fallback else "Unknown"
#     email = email_fallback.group(1) if email_fallback else "Not found"

#     return name, email

# def process_resume(file_req_tuple):
#     file, req_id = file_req_tuple

#     os.makedirs(RESUME_STORAGE_FOLDER, exist_ok=True)

#     file_path = os.path.join(RESUME_STORAGE_FOLDER, file.name)
#     with open(file_path, "wb") as f:
#         f.write(file.read())

#     text = extract_text_from_pdf(file)
#     name, email = extract_info_from_text(text)

#     return Candidate(
#         Name=name,
#         Email=email,
#         Resume=file_path,
#         Req_id_fk =req_id  # Set FK using ID to avoid query overhead
#     )


# class BulkUploadResumeView(APIView):
#     parser_classes = (MultiPartParser, FormParser)

#     def post(self, request, *args, **kwargs):
#         try:
#             req_id = request.data.get("req_id")
#             files = request.FILES.getlist("files")

#             if not files:
#                 return Response(api_json_response_format(
#                     False,
#                     "No files were uploaded.",
#                     400,
#                     {}
#                 ), status=200)
#             try:
#                 job_req = JobRequisition.objects.get(pk=req_id)
#                 print(job_req)
#             except JobRequisition.DoesNotExist:
#                 return Response(api_json_response_format(
#                     False, "Invalid requisition ID.", 400, {}
#                 ), status=200)

#             file_req_pairs = [(file, job_req) for file in files]
#             num_workers = min(len(files), os.cpu_count())

#             with ThreadPoolExecutor(max_workers=num_workers) as executor:
#                 candidates = list(executor.map(process_resume, file_req_pairs))

#             Candidate.objects.bulk_create(candidates, batch_size=100)

#             return Response(api_json_response_format(
#                 True,
#                 f"{len(candidates)} resumes processed and candidates stored successfully.",
#                 201,
#                 {"processed_count": len(candidates)}
#             ), status=200)

#         except Exception as e:
#             return Response(api_json_response_format(
#                 False,
#                 "Failed to process bulk resume upload. " + str(e),
#                 500,
#                 {}
            # ), status=200)

# model = SentenceTransformer("models/paraphrase-MiniLM-L6-v2")
# model.save("models/paraphrase-MiniLM-L6-v2")  # Save it locally
# print("Model saved to local folder.")


# def get_matching_score(job_description, resume_text, resume_name):
#     job_embedding = model.encode(job_description, convert_to_tensor=True)
#     resume_embedding = model.encode(resume_text[:2000], convert_to_tensor=True)
#     similarity = util.pytorch_cos_sim(job_embedding, resume_embedding).item()
#     percentage = round(similarity * 100)

#     return {
#         "resume_name": resume_name,
#         "percentage": percentage
#     }


# def extract_text_from_pdf(uploaded_file):
#     reader = pdf.PdfReader(uploaded_file)
#     text = ""
#     for page in reader.pages:
#         text += str(page.extract_text())
#     return text


# class ResumeMatchingAPI(APIView):
#     parser_classes = (MultiPartParser, FormParser)

#     def post(self, request):
#         try:
#             job_description = request.data.get('job_description')
#             uploaded_files = request.FILES.getlist('resumes')

#             if not job_description or not uploaded_files:
#                 return Response(api_json_response_format(
#                     False, "Missing job description or resume files.", 400, {}
#                 ), status=200)

#             results = []
#             for uploaded_file in uploaded_files:
#                 resume_text = extract_text_from_pdf(uploaded_file)
#                 score = get_matching_score(job_description, resume_text, uploaded_file.name)
#                 results.append(score)

#             return Response(api_json_response_format(
#                 True, "Matching scores calculated successfully!", 200, {"matching_scores": results}
#             ), status=200)

#         except Exception as e:
#             return Response(api_json_response_format(
#                 False, "Error while processing resumes. " + str(e), 500, {}
#             ), status=200)

class CandidateScreeningView(APIView):
    def post(self, request):
        candidate_id = request.data.get("candidate_id")

        if not candidate_id:
            return Response(api_json_response_format(
                False, "Missing candidate_id in request body", 400, {}
            ), status=200)

        try:
            candidate = Candidate.objects.get(pk=candidate_id)
        except Candidate.DoesNotExist:
            return Response(api_json_response_format(
                False, "Candidate not found", 404, {}
            ), status=200)

        reviews_data = request.data.get("reviews", [])
        final_rating = request.data.get("final_rating")
        final_feedback = request.data.get("final_feedback")
        result = request.data.get("result")

        review_instances = []
        for review in reviews_data:
            review_instances.append(
                CandidateReview(
                    CandidateID=candidate,
                    ParameterDefined=review.get("ParameterDefined"),
                    Guidelines=review.get("Guidelines"),
                    MinimumQuestions=review.get("MinimumQuestions"),
                    ActualRating=review.get("ActualRating"),
                    Feedback=review.get("Feedback")
                )
            )

        try:
            with transaction.atomic():
                CandidateReview.objects.bulk_create(review_instances)
                if final_rating is not None:
                    candidate.Final_rating = final_rating
                if final_feedback:
                    candidate.Feedback = final_feedback
                if result:
                    candidate.Result = result
                candidate.save()

            return Response(api_json_response_format(
                True, "Screening data submitted successfully", 201, {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, f"Error saving screening data: {e}", 500, {}
            ), status=200)

# class JobRequisitionViewSetget(viewsets.ReadOnlyModelViewSet):
#     queryset = JobRequisition.objects.all()
#     serializer_class = JobRequisitionSerializerget

#     def list(self, request):
#         try:
#             queryset = self.filter_queryset(self.get_queryset())
#             serializer = self.get_serializer(queryset, many=True)
#             return Response({
#                 "data": serializer.data,
#                 "status_code": 200
#             })
#         except Exception as e:
#             return Response({
#                 "error": "Error fetching job requisitions",
#                 "details": str(e),
#                 "status_code": 500
#             }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def extract_requested_fields(queryset, selected_fields, field_map):
    model_fields = set()
    field_lookup = {}  # display_name → actual ORM field path(s)

    for display in selected_fields:
        mapping = field_map.get(display)
        if isinstance(mapping, str):
            model_fields.add(mapping)
            field_lookup[display] = [mapping]
        elif isinstance(mapping, list):
            model_fields.update(mapping)
            field_lookup[display] = mapping
        else:
            field_lookup[display] = []

    data = list(queryset.values(*model_fields))
    result = []

    for row in data:
        flat = {}
        for display, fields in field_lookup.items():
            if fields:
                values = [row.get(f) for f in fields if f in row]
                flat[display] = values[0] if len(values) == 1 else values if any(values) else None
            else:
                flat[display] = None
        result.append(flat)

    return result

class JobRequisitionFlatViewSet(viewsets.ViewSet):
    def create(self, request):
        try:
            selected_fields = request.data.get("fields", [])
            if not isinstance(selected_fields, list) or not selected_fields:
                return Response(
                    api_json_response_format(False, "Missing or invalid 'fields' parameter.", 400, {}),
                    status=200
                )

            queryset = JobRequisition.objects.select_related("details", "Planning_id")
            result_data = extract_requested_fields(queryset, selected_fields, DISPLAY_TO_MODEL_FIELD)

            return Response(
                api_json_response_format(True, "Dynamic field data fetched successfully!", 200, {
                    "data": result_data,
                    "selected_fields": selected_fields
                }),
                status=200
            )

        except Exception as e:
            return Response(
                api_json_response_format(False, "Failed to retrieve dynamic field data"+str(e), 500, {}),
                status=200
            )

class JobRequisitionPublicViewSet(viewsets.ViewSet):
    def list(self, request):
        try:
            requisitions = JobRequisition.objects.prefetch_related(
                'interview_team', 'teams'
            ).select_related('details', 'billing_details', 'posting_details')

            data = []
            for obj in requisitions:
                job_template_data = JobTemplateSerializer({
                    "requisition_details": getattr(obj, "details", None),
                    "billing": getattr(obj, "billing_details", None),
                    "posting": getattr(obj, "posting_details", None),
                    "interviewers": obj.interview_team.all(),
                    "functional_teams": obj.teams.all(),
                }).data
                data.append(job_template_data)

            return Response(api_json_response_format(
                True,
                "Job templates retrieved successfully!",
                200,
                {"job_template": data}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error while fetching data for template"+str(e),
                500,
                {}
            ), status=200)

class JobRequisitionViewSet(viewsets.ModelViewSet):
    queryset = JobRequisition.objects.select_related("HiringManager").all()
    serializer_class = JobRequisitionSerializer

    def create(self, request, *args, **kwargs):
        try:
            user_role = request.data.get("user_role")
            if user_role is None:
                return Response(api_json_response_format(False, "User role is required.", 400, {}), status=200)

            if user_role != 1:
                return Response(api_json_response_format(False, "Only Hiring Managers can create requisitions.", 403, {}), status=200)

            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            job_requisition = serializer.save()
            send_email()  # Optional

            return Response(api_json_response_format(True, "Job requisition created successfully!", 201, {
                "requisition_id": job_requisition.RequisitionID
            }), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error while creating requisition."+str(e), 500, {}), status=200)
    
    @action(detail=False, methods=['put'], url_path='update-requisition')
    def update_requisition(self, request):
        try:
            user_role = request.data.get("user_role")
            requisition_id = request.data.get("requisition_id")

            if user_role != 1:
                return Response(api_json_response_format(False, "Only Hiring Managers can update requisitions.", 403, {}), status=200)
            if not requisition_id:
                return Response(api_json_response_format(False, "requisition_id is required.", 400, {}), status=200)

            try:
                instance = JobRequisition.objects.get(pk=requisition_id)
            except JobRequisition.DoesNotExist:
                return Response(api_json_response_format(False, "Job requisition not found.", 404, {}), status=200)

            serializer = self.get_serializer(instance, data=request.data, partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()

            return Response(api_json_response_format(True, "Job requisition updated successfully!", 200, {
                "requisition_id": serializer.instance.RequisitionID
            }), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error while updating requisition. " + str(e), 500, {}), status=200)

        
    @action(detail=False, methods=['delete'], url_path='delete-requisition')
    def delete_requisition(self, request):
        try:
            user_role = request.data.get("user_role")
            requisition_id = request.data.get("requisition_id")

            if user_role != 1:
                return Response(api_json_response_format(False, "Only Hiring Managers can delete requisitions.", 403, {}), status=200)
            if not requisition_id:
                return Response(api_json_response_format(False, "requisition_id is required.", 400, {}), status=200)

            try:
                requisition = JobRequisition.objects.get(pk=requisition_id)
            except JobRequisition.DoesNotExist:
                return Response(api_json_response_format(False, "Job requisition not found.", 404, {}), status=200)

            requisition.delete()
            return Response(api_json_response_format(True, "Job requisition deleted successfully!", 200, {}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error while deleting requisition. " + str(e), 500, {}), status=200)

    def list(self, request, *args, **kwargs):
        try:
            user_role = request.data.get("user_role")

            if user_role == 2:
                queryset = JobRequisition.objects.filter(Status="Approved")
                data = []
                for requisition in queryset:
                    data.append({
                        "RequisitionID": requisition.RequisitionID,
                        "JobTitle": requisition.PositionTitle,
                        "HiringManagerName": getattr(requisition.HiringManager, "Name", "Unknown"),
                        "StartDate": requisition.details.contract_start_date if hasattr(requisition, "details") else "Not Provided",
                        "DueDate": requisition.details.contract_end_date if hasattr(requisition, "details") else "Not Provided",
                        "HiringStatus": requisition.Status
                    })
                return Response(api_json_response_format(True, "Job requisitions retrieved successfully!", 200, data), status=200)

            elif user_role == 3:
                queryset = JobRequisition.objects.all()
            elif user_role == 1:
                queryset = JobRequisition.objects.filter(HiringManager=request.user)
            else:
                return Response(api_json_response_format(False, "Unauthorized", 403, {}), status=200)

            serializer = self.get_serializer(queryset, many=True)
            return Response(api_json_response_format(True, "Job requisitions retrieved successfully!", 200, serializer.data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error fetching job requisitions."+ str(e), 500, {}), status=200)

    @action(detail=False, methods=["POST"])
    def approve_requisition(self, request):
        try:
            user_role = request.data.get("user_role")
            requisition_id = request.data.get("req_id")

            if user_role != 3:
                return Response(api_json_response_format(False, "Only Business Ops can approve requisitions.", 403, {}), status=200)

            requisition = get_object_or_404(JobRequisition, pk=requisition_id)
            requisition.Status = "Approved"
            requisition.save()

            return Response(api_json_response_format(True, "Job requisition approved!", 200, {"status": requisition.Status}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error approving requisition."+ str(e), 500, {}), status=200)

    @action(detail=False, methods=["POST"])
    def get_approved_extra_details(self, request):
        try:
            user_role = request.data.get("user_role")

            if user_role not in [2, 3]:
                return Response(api_json_response_format(False, "Unauthorized access.", 403, {}), status=200)

            approved_ids = JobRequisition.objects.filter(Status="Approved").values_list("RequisitionID", flat=True)
            details = RequisitionDetails.objects.filter(requisition_id__in=approved_ids).order_by("requisition_id")

            data = [{
                "requisition_id": d.requisition_id,
                "internal_title": d.internal_title,
                "external_title": d.external_title,
                "position": d.job_position,
                "business_line": d.business_line,
                "business_unit": d.business_unit,
                "division": d.division,
                "department": d.department,
                "location": d.location,
                "geo_zone": d.geo_zone,
                "employee_group": d.employee_group,
                "employee_sub_group": d.employee_sub_group,
                "contract_start_date": d.contract_start_date.isoformat() if d.contract_start_date else "",
                "contract_end_date": d.contract_end_date.isoformat() if d.contract_end_date else "",
                "career_level": d.career_level,
                "band": d.band,
                "sub_band": d.sub_band,
                "primary_skills": d.primary_skills,
                "secondary_skills": d.secondary_skills,
                "mode_of_working": d.working_model,
                "requisition_type": d.requisition_type,
                "client_interview": d.client_interview,
                "required_score": d.required_score,
                "onb_coordinator": d.onb_coordinator,
                "onb_coordinator_team": d.onb_coordinator_team,
                "isg_team": d.isg_team,
                "interviewer_teammate_employee_id": d.interviewer_teammate_employee_id
            } for d in details]

            return Response(api_json_response_format(True, "Extra requisition details retrieved successfully!", 200, data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error retrieving extra requisition details."+ str(e), 500, {}), status=200)

    @action(detail=False, methods=["POST"])
    def get_requisition_by_id(self, request):
        try:
            requisition_id = request.data.get("req_id")

            if not requisition_id:
                return Response(api_json_response_format(False, "Requisition ID is required.", 400, {}), status=200)

            requisition = get_object_or_404(JobRequisition, pk=requisition_id)
            serializer = self.get_serializer(requisition)

            return Response(api_json_response_format(True, "Requisition retrieved successfully!", 200, serializer.data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error retrieving requisition."+ str(e), 500, {"details": str(e)}), status=200)





def get_matching_score(job_description, resume_text, resume_name):
    """Send job description and resume to Ollama model and get only the matching score"""
    prompt = f"""
    You are an AI-powered resume analysis agent.
    Given a job description, compare multiple resumes.
    
    For each resume, **ONLY return the JSON output**:
    
    {{
        "resume_name": "{resume_name}",
        "percentage": 90
    }}

    **DO NOT** provide additional analysis, explanations, keywords, or recommendations.
    
    Job Description: {job_description}
    Resume Text:{resume_text[:2000]} 

    """
    # response = ollama.chat(model='ats_model:latest', messages=[{"role": "user", "content": prompt}])
    # ai_output = response['message']['content']
    response = ollama_model.invoke(prompt)
    return response.strip()  # Remove unnecessary formatting

class ResumeMatchingAPI(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request):
        """Handles resume uploads and returns matching scores only"""
        try:
            job_description = request.data.get('job_description')
            uploaded_files = request.FILES.getlist('resumes')

            if not job_description or not uploaded_files:
                return Response(api_json_response_format(
                    False, "Missing job description or resume files.",400, {}
                ), status=200)

            results = []
            for uploaded_file in uploaded_files:
                resume_text = extract_text_from_pdf(uploaded_file)
                score = get_matching_score(job_description, resume_text, uploaded_file.name)
                results.append(score)

            return Response(api_json_response_format(
                True, "Matching scores calculated successfully!", 200, {"matching_scores": results}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, "Error while processing resumes."+ str(e), 500, {}
            ), status=200)

def send_email():
    send_mail(
        'Job Requsition Added',
        'Please verify and Approve the added job requsition.',
        settings.EMAIL_HOST_USER,
        ['anandsivakumar27@gmail.com'],
        fail_silently=False,
    )


    
def generate_jwt_token(user):
    """ Generate JWT Token """
    payload = {
        'user_id': user.UserID,
        'email': user.Email,
        'role': UserroleDetails.objects.get(RoleID=user.RoleID).RoleName,
        'exp': datetime.datetime.now() + datetime.timedelta(hours=12)  # Token expires in 1 hour
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')


@csrf_exempt
@api_view(['POST'])
def login_page(request):
    auth_header = request.headers.get("Authorization")

    if not auth_header or not auth_header.startswith("Basic "):
        return Response(api_json_response_format(False, "Authorization header missing or incorrect", 401, {}))

    try:
        _, encoded_credentials = auth_header.split(" ")
        decoded_credentials = base64.b64decode(encoded_credentials).decode("utf-8")
        username, password = decoded_credentials.split(":")
    except Exception as e:
        return Response(api_json_response_format(False, "Invalid credentials encoding. " + str(e), 401, {}))

    try:
        user = UserDetails.objects.get(Email=username)
        userrole = UserroleDetails.objects.get(RoleID=user.RoleID)

        if not check_password(password, user.PasswordHash):
            raise UserDetails.DoesNotExist  # reuse the same error logic

        refresh = RefreshToken.for_user(user)
        response_data = {
            'role': userrole.RoleName,
            'user_id':user.id,
            'username': user.Name,
            'access': str(refresh.access_token),
            'refresh': str(refresh)
        }
        return Response(api_json_response_format(True, "Login successful", 200, response_data))

    except UserDetails.DoesNotExist:
        return Response(api_json_response_format(False, "Invalid username or password USER_NOT_FOUND", 400, {}))


class ForgotPasswordView(APIView):
    def post(self, request):
        try:
            email = request.data.get("email")
            user = get_object_or_404(UserDetails, Email=email)

            reset_token = get_random_string(32)
            user.ResetToken = reset_token
            user.save()

            send_mail(
                "Password Reset Request",
                f"Your reset token is: {reset_token}",
                "noreply@example.com",
                [user.Email],
                fail_silently=False,
            )

            return Response(api_json_response_format(
                True,
                "Reset token sent to email",
                200,
                {"email": user.Email}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error while sending reset token."+ str(e),500,
                {}
            ), status=200)

class ResetPasswordView(APIView):
    def post(self, request):
        try:
            reset_token = request.data.get("token")
            new_password = request.data.get("new_password")

            user = get_object_or_404(UserDetails, ResetToken=reset_token)
            user.PasswordHash = make_password(new_password)
            user.ResetToken = None
            user.save()

            return Response(api_json_response_format(
                True,
                "Password reset successful",
                200,
                {"email": user.Email}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error while resetting password."+ str(e),
                500,
                {}
            ), status=200)
    
class InterviewPlannerCalculation(APIView):
    def post(self, request):
        try:
            dead_line_days = int(request.data.get('dead_line_days'))
            offer_decline = int(request.data.get('offer_decline'))
            working_hours_per_day = int(request.data.get('working_hours_per_day'))
            no_of_roles_to_hire = int(request.data.get('no_of_roles_to_hire'))
            conversion_ratio = int(request.data.get('conversion_ratio'))
            elimination = int(request.data.get('elimination'))  # currently unused
            avg_interviewer_time_per_week_hrs = int(request.data.get('avg_interviewer_time_per_week_hrs'))
            interview_round = int(request.data.get('interview_round'))
            interview_time_per_round = int(request.data.get('interview_time_per_round'))
            interviewer_leave_days = int(request.data.get('interviewer_leave_days'))
            no_of_month_interview_happens = int(request.data.get('no_of_month_interview_happens'))  # currently unused
            working_hrs_per_week = int(request.data.get('working_hrs_per_week'))

            required_candidate = int(no_of_roles_to_hire * conversion_ratio)
            decline_adjust_count = (required_candidate * offer_decline) / 100
            total_candidate_pipline = required_candidate + decline_adjust_count
            total_interviews_needed = total_candidate_pipline * interview_round
            total_interview_hrs = total_interviews_needed * interview_time_per_round
            total_interview_weeks = total_interview_hrs / working_hrs_per_week
            no_of_interviewer_need = total_interview_hrs / dead_line_days
            leave_adjustment = round(
                no_of_interviewer_need + (
                    ((interviewer_leave_days * avg_interviewer_time_per_week_hrs) /
                     (dead_line_days * working_hours_per_day)) * no_of_interviewer_need
                )
            )

            return Response(api_json_response_format(
                True,
                "Interview planning calculation completed.",
                201,
                {
                    "required_candidate": required_candidate,
                    "decline_adjust_count": decline_adjust_count,
                    "total_candidate_pipline": total_candidate_pipline,
                    "total_interviews_needed": total_interviews_needed,
                    "total_interview_hrs": total_interview_hrs,
                    "working_hrs_per_week": working_hrs_per_week,
                    "total_interview_weeks": total_interview_weeks,
                    "no_of_interviewer_need": no_of_interviewer_need,
                    "leave_adjustment": leave_adjustment
                }
            ), status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error during interview planning calculation.",500,
                {}
            ), status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# @parser_classes([MultiPartParser, FormParser])
class HiringPlanOverviewDetails(APIView):
    def get(self, request):
        try:
            raw_fields = request.query_params.get("fields")
            if raw_fields:
                selected_fields = [f.strip() for f in raw_fields.split(",") if f.strip()]
            else:
                selected_fields = []

            if selected_fields:
                # Use only Planning-related fields
                planning_fields_map = {
                    key: val for key, val in DISPLAY_TO_MODEL_FIELD.items()
                    if isinstance(val, str) and val.startswith("Planning_id__") or
                       isinstance(val, list) and all(f.startswith("Planning_id__") for f in val)
                }

                queryset = HiringPlan.objects.select_related("JobRequisition_id", "JobRequisition_id__details")
                result_data = extract_requested_fields(queryset, selected_fields, planning_fields_map)

                return Response(api_json_response_format(
                    True, "Filtered hiring plan data retrieved successfully!", 200, {
                        "hiring_plans": result_data,
                        "selected_fields": selected_fields
                    }), status=200)

            # Fallback to full serializer if no dynamic fields requested
            hiring_plan = HiringPlan.objects.all()
            serializer = HiringPlanSerializer(hiring_plan, many=True)
            return Response(api_json_response_format(
                True, "Hiring plans retrieved successfully.", 200, {
                    "hiring_plans": serializer.data
                }), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, "Error retrieving hiring plans. " + str(e), 500, {}), status=200)


    def post(self, request, *args, **kwargs):
        serializer = HiringPlanSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(api_json_response_format(
                True,
                "Hiring plan created successfully.",
                201,
                {
                    "hiring_plan_id": instance.hiring_plan_id,
                    "job_position": instance.job_position
                }
            ), status=200)
        return Response(api_json_response_format(
            False,
            "Validation error while creating hiring plan."+serializer.errors,
            400,
            {}
        ), status=200)

    def put(self, request):
        hiring_plan_id = request.data.get('hiring_plan_id')
        if not hiring_plan_id:
            return Response(api_json_response_format(
                False,
                "Hiring Plan ID is required in request body.",400,
                {}
            ), status=200)
        try:
            instance = HiringPlan.objects.get(hiring_plan_id=hiring_plan_id)
        except HiringPlan.DoesNotExist:
            return Response(api_json_response_format(
                False,
                "Hiring plan not found.",
                404,
                {}
            ), status=200)

        serializer = HiringPlanSerializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(api_json_response_format(
                True,
                "Hiring plan updated successfully.",
                200,
                serializer.data
            ), status=200)
        return Response(api_json_response_format(
            False,
            "Validation error while updating hiring plan."+serializer.errors,400,
            {}
        ), status=200)

    def delete(self, request):
        hiring_plan_id = request.data.get('hiring_plan_id')
        if not hiring_plan_id:
            return Response(api_json_response_format(
                False,
                "Hiring Plan ID is required in request body.",400,
                {}
            ), status=200)

        obj = get_object_or_404(HiringPlan, hiring_plan_id=hiring_plan_id)
        obj.delete()
        return Response(api_json_response_format(
            True,
            "Hiring plan deleted successfully.",
            204,
            {}
        ), status=204)        

@api_view(['GET'])
def get_hiring_plans(request):
    try:
        hiring_plans = HiringPlan.objects.all()
        serializer = HiringPlanSerializer(hiring_plans, many=True)

        filtered_data = [
            {'hiring_plan_id': item['hiring_plan_id'], 'job_position': item['job_position']}
            for item in serializer.data
        ]

        return Response(api_json_response_format(
            True,
            "Hiring plan detail fetched successfully!",
            200,
            {"plans": filtered_data}
        ), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False,
            "Error retrieving hiring plan list."+str(e),500,
            {}
        ), status=200)

@api_view(['POST'])
def get_hiring_plans(request):
    try:
        selected_fields = request.data.get("fields", [])
        if not isinstance(selected_fields, list) or not selected_fields:
            return Response(api_json_response_format(
                False, "Missing or invalid 'fields' parameter.", 400, {}), status=200)

        queryset = HiringPlan.objects.select_related("JobRequisition_id", "JobRequisition_id__details")

        # Filtered field map (Planning_id only)
        planning_fields_map = {
            "id": "hiring_plan_id",  # ensure this field is manually injected
            **{
                key: val for key, val in DISPLAY_TO_MODEL_FIELD1.items()
                if isinstance(val, str) or (isinstance(val, list) and all(isinstance(f, str) for f in val))
            }
        }


        result_data = extract_requested_fields(queryset, selected_fields, planning_fields_map)

        return Response(api_json_response_format(
            True, "Filtered hiring plan data retrieved successfully!", 200, {
                "data": result_data,
                "selected_fields": selected_fields
            }), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False, "Error retrieving hiring plan data. " + str(e), 500, {}), status=200)


@api_view(['GET'])
def get_all_plan_ids(request):
    plans = HiringPlan.objects.all().values_list('hiring_plan_id', flat=True)
    return Response(api_json_response_format(
        True,
        "All plan IDs fetched successfully!",
        200,
        {'plan_ids': list(plans)}
    ), status=200)

@api_view(['POST'])
def get_hiring_plan_details(request):
    hiring_plan_id = request.data.get('hiring_plan_id')

    if not hiring_plan_id:
        return Response(api_json_response_format(
            False,
            "No hiring_plan_id provided.",400,
            {}
        ), status=200)

    try:
        hiring_plan = HiringPlan.objects.get(hiring_plan_id=hiring_plan_id)
        serializer = HiringPlanSerializer(hiring_plan)
        return Response(api_json_response_format(
            True,
            "Hiring plan detail fetched successfully!",
            200,
            serializer.data
        ), status=200)

    except HiringPlan.DoesNotExist:
        return Response(api_json_response_format(
            False,
            "Hiring plan not found.",
            "HIRING_PLAN_NOT_FOUND",
            {}
        ), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False,
            "Error retrieving hiring plan. "+ str(e),500,
            {}
        ), status=200)


class HiringInterviewRounds(APIView):
    def get(self, request):
        try:
            hiring_rounds = InterviewRounds.objects.all()
            serializer = HiringInterviewRoundsSerializer(hiring_rounds, many=True)
            return Response(api_json_response_format(
                True,
                "Interview rounds fetched successfully.",
                200,
                {"rounds": serializer.data}
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error fetching interview rounds."+str(e),
                500,
                {"details": str(e)}
            ), status=200)

    def post(self, request):
        try:
            requisition_id = request.data.get('requisition_id')
            round_name_list = request.data.get('round_name', [])

            if not requisition_id or not round_name_list:
                return Response(api_json_response_format(
                    False,
                    "Missing requisition_id or round_name list.",
                    400,
                    {}
                ), status=200)

            data_to_insert = [
                {"requisition_id": requisition_id, "round_name": name}
                for name in round_name_list
            ]

            serializer = HiringInterviewRoundsSerializer(data=data_to_insert, many=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(
                    True,
                    "Interview rounds created successfully.",
                    201,
                    serializer.data
                ), status=200)
            return Response(api_json_response_format(
                False,
                "Validation failed while creating interview rounds."+serializer.errors,
                400,
                {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Unexpected error during round creation."+str(e),
                500,
                {}
            ), status=200)

    def put(self, request):
        requisition_id = request.data.get('id')
        if not requisition_id:
            return Response(api_json_response_format(
                False,
                "Hiring Plan ID is required in request body.",
                400,
                {}
            ), status=200)

        try:
            instance = InterviewRounds.objects.get(id=requisition_id)
        except InterviewRounds.DoesNotExist:
            return Response(api_json_response_format(
                False,
                "Interview round not found.",
                404,
                {}
            ), status=200)

        serializer = HiringInterviewRoundsSerializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(api_json_response_format(
                True,
                "Interview round updated successfully.",
                200,
                serializer.data
            ), status=200)
        return Response(api_json_response_format(
            False,
            "Validation error while updating interview round."+serializer.errors,
            400,
            {}
        ), status=200)
    
class HiringInterviewSkills(APIView):
    def post(self, request):
        try:
            requisition_id = request.data.get('requisition_id')
            skill_name_list = request.data.get('skill_name', [])
            skill_value_list = request.data.get('skill_value', [])

            if not requisition_id or not skill_name_list or not skill_value_list:
                return Response(api_json_response_format(
                    False,
                    "Missing requisition_id or skill data.",
                    400,
                    {}
                ), status=200)

            if len(skill_name_list) != len(skill_value_list):
                return Response(api_json_response_format(
                    False,
                    "skill_name and skill_value must have same number of items.",
                    400,
                    {}
                ), status=200)

            data_to_insert = [
                {"requisition_id": requisition_id, "skill_name": name, "skill_value": value}
                for name, value in zip(skill_name_list, skill_value_list)
            ]

            serializer = HiringSkillsSerializer(data=data_to_insert, many=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(
                    True,
                    "Interview skills created successfully!",
                    201,
                    serializer.data
                ), status=200)

            return Response(api_json_response_format(
                False,
                "Validation error while creating interview skills."+serializer.errors,
                400,
                {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Unexpected error during interview skills creation."+str(e),
                500,
                {}
            ), status=200)
        

class InterviewDesignScreenView(APIView):
    def get(self, request):
        try:
            data = InterviewDesignScreen.objects.all()
            serializer = InterviewDesignScreenSerializer(data, many=True)
            return Response(api_json_response_format(
                True,
                "Interview Design Screen Details retrieved successfully!",
                0,
                {"interview_designs": serializer.data}
            ))
        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error retrieving interview design screens.",
                "HIRING_PLAN_FETCH_ERROR",
                {"details": str(e)}
            ), status=500)

        
    def post(self, request, *args, **kwargs):
        try:
            design_params = request.data.get("params", [])
            interview_design = request.data.copy()
            interview_design.pop("params", None)

            serializer = InterviewDesignScreenSerializer(data=interview_design)
            if serializer.is_valid():
                instance = serializer.save()
                interview_design_id = instance.interview_design_id

                
                for obj in design_params:
                    obj["interview_design_id"] = interview_design_id
                    obj["hiring_plan_id"] = interview_design.get("hiring_plan_id", 0)
                
                serializer_params = InterviewDesignParametersSerializer(data=design_params, many=True)
                if serializer_params.is_valid():
                    serializer_params.save()
                    return Response(api_json_response_format(True,"Interview Desing Screeen Details Updated Successfully!",0,serializer.data))
                else:
                    return Response(api_json_response_format(False,"Could not save Interview desing "+str(serializer_params.errors),status.HTTP_400_BAD_REQUEST,{}))
                    # return Response(serializer_params.errors, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(api_json_response_format(False,"Could not save Interview desing "+str(serializer_params.errors),status.HTTP_400_BAD_REQUEST,{}))
        except Exception as e:
            return Response(api_json_response_format(False,"Could not save Interview desing "+str(e),500,{}))


      
class StateAlertResposibilityView(APIView):
    def get(self, request):
        try:
            hiring_plan_id = request.query_params.get('hiring_plan_id')  # Changed from request.data.get
            if hiring_plan_id:
                queryset = StageAlertResponsibility.objects.filter(hiring_plan_id=hiring_plan_id)
            else:
                queryset = StageAlertResponsibility.objects.all()

            serializer = StageAlertResponsibilitySerializer(queryset, many=True)
            return Response(api_json_response_format(
                True,
                "Stage alert and responsibility settings details retrieved successfully.",
                200,
                {"stage_alert_and_responsibility": serializer.data}
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error retrieving stage alert and responsibility settings: " + str(e),
                500,
                {}
            ), status=500)

    def post(self, request):
        try:      
            serializer = StageAlertResponsibilitySerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Stage alert and responsibility settings Details updated Successfully!.",201,serializer.data), status=200)

            return Response(api_json_response_format(
                False,
                "Could not update Stage alert and responsibility settings Details",
                201,
                {
                }
            ), status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error during Could not update Stage alert and responsibility settings Details "+str(e),
                500,
                {}
            ), status=status.HTTP_200_OK)
        

class CandidateInterviewStagesView(APIView):
    def get(self, request):
        try:
            db_model = CandidateInterviewStages.objects.all()
            serializer = CandidateInterviewStagesSerializer(db_model, many=True)
            
            return Response(api_json_response_format(True,"Interviwer Calender Details Details.",200,serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False,"Error during get Interviwer Calender Details  "+str(e),500,{}), status=status.HTTP_200_OK)
            
    def post(self, request):
        try:             
            serializer = CandidateInterviewStagesSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Interviwer Calender Details updated Successfully!.",201,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Interviwer Calender Details Details",201,{}), status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response(api_json_response_format(False,"Error during Could not update Interviwer Calender Details Details "+str(e),500,{}), status=status.HTTP_200_OK)
     


    

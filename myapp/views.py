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
from .models import Posting, RequisitionDetails, UserDetails,Candidates,UserroleDetails
from rest_framework.parsers import MultiPartParser, FormParser
from django.views.decorators.csrf import csrf_exempt
import json
from .models import JobRequisition

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
from .serializers import JobRequisitionCompactSerializer, JobRequisitionSerializer,JobRequisitionSerializerget, JobTemplateSerializer
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



RESUME_STORAGE_FOLDER = "media/resumes"

DISPLAY_TO_MODEL_FIELD = {
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


def extract_text_from_pdf(file):
    """Extracts text from PDF using PyMuPDF."""
    text = ""
    with fitz.open(stream=file.read(), filetype="pdf") as pdf:
        text = "\n".join(page.get_text("text") for page in pdf)
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
    Resume Content: {text}
    """
    # ollama_model = OllamaLLM(base_url='http://ollama:11434', model='ats_model')
    # response = ollama.chat(model='ats_model', messages=[{"role": "user", "content": prompt}])
    # ai_output = response['message']['content']
    # ai_output = ollama_model.invoke(prompt)
    # return response.strip()
    # Print AI response for debugging
    try:
        ai_output = ollama_model.invoke(prompt)
    except Exception as e:
        print("Ollama Error:", e)

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

def process_resume(file):
    """Processes a single resume - extracts text, stores file, then extracts name/email."""
    
    # Ensure storage folder exists
    os.makedirs(RESUME_STORAGE_FOLDER, exist_ok=True)

    # Save the resume to the media/resumes folder
    file_path = os.path.join(RESUME_STORAGE_FOLDER, file.name)
    with open(file_path, "wb") as f:
        f.write(file.read())

    # Extract text from PDF
    text = extract_text_from_pdf(file)

    # Extract name and email using AI with fallback
    name, email = extract_info_from_text(text)

    return Candidate(Name=name, Email=email, Resume=file_path)


class BulkUploadResumeView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        try:
            files = request.FILES.getlist("files")
            if not files:
                return Response(api_json_response_format(
                    False,
                    "No files were uploaded.",
                    400,
                    {}
                ), status=200)

            num_workers = min(len(files), os.cpu_count())
            with ThreadPoolExecutor(max_workers=num_workers) as executor:
                candidates = list(executor.map(process_resume, files))

            Candidate.objects.bulk_create(candidates)

            return Response(api_json_response_format(
                True,
                f"{len(candidates)} resumes processed and candidates stored successfully.",
                201,
                {"processed_count": len(candidates)}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Failed to process bulk resume upload."+str(e),
                500,
                {}
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



def extract_text_from_pdf(uploaded_file):
    """Extracts text from a PDF file"""
    reader = pdf.PdfReader(uploaded_file)
    text = ""
    for page in reader.pages:
        text += str(page.extract_text())
    return text

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
            hiring_plan = HiringPlan.objects.all()
            serializer = HiringPlanSerializer(hiring_plan, many=True)
            return Response(api_json_response_format(
                True,
                "Hiring plans retrieved successfully.",
                200,
                {"hiring_plans": serializer.data}
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error retrieving hiring plans."+ str(e),500,
                {}
            ), status=200)

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

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
from .jwt_token import jwt_required


RESUME_STORAGE_FOLDER = "media/resumes"

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
    #@jwt_required
    def post(self, request, *args, **kwargs):
        files = request.FILES.getlist("files")

        num_workers = min(len(files), os.cpu_count())  # Optimize worker count
        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            candidates = list(executor.map(process_resume, files))

        Candidate.objects.bulk_create(candidates)

        return Response({"message": f"{len(candidates)} resumes processed and candidates stored efficiently!"})



class JobRequisitionViewSetget(viewsets.ReadOnlyModelViewSet):
    queryset = JobRequisition.objects.all()
    serializer_class = JobRequisitionSerializerget

    def list(self, request):
        try:
            queryset = self.filter_queryset(self.get_queryset())
            serializer = self.get_serializer(queryset, many=True)
            return Response({
                "data": serializer.data,
                "status_code": 200
            })
        except Exception as e:
            return Response({
                "error": "Error fetching job requisitions",
                "details": str(e),
                "status_code": 500
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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

            return Response({"job_template": data, "status_code": 200})
        
        except Exception as e:
            return Response({
                "error": "Error while fetching data for template",
                "details": str(e),
                "status_code": 500
            })

class JobRequisitionViewSet(viewsets.ModelViewSet):
    queryset = JobRequisition.objects.select_related("HiringManager").all()
    serializer_class = JobRequisitionSerializer

    def create(self, request, *args, **kwargs):
        try:
            user_role = request.data.get("user_role")

            if user_role is None:
                return Response({"error": "User role is required.", "error_code": "ROLE_MISSING", "status_code": 400},
                                status=status.HTTP_400_BAD_REQUEST)

            if user_role != 1:
                return Response({"error": "Only Hiring Managers can create requisitions.", "error_code": "UNAUTHORIZED_CREATION", "status_code": 403},
                                status=status.HTTP_403_FORBIDDEN)

            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            job_requisition = serializer.save()
            send_email()  # if applicable

            return Response({
                "message": "Job requisition created successfully!",
                "requisition_id": job_requisition.RequisitionID,
                "status_code": 201
            }, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({
                "error": "Error while creating requisition.",
                "error_code": "CREATE_FAILED",
                "details": str(e),
                "status_code": 500
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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
                return Response({
                    "message": "Job requisitions retrieved successfully!",
                    "data": data,
                    "status_code": 200
                }, status=status.HTTP_200_OK)

            elif user_role == 3:
                queryset = JobRequisition.objects.all()

            elif user_role == 1:
                queryset = JobRequisition.objects.filter(HiringManager=request.user)

            else:
                return Response({"error": "Unauthorized", "error_code": "INVALID_ROLE", "status_code": 403},
                                status=status.HTTP_403_FORBIDDEN)

            serializer = self.get_serializer(queryset, many=True)
            return Response({
                "message": "Job requisitions retrieved successfully!",
                "data": serializer.data,
                "status_code": 200
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                "error": "Error fetching job requisitions.",
                "error_code": "LISTING_ERROR",
                "details": str(e),
                "status_code": 500
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=["POST"])
    def approve_requisition(self, request):
        try:
            user_role = request.data.get("user_role")
            requisition_id = request.data.get("req_id")

            if user_role != 3:
                return Response({"error": "Only Business Ops can approve requisitions.", "error_code": "UNAUTHORIZED_APPROVAL", "status_code": 403},
                                status=status.HTTP_403_FORBIDDEN)

            requisition = get_object_or_404(JobRequisition, pk=requisition_id)
            requisition.Status = "Approved"
            requisition.save()

            return Response({
                "message": "Job requisition approved!",
                "status": requisition.Status,
                "status_code": 200
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                "error": "Error approving requisition.",
                "error_code": "APPROVAL_ERROR",
                "details": str(e),
                "status_code": 500
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=["POST"])
    def get_approved_extra_details(self, request):
        try:
            user_role = request.data.get("user_role")

            if user_role not in [2, 3]:
                return Response({"error": "Unauthorized access.", "error_code": "ACCESS_DENIED", "status_code": 403},
                                status=status.HTTP_403_FORBIDDEN)

            approved_ids = list(JobRequisition.objects.filter(Status="Approved")
                                .values_list("RequisitionID", flat=True))

            details = RequisitionDetails.objects.filter(requisition_id__in=approved_ids).order_by("requisition_id")

            data = [{
                "requisition_id": d.requisition_id,
                "internal_title": d.internal_title,
                "external_title": d.external_title,
                "position": d.position,
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
                "mode_of_working": d.mode_of_working,
                "requisition_type": d.requisition_type,
                "client_interview": d.client_interview,
                "required_score": d.required_score,
                "onb_coordinator": d.onb_coordinator,
                "onb_coordinator_team": d.onb_coordinator_team,
                "isg_team": d.isg_team,
                "interviewer_teammate_employee_id": d.interviewer_teammate_employee_id,
            } for d in details]

            return Response({
                "message": "Extra requisition details retrieved successfully!",
                "data": data,
                "status_code": 200
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                "error": "Error retrieving extra requisition details.",
                "error_code": "DETAIL_FETCH_ERROR",
                "details": str(e),
                "status_code": 500
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=["POST"])
    def get_requisition_by_id(self, request):
        try:
            requisition_id = request.data.get("req_id")

            if not requisition_id:
                return Response({"error": "Requisition ID is required.", "error_code": "MISSING_ID", "status_code": 400},
                                status=status.HTTP_400_BAD_REQUEST)

            requisition = get_object_or_404(JobRequisition, pk=requisition_id)
            serializer = self.get_serializer(requisition)

            return Response({
                "message": "Requisition retrieved successfully!",
                "data": serializer.data,
                "status_code": 200
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                "error": "Error retrieving requisition.",
                "error_code": "REQ_FETCH_ERROR",
                "details": str(e),
                "status_code": 500
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


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
    #@jwt_required
    def post(self, request):
        """Handles resume uploads and returns matching scores only"""
        job_description = request.data.get('job_description')
        uploaded_files = request.FILES.getlist('resumes')  

        results = []
        for uploaded_file in uploaded_files:
            resume_text = extract_text_from_pdf(uploaded_file)
            score = get_matching_score(job_description, resume_text, uploaded_file.name)
            results.append(score)

        return Response({"matching_scores": results})




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
def login_page(request):
    if request.method == "POST":
        auth_header = request.headers.get("Authorization")

        if not auth_header or not auth_header.startswith("Basic "):
            return JsonResponse({
                'error': 'Authorization header missing or incorrect',
                'error_code': 'AUTH_HEADER_INVALID',
                'status_code': 401
            }, status=401)

        try:
            _, encoded_credentials = auth_header.split(" ")
            decoded_credentials = base64.b64decode(encoded_credentials).decode("utf-8")
            username, password = decoded_credentials.split(":")
        except Exception as e:
            return JsonResponse({
                'error': 'Invalid credentials encoding.',
                'error_code': 'BASE64_DECODE_ERROR',
                'details': str(e),
                'status_code': 400
            }, status=400)

        try:
            user = UserDetails.objects.get(Email=username)
            userrole = UserroleDetails.objects.get(RoleID=user.RoleID)
            refresh = RefreshToken.for_user(user)

            if check_password(password, user.PasswordHash):
                return JsonResponse({
                    'message': 'Login successful',
                    'role': userrole.RoleName,
                    'user_id': user.id,
                    'username': user.Name,
                    'access': str(refresh.access_token),
                    'refresh': str(refresh),
                    'status_code': 200
                }, status=200)
            else:
                return JsonResponse({
                    'error': 'Invalid username or password',
                    'error_code': 'AUTH_FAILED',
                    'status_code': 400
                }, status=400)

        except UserDetails.DoesNotExist:
            return JsonResponse({
                'error': 'Invalid username or password',
                'error_code': 'USER_NOT_FOUND',
                'status_code': 400
            }, status=400)

    return JsonResponse({
        'error': 'POST method required',
        'error_code': 'METHOD_NOT_ALLOWED',
        'status_code': 405
    }, status=405)


 


class ForgotPasswordView(APIView):
    def post(self, request):
        email = request.data.get("email")
        user = get_object_or_404(UserDetails, Email=email)
        
        # Generate a unique reset token
        reset_token = get_random_string(32)
        user.ResetToken = reset_token
        user.save()

        # Send token via email (configure email settings)
        send_mail(
            "Password Reset Request",
            f"Your reset token is: {reset_token}",
            "noreply@example.com",
            [user.Email],
            fail_silently=False,
        )

        return Response({"message": "Reset token sent to email"}, status=status.HTTP_200_OK)

class ResetPasswordView(APIView):
    def post(self, request):
        reset_token = request.data.get("token")
        new_password = request.data.get("new_password")

        user = get_object_or_404(UserDetails, ResetToken=reset_token)

        # Hash and save new password
        user.PasswordHash = make_password(new_password)
        user.ResetToken = None  # Invalidate token after use
        user.save()

        return Response({"message": "Password reset successful"}, status=status.HTTP_200_OK)
    
class InterviewPlannerCalculation(APIView):
    #@jwt_required
    def post(self, request):        
        dead_line_days = int(request.data.get('dead_line_days'))
        offer_decline = int(request.data.get('offer_decline'))
        working_hours_per_day = int(request.data.get('working_hours_per_day'))
        no_of_roles_to_hire = int(request.data.get('no_of_roles_to_hire'))
        conversion_ratio = int(request.data.get('conversion_ratio'))        
        elimination = int(request.data.get('elimination'))
        avg_interviewer_time_per_week_hrs = int(request.data.get('avg_interviewer_time_per_week_hrs'))
        interview_round = int(request.data.get('interview_round'))
        interview_time_per_round = int(request.data.get('interview_time_per_round'))
        interviewer_leave_days = int(request.data.get('interviewer_leave_days'))
        no_of_month_interview_happens = int(request.data.get('no_of_month_interview_happens'))
        working_hrs_per_week = int(request.data.get('working_hrs_per_week')) 

        required_candidate = int(no_of_roles_to_hire * conversion_ratio)
        decline_adjust_count = ((required_candidate * offer_decline) / 100)
        total_candidate_pipline = (required_candidate + decline_adjust_count)
        total_interviews_needed = (total_candidate_pipline * interview_round)
        total_interview_hrs = (total_interviews_needed * interview_time_per_round)
        
        total_interview_weeks = (total_interview_hrs / working_hrs_per_week)
        no_of_interviewer_need = (total_interview_hrs / dead_line_days)        
        leave_adjustment = round(no_of_interviewer_need +(((interviewer_leave_days * avg_interviewer_time_per_week_hrs) / (dead_line_days * working_hours_per_day)) * no_of_interviewer_need))        

        return Response({
            'message': 'Data received',
            'required_candidate': required_candidate,    
            'decline_adjust_count': decline_adjust_count,  
            'total_candidate_pipline': total_candidate_pipline,
            'total_interviews_needed': total_interviews_needed,
            'total_interview_hrs': total_interview_hrs,
            'working_hrs_per_week': working_hrs_per_week,
            'total_interview_weeks': total_interview_weeks,
            'no_of_interviewer_need': no_of_interviewer_need,
            'leave_adjustment': leave_adjustment,
        }, status=status.HTTP_201_CREATED)


# @parser_classes([MultiPartParser, FormParser])
class HiringPlanOverviewDetails(APIView):
    # parser_classes = [MultiPartParser, FormParser]  # Enables file upload
    #@jwt_required
    def get(self, request):
        # user = request.user
        hiring_plan = HiringPlan.objects.all()
        serializer = HiringPlanSerializer(hiring_plan, many=True)
        # return render(request, 'recruiter_dashboard.html', context)
        return Response(serializer.data)
    
    #@jwt_required
    def post(self, request, *args, **kwargs):  # ✅ Accept pk from URL    
        # print(request.data)    
        serializer = HiringPlanSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response({
            'message':"plan created successfully",
            'hiring_plan_id': instance.hiring_plan_id,  
            'job_position': instance.job_position  
        }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #@jwt_required   
    def put(self, request):  # ✅ Accept pk from URL

        hiring_plan_id = request.data.get('hiring_plan_id')  # get ID from JSON body
        if not hiring_plan_id:
            return Response({"error": "Hiring Plan ID is required in request body"}, status=400)
        try:
            instance = HiringPlan.objects.get(hiring_plan_id=hiring_plan_id)  # Or use 'RequisitionID=pk' if custom PK
        except HiringPlan.DoesNotExist:
            return Response({"error": "Not found"}, status=404)

        serializer = HiringPlanSerializer(instance, data=request.data, partial=True)  # use partial=True
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    #@jwt_required
    def delete(self, request):

        hiring_plan_id = request.data.get('hiring_plan_id')  # get ID from JSON body
        if not hiring_plan_id:
            return Response({"error": "Hiring Plan ID is required in request body"}, status=400)
        obj = get_object_or_404(HiringPlan, hiring_plan_id=hiring_plan_id)
        obj.delete()
        return Response({"message": "Deleted successfully"}, status=status.HTTP_204_NO_CONTENT)        

@api_view(['GET'])
#@jwt_required
def get_hiring_plans(request):
    hiring_plans = HiringPlan.objects.all()
    serializer = HiringPlanSerializer(hiring_plans, many=True)
    
    # Filter the response to only include desired fields
    filtered_data = [{'hiring_plan_id': item['hiring_plan_id'], 'job_position': item['job_position']} 
                     for item in serializer.data]
    
    return Response(
            {
                "message": "hiring plan detail fetched successfully!", 
                "data": filtered_data
             }
        )

@api_view(['POST'])
#@jwt_required
def get_hiring_plan_details(request):
    hiring_plan_id = request.data.get('hiring_plan_id')

    if not hiring_plan_id:
        return Response({'error': 'No hiring_plan_id provided'}, status=400)

    try:
        hiring_plan = HiringPlan.objects.get(hiring_plan_id=hiring_plan_id)
        serializer = HiringPlanSerializer(hiring_plan)
        return Response(
            {
                "message": "hiring plan detail fetched successfully!", 
                "data": serializer.data
             }
            )
    except HiringPlan.DoesNotExist:
        return Response({'error': 'Hiring plan not found'}, status=404)


class HiringInterviewRounds(APIView):
    #@jwt_required
    def get(self, request):
        # user = request.user
        hiring_rounds = InterviewRounds.objects.all()
        serializer = HiringInterviewRoundsSerializer(hiring_rounds, many=True)
        # return render(request, 'recruiter_dashboard.html', context)
        return Response({
                "message": "Interview Rounds detail created successfully!", 
                "data": serializer.data
             })
    #@jwt_required
    def post(self, request):    
        requisition_id = request.data.get('requisition_id')
        round_name_list = request.data.get('round_name', [])        
        data_to_insert = []
        for round_name in round_name_list:
            data_to_insert.append({
                "requisition_id": requisition_id,
                "round_name": round_name
            })
        serializer = HiringInterviewRoundsSerializer(data=data_to_insert,many=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #@jwt_required
    def put(self, request):
        requisition_id = request.data.get('id')  # get ID from JSON body
        if not requisition_id:
            return Response({"error": "Hiring Plan ID is required in request body"}, status=400)
        try:
            instance = InterviewRounds.objects.get(id=requisition_id) 
        except InterviewRounds.DoesNotExist:
            return Response({"error": "Not found"}, status=404)

        serializer = HiringInterviewRoundsSerializer(instance, data=request.data, partial=True)  # use partial=True
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    
class HiringInterviewSkills(APIView):
    #@jwt_required
    def post(self, request):    
        requisition_id = request.data.get('requisition_id')
        skill_name_list = request.data.get('skill_name', [])     
        skill_value_list = request.data.get('skill_value', [])    
        if not (len(skill_name_list) == len(skill_value_list)):
            return Response({"error": "skill_name and skill_value must have same number of items."}, status=status.HTTP_400_BAD_REQUEST)
    
        data_to_insert = []
        for skill_name, skill_value in zip(skill_name_list, skill_value_list):
            data_to_insert.append({
                "requisition_id": requisition_id,
                "skill_name": skill_name,
                "skill_value": skill_value	
            })
        serializer = HiringSkillsSerializer(data=data_to_insert,many=True)
        if serializer.is_valid():
            serializer.save()
            return Response({
                "message": "Interview Rounds detail created successfully!", 
                "data": serializer.data}, 
                status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

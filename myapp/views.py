# Import necessary modules and models
from argparse import Action
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
from .serializers import JobRequisitionSerializer,JobRequisitionSerializerget
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



RESUME_STORAGE_FOLDER = "media/resumes"

# Initialize Ollama model
ollama_model = OllamaLLM(base_url='http://localhost:11434', model='ats_model')


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
        files = request.FILES.getlist("files")

        num_workers = min(len(files), os.cpu_count())  # Optimize worker count
        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            candidates = list(executor.map(process_resume, files))

        Candidate.objects.bulk_create(candidates)

        return Response({"message": f"{len(candidates)} resumes processed and candidates stored efficiently!"})


class JobRequisitionViewSetget(viewsets.ModelViewSet):
    queryset = JobRequisition.objects.all()
    serializer_class = JobRequisitionSerializerget
    http_method_names = ['get']  # Only allow GET requests


from rest_framework import viewsets, status
from rest_framework.response import Response
from datetime import datetime
from myapp.models import JobRequisition, UserDetails
from myapp.serializers import JobRequisitionSerializer

class JobRequisitionViewSet(viewsets.ModelViewSet):
    queryset = JobRequisition.objects.select_related("HiringManager").all()
    serializer_class = JobRequisitionSerializer

    def create(self, request, *args, **kwargs):
        """Only Hiring Managers (role = 1) can create job requisitions."""
        user_role = request.data.get("user_role")  # Get role from JSON

        if user_role != 1:  # Now comparing integers instead of strings
            return Response({"error": "Unauthorized. Only Hiring Managers can create requisitions."}, status=status.HTTP_403_FORBIDDEN)

        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        job_requisition = serializer.save()
        return Response(
            {"message": "Job requisition created successfully!", "requisition_id": job_requisition.RequisitionID},
            status=status.HTTP_201_CREATED
        )

    def list(self, request, *args, **kwargs):
        """Filter job requisitions based on user role."""
        user_role = request.data.get("user_role")

        if user_role == 2:  # Recruiter can see only approved requisitions with restricted details
            queryset = JobRequisition.objects.filter(Status="Approved")
            data = []

            for requisition in queryset:
                hiring_manager_name = getattr(requisition.HiringManager, "Name", "Unknown")
                contract_start_date = requisition.details.contract_start_date if hasattr(requisition, "details") and requisition.details.contract_start_date else "Not Provided"
                contract_end_date = requisition.details.contract_end_date if hasattr(requisition, "details") and requisition.details.contract_end_date else "Not Provided"

                serialized_data = {
                    "RequisitionID": requisition.RequisitionID,
                    "JobTitle": requisition.PositionTitle,
                    "HiringManagerName": hiring_manager_name,
                    "StartDate": contract_start_date,
                    "DueDate": contract_end_date,
                    "HiringStatus": requisition.Status,
                }
                data.append(serialized_data)

            

            return Response({"message": "Job requisitions retrieved successfully!", "data": data}, status=status.HTTP_200_OK)

        elif user_role == 3:  # Business Ops can see all requisitions
            queryset = JobRequisition.objects.all()

        elif user_role == 1:  # Hiring Manager can see their own requisitions
            queryset = JobRequisition.objects.filter(HiringManager=request.user)

        else:
            return Response({"error": "Unauthorized"}, status=status.HTTP_403_FORBIDDEN)

        # Default response for other roles (Business Ops & Hiring Managers)
        serializer = self.get_serializer(queryset, many=True)
        data = []

        for requisition in queryset:
            hiring_manager_name = getattr(requisition.HiringManager, "Name", "Unknown")

            serialized_data = self.get_serializer(requisition).data
            serialized_data["HiringManagerName"] = hiring_manager_name
            data.append(serialized_data)

        return Response({"message": "Job requisitions retrieved successfully!", "data": serializer.data}, status=status.HTTP_200_OK)
    @action(detail=False, methods=["POST"])
    def approve_requisition(self, request):
        """Only Business Ops (role = 3) can approve job requisitions."""
        user_role = request.data.get("user_role")  
        requisition_id = request.data.get("req_id")

        if user_role != 3:
            return Response({"error": "Unauthorized. Only Business Ops can approve requisitions."}, status=status.HTTP_403_FORBIDDEN)

        requisition = get_object_or_404(JobRequisition, pk=requisition_id)
        requisition.Status = "Approved"
        requisition.save()

        return Response({"message": "Job requisition approved!", "status": requisition.Status}, status=status.HTTP_200_OK)

    @action(detail=False, methods=["POST"])
    def get_approved_extra_details(self, request):
        """Get extra details only for approved requisitions."""
        user_role = request.data.get("user_role")  

        if user_role not in [2, 3]:  
            return Response({"error": "Unauthorized. Only Business Ops and Recruiters can view requisition details."}, status=status.HTTP_403_FORBIDDEN)

        approved_reqs = JobRequisition.objects.filter(Status="Approved")
        approved_ids = list(approved_reqs.values_list("RequisitionID", flat=True))  

        extra_details_qs = RequisitionDetails.objects.filter(requisition_id__in=approved_ids).order_by("requisition_id")

        data = []
        for detail in extra_details_qs:
            data.append({
                "requisition_id": detail.requisition_id,  
                "internal_title": detail.internal_title,
                "external_title": detail.external_title,
                "position": detail.position,
                "business_line": detail.business_line,
                "business_unit": detail.business_unit,
                "division": detail.division,
                "department": detail.department,
                "location": detail.location,
                "geo_zone": detail.geo_zone,
                "employee_group": detail.employee_group,
                "employee_sub_group": detail.employee_sub_group,
                "contract_start_date": detail.contract_start_date.isoformat() if detail.contract_start_date else "",
                "contract_end_date": detail.contract_end_date.isoformat() if detail.contract_end_date else "",
                "career_level": detail.career_level,
                "band": detail.band,
                "sub_band": detail.sub_band,
                "primary_skills": detail.primary_skills,
                "secondary_skills": detail.secondary_skills,
                "mode_of_working": detail.mode_of_working,
                "requisition_type": detail.requisition_type,
                "client_interview": detail.client_interview,
                "required_score": detail.required_score,
                "onb_coordinator": detail.onb_coordinator,
                "onb_coordinator_team": detail.onb_coordinator_team,
                "isg_team": detail.isg_team,
                "interviewer_teammate_employee_id": detail.interviewer_teammate_employee_id,
            })

        return Response(data, status=status.HTTP_200_OK)





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
        job_description = request.data.get('job_description')
        uploaded_files = request.FILES.getlist('resumes')  

        results = []
        for uploaded_file in uploaded_files:
            resume_text = extract_text_from_pdf(uploaded_file)
            score = get_matching_score(job_description, resume_text, uploaded_file.name)
            results.append(score)

        return Response({"matching_scores": results})


def get_job_requisitions(request):
    """
    Retrieves all job requisitions along with their extra details and returns them as JSON.
    Each returned JSON object includes main requisition fields and an "extra_details" sub-object
    with details coming from the jobrequisitionextradetails table.
    """
    requisitions = JobRequisition.objects.all().order_by('-CreatedDate')
    data = []
    
    for req in requisitions:
        # Initialize the extra details dictionary to None.
        extra = None

        # Since no related name was set, the extra details are available on req.jobrequisitionextradetails_set.
        if req.jobrequisitionextradetails_set.exists():
            extra_obj = req.jobrequisitionextradetails_set.first()
            extra = {
                "LegalEntity": extra_obj.LegalEntity,
                "PrimaryLocation": extra_obj.PrimaryLocation,
                "Geo_zone": extra_obj.Geo_zone,
                "EmployeeGroup": extra_obj.EmployeeGroup,
                "EmployeeSubGroup": extra_obj.EmployeeSubGroup,
                "BussinessLine": extra_obj.BussinessLine,
                "BussinessUnit": extra_obj.BussinessUnit,
                "Division": extra_obj.Division,
                "Department": extra_obj.Department,
                "RequisitionType": extra_obj.RequisitionType,
                "CareerLevel": extra_obj.CareerLevel,
                "Is_contract": extra_obj.Is_contract,
                "Start_date": extra_obj.Start_date.isoformat() if extra_obj.Start_date else None,
                "End_date": extra_obj.End_date.isoformat() if extra_obj.End_date else None,
                "Band": extra_obj.Band,
                "SubBand": extra_obj.SubBand,
                "Client_interview": extra_obj.Client_interview,
                "Secondary_skill": extra_obj.Secondary_skill,
                "ModeOfWorking": extra_obj.ModeOfWorking,
                "Skills": extra_obj.Skills,
            }
        
        # Build our dictionary for the job requisition.
        data.append({
            "RequisitionID": req.RequisitionID,
            "PositionTitle": req.PositionTitle,
            "No_of_positions": req.No_of_positions,
            "recruiter": req.recruiter,
            "Status": req.Status,
            "CreatedDate": req.CreatedDate.strftime("%Y-%m-%d %H:%M:%S"),
            "extra_details": extra,  # This will be None if no extra record exists.
        })
    
    # Use Django's JSON encoder for date objects etc.
    return JsonResponse(data, safe=False)



def send_email():
    send_mail(
        'Job Requsition Added',
        'Please verify and Approve the added job requsition.',
        settings.EMAIL_HOST_USER,
        ['anandsivakumar27@gmail.com'],
        fail_silently=False,
    )

@csrf_exempt
def login_page(request):
    if request.method == "POST":
        auth_header = request.headers.get("Authorization")

        if not auth_header or not auth_header.startswith("Basic "):
            return JsonResponse({'error': 'Authorization header missing or incorrect'}, status=401)

        # Decode Base64 credentials
        _, encoded_credentials = auth_header.split(" ")
        decoded_credentials = base64.b64decode(encoded_credentials).decode("utf-8")
        username, password = decoded_credentials.split(":")

        try:
            user = UserDetails.objects.get(Email=username)
            userrole = UserroleDetails.objects.get(RoleID=user.RoleID)
            print(user.PasswordHash)
            print(password)

            if check_password(password, user.PasswordHash):
                return JsonResponse({'message': 'Login successful', 'role': userrole.RoleName}, status=200)
            else:
                return JsonResponse({'error': 'Invalid username or password'}, status=400)

        except UserDetails.DoesNotExist:
            return JsonResponse({'error': 'Invalid username or password'}, status=400)

    return JsonResponse({'error': 'POST method required'}, status=405)

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


        return Response({'message': 'Data received'}, status=status.HTTP_200_OK)


# @parser_classes([MultiPartParser, FormParser])
class HiringPlanOverviewDetails(APIView):
    # parser_classes = [MultiPartParser, FormParser]  # Enables file upload
    def get(self, request):
        # user = request.user
        hiring_plan = HiringPlan.objects.all()
        serializer = HiringPlanSerializer(hiring_plan, many=True)
        # return render(request, 'recruiter_dashboard.html', context)
        return Response(serializer.data)
    
    def post(self, request, *args, **kwargs):  # ✅ Accept pk from URL    
        # print(request.data)    
        serializer = HiringPlanSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response({
            'hiring_plan_id': instance.hiring_plan_id,    
            'tech_stacks': instance.tech_stacks,  
            'job_position': instance.job_position  
        }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
       
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
    
    def delete(self, request):

        hiring_plan_id = request.data.get('hiring_plan_id')  # get ID from JSON body
        if not hiring_plan_id:
            return Response({"error": "Hiring Plan ID is required in request body"}, status=400)
        obj = get_object_or_404(HiringPlan, hiring_plan_id=hiring_plan_id)
        obj.delete()
        return Response({"message": "Deleted successfully"}, status=status.HTTP_204_NO_CONTENT)        

class HiringInterviewRounds(APIView):

    def get(self, request):
        # user = request.user
        hiring_rounds = InterviewRounds.objects.all()
        serializer = HiringInterviewRoundsSerializer(hiring_rounds, many=True)
        # return render(request, 'recruiter_dashboard.html', context)
        return Response(serializer.data)

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
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

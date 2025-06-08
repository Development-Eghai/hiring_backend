# Import necessary modules and models
import os
from pyexpat.errors import messages
from django.http import HttpResponse,JsonResponse
from django.shortcuts import render, redirect
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
from .models import Posting, UserDetails,Candidates,UserroleDetails
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

class JobRequisitionViewSetget(viewsets.ModelViewSet):
    queryset = JobRequisition.objects.all()
    serializer_class = JobRequisitionSerializerget
    http_method_names = ['get']  # Only allow GET requests


class JobRequisitionViewSet(viewsets.ModelViewSet):
    queryset = JobRequisition.objects.all()
    serializer_class = JobRequisitionSerializer

    def create(self, request, *args, **kwargs):
        """Handle POST request to create JobRequisition and return a success response"""
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)  # Validate request data
        job_requisition = serializer.save()  # Create JobRequisition first
        send_email()
        return Response({
            "message": "Job requisition created successfully!",
            "status_code": status.HTTP_201_CREATED,
            "requisition_id": job_requisition.RequisitionID,
            "data": serializer.data  # Return inserted data
        }, status=status.HTTP_201_CREATED)
    def list(self, request, *args, **kwargs):
        """Handle GET request and return JobRequisition data with status code"""
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)

        return Response({
            "message": "Job requisitions retrieved successfully!",
            "status_code": status.HTTP_200_OK,
            "data": serializer.data
        }, status=status.HTTP_200_OK)


# Initialize Ollama model
ollama_model = OllamaLLM(base_url='http://localhost:11434', model='ats_model')

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

def login_page(request):
    context = {}
    # Check if the HTTP request method is POST (form submission)
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        if not username or not password:
                return JsonResponse({'error': 'Email and password required'}, status=400)
        try:
                user = UserDetails.objects.get(Email=username)
                print(user.PasswordHash)
                userrole = UserroleDetails.objects.get(RoleID=user.RoleID)
                request.session["role_name"] = userrole.RoleName
                request.session["UserID"] = user.UserID
                request.session.modified = True
                if password == user.PasswordHash and user.UserID == 1:
                    return redirect("/dashboard/")
                elif password == user.PasswordHash and user.UserID == 3:
                    return redirect("/dashboard_Buss/")
                elif password == user.PasswordHash and user.UserID == 2:
                    return redirect("/dashboard_rec/")
                else:
                    context['error'] = 'Invalid username or password.'
                    return render(request, 'login.html', context)
        except UserDetails.DoesNotExist:
                context['error'] = 'Invalid username or password.'
                return render(request, 'login.html', context)

      

    return JsonResponse({'error': 'POST method required'}, status=405)

      

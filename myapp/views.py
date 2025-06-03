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
from .serializers import CandidatesSerializer
from rest_framework.parsers import MultiPartParser, FormParser
from django.views.decorators.csrf import csrf_exempt
import json
from .models import JobRequisition, JobRequisitionExtraDetails

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import json
from django.views.decorators.http import require_POST
from .models import JobRequisition
from django.core.mail import send_mail
from django.conf import settings
from django.http import JsonResponse
from django.core.serializers.json import DjangoJSONEncoder
from .models import JobRequisition  # Assuming your main model is defined in models.py

import PyPDF2 as pdf
from langchain_ollama import OllamaLLM

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


def get_job_extra_details(request):
    """
    Returns extra details only for those JobRequisition records that have Status "Approved".
    Steps:
      1. Get all approved JobRequisition records.
      2. Extract their RequisitionIDs.
      3. Filter JobRequisitionExtraDetails based on these IDs.
    """
    # Step 1: Get approved job requisitions and order by RequisitionID.
    approved_reqs = JobRequisition.objects.filter(Status="Approved").order_by("RequisitionID")

    # Step 2: Extract the list of approved requisition IDs (as integers).
    approved_ids = list(approved_reqs.values_list("RequisitionID", flat=True))

    # Step 3: Get the extra details whose RequisitionID is in the list of approved IDs.
    extra_details_qs = JobRequisitionExtraDetails.objects.filter(
        RequisitionID__in=approved_ids
    ).order_by("RequisitionID")
    
    data = []
    for detail in extra_details_qs:
        # Use detail.RequisitionID_id so that we only get the integer ID.
        data.append({
            "RequisitionID": detail.RequisitionID_id,
            "LegalEntity": detail.LegalEntity,
            "PrimaryLocation": detail.PrimaryLocation,
            "Geo_zone": detail.Geo_zone,
            "EmployeeGroup": detail.EmployeeGroup,
            "EmployeeSubGroup": detail.EmployeeSubGroup,
            "BussinessLine": detail.BussinessLine,
            "BussinessUnit": detail.BussinessUnit,
            "Division": detail.Division,
            "Department": detail.Department,
            "RequisitionType": detail.RequisitionType,
            "CareerLevel": detail.CareerLevel,
            "Is_contract": detail.Is_contract,
            "Start_date": detail.Start_date.isoformat() if detail.Start_date else "",
            "End_date": detail.End_date.isoformat() if detail.End_date else "",
            "Band": detail.Band,
            "SubBand": detail.SubBand,
            "Client_interview": detail.Client_interview,
            "Secondary_skill": detail.Secondary_skill,
            "ModeOfWorking": detail.ModeOfWorking,
            "Skills": detail.Skills,
        })
    
    return JsonResponse(data, safe=False)


@csrf_exempt  # For testing purposes; in production, use proper CSRF protection.
def upload_candidate(request):
    if request.method == "POST":
        name = request.POST.get("name")
        email = request.POST.get("email")
        resume_file = request.FILES.get("resume")  # Uploaded file

        if not (name and email and resume_file):
            return JsonResponse({"error": "All fields are required."}, status=400)

        candidate = Candidates(Name=name, Email=email, Resume=resume_file)
        candidate.save()
        return JsonResponse({"message": "Candidate uploaded successfully", "CandidateID": candidate.CandidateID})
    return JsonResponse({"error": "Invalid request method."}, status=405)

def get_candidates(request):
    """
    Returns candidate details from the Candidate table.
    Each candidate is represented with its ID, Name, Email, Resume URL, and Profile Created Time.
    """
    candidates = Candidates.objects.all().order_by('-ProfileCreated')
    data = []
    for candidate in candidates:
        data.append({
            "CandidateID": candidate.CandidateID,
            "Name": candidate.Name,
            "Email": candidate.Email,
            "Resume": candidate.Resume.url if candidate.Resume else "",
            "ProfileCreated": candidate.ProfileCreated.strftime("%Y-%m-%d %H:%M:%S"),
        })
    return JsonResponse(data, safe=False)


def send_email():
    send_mail(
        'Job Requsition Added',
        'Please verify and Approve the added job requsition.',
        settings.EMAIL_HOST_USER,
        ['anandsivakumar27@gmail.com'],
        fail_silently=False,
    )

def get_recruiters(request):
    recruiters = UserDetails.objects.filter(RoleID=2).values("UserID", "Name")  # Include 'id'
    print("Recruiters Data:", list(recruiters))

    return JsonResponse(list(recruiters), safe=False)

@require_POST
def update_job_status(request):
    try:
        # Parse the JSON payload from the request body
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON payload."}, status=400)

    # Retrieve the necessary fields from the JSON data
    req_id = data.get("RequisitionID")
    new_status = data.get("Status")

    if not req_id or not new_status:
        return JsonResponse({"error": "Missing required fields."}, status=400)

    # Optionally, you might want to validate that the new status is one of the allowed values
    valid_statuses = ["Draft", "Pending Approval", "Approved", "Posted"]
    if new_status not in valid_statuses:
        return JsonResponse({"error": "Invalid status value."}, status=400)

    # Find the job requisition record by its ID
    try:
        job = JobRequisition.objects.get(RequisitionID=req_id)
    except JobRequisition.DoesNotExist:
        return JsonResponse({"error": "Job requisition not found."}, status=404)

    # Update the job's status
    job.Status = new_status
    job.save()

    # Return a success response
    return JsonResponse({
        "success": True,
        "RequisitionID": job.RequisitionID,
        "Status": job.Status
    })

@require_POST
def update_job(request):
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON payload."}, status=400)

    req_id = data.get("RequisitionID")
    new_status = "Pending"

    if not req_id or new_status not in ['Pending', 'Posted', 'Closed']:
        return JsonResponse({"error": "Missing or invalid fields."}, status=400)

    job, created = Posting.objects.update_or_create(
        RequisitionID=req_id,  # Ensure correct field name
        defaults={
            "PostingType": "External",
            "PostingStatus": new_status,
            "StartDate": '2025-05-30',
            "EndDate": '2026-05-30',
        }
    )

    return JsonResponse({
        "success": True,
        "RequisitionID": req_id,
        "Status": new_status,
        "Created": created  # Will be True if a new entry was created, False if updated
    })



@csrf_exempt
def create_job_requisition(request):
    try:
        print(f"Session Data (Dashboard View): {request.session.items()}")  # Debugging
        # print(f"Raw Request Body: {request.body}")  # Debugging

        job_title = request.POST.get("job_title")
        positions = request.POST.get("positions")
        recruiter_name = request.POST.get("recruiter")
        print(recruiter_name)
        if not job_title or not positions or not recruiter_name:
            return JsonResponse({"error": "Missing required fields."}, status=400)

        # Convert positions safely
        try:
            positions = int(positions)
        except ValueError:
            return JsonResponse({"error": "Invalid number for positions."}, status=400)

        # Debugging before database operation
        print("Creating Job Requisition...")
        job = JobRequisition.objects.create(
            PositionTitle=job_title,
            No_of_positions=positions,
            HiringManagerID=request.session.get("UserID"),
            recruiter=recruiter_name,
            Status="Pending Approval"
        )
        print(f"Job Created: {job}")

        # Debugging before inserting extra details
        print("Adding Extra Details...")
        extra_details = JobRequisitionExtraDetails.objects.create(
            RequisitionID=job,
            LegalEntity=request.POST.get("legal_entity"),
            PrimaryLocation=request.POST.get("primary_location"),
            Geo_zone=request.POST.get("geo_zone"),
            EmployeeGroup=request.POST.get("employee_group"),
            EmployeeSubGroup=request.POST.get("employee_sub_group"),
            BussinessLine=request.POST.get("business_line"),
            BussinessUnit=request.POST.get("business_unit"),
            Division=request.POST.get("division"),
            Department=request.POST.get("department"),
            RequisitionType=request.POST.get("requisition_type"),
            CareerLevel=request.POST.get("career_level"),
            Is_contract=request.POST.get("is_contract") == "true",
            Start_date=request.POST.get("start_date"),
            End_date=request.POST.get("end_date"),
            Band=request.POST.get("band"),
            SubBand=request.POST.get("sub_band"),
            Client_interview=request.POST.get("client_interview") == "true",
            Secondary_skill=request.POST.get("secondary_skill"),
            ModeOfWorking=request.POST.get("mode_of_working"),
            Skills=request.POST.get("skills")
        )
        print(f"Extra Details Added: {extra_details}")
        send_email()
        response_data = {
            "job": {
                "RequisitionID": job.RequisitionID,
                "PositionTitle": job.PositionTitle,
                "Positions": job.No_of_positions,
                "recruiter": job.recruiter,
                "Status": job.Status
            },
            "message": "Job requisition and extra details added successfully!"
        }

        return JsonResponse(response_data, status=201)

    except Exception as e:
        print(f"Server Error: {str(e)}")  # Logs the exact error in the console
        return JsonResponse({"error": f"Internal Server Error: {str(e)}"}, status=500)

# Optionally, if you want to support non-AJAX calls (e.g., rendering a form),
# you could also check for GET requests, for example:
def create_job_requisition_view(request):
    if request.method == "POST":
        return create_job_requisition(request)
    return render(request, "create_job_requisition.html")


class CandidateDetails(APIView):
    parser_classes = [MultiPartParser, FormParser]  # Enables file upload
    def get(self, request):
        documents = Candidates.objects.all()
        serializer = CandidatesSerializer(documents, many=True)        
        data = list(serializer.data)
        print(type(data))
        for x in data:
            x["Resume"] = x["Resume"].replace("/media/resumes/", "")
        context = {'candidate_data': serializer.data} 
        return redirect("/dashboard/",context)
    
    def post(self, request, *args, **kwargs):
        context = {}
        serializer = CandidatesSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            documents = Candidates.objects.all()
            serializer = CandidatesSerializer(documents, many=True)        
            data = list(serializer.data)            
            for x in data:
                x["Resume"] = x["Resume"].replace("/media/resumes/", "")
            context = {'candidate_data': serializer.data} 
            return redirect("/dashboard/",context)
        error_messages = []
        for field_errors in serializer.errors.values():
            for err in field_errors:
                error_messages.append(str(err))
        # print(error_messages[0] if error_messages else "Validation error.")
        context['error'] = error_messages[0] if error_messages else "Validation error."
        return render(request, 'dashboard.html', context)
    
def hiring(request):
    documents = Candidates.objects.all()
    serializer = CandidatesSerializer(documents, many=True)    
    data = list(serializer.data)   
    
    for x in data:
        x["Resume"] = x["Resume"].replace("/media/resumes/", "")
    # context = {'candidate_data': serializer.data} 
    return JsonResponse(serializer.data, safe=False)

  

def get_jobs(request):
    job_data = [
        {"title": "Software Engineer", "positions": 5, "recruiter": "John Doe", "status": "Open"},
        {"title": "Marketing Manager", "positions": 3, "recruiter": "Jane Smith", "status": "Closed"},
        {"title": "Data Analyst", "positions": 2, "recruiter": "Emily Clark", "status": "Pending"},
    ]
    return JsonResponse(job_data, safe=False)

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

      

# Define a view function for the home page
def home(request):
    return render(request, 'home.html')

def dashboard_Buss(request):
    print(f"Session Data (Dashboard View): {request.session.items()}")  # Debugging
    role_name = request.session.get("role_name", "Unknown Role")  
    return render(request, "dashboard_Buss.html", {"role_name": role_name})

def dashboard_rec(request):
    print(f"Session Data (Dashboard View): {request.session.items()}")  # Debugging
    role_name = request.session.get("role_name", "Unknown Role")  
    return render(request, "dashboard_rec.html", {"role_name": role_name})

def dashboard(request):
    # Debugging: print session information
    print(f"Session Data (Dashboard View): {request.session.items()}")
    
    # Get role name from session
    role_name = request.session.get("role_name", "Unknown Role")
    
    # Retrieve all job requisitions (you can add ordering or filtering as needed)
    job_requisitions = JobRequisition.objects.all().order_by('-CreatedDate')
    
    # Pass both role_name and job_requisitions into the template context
    context = {
        "role_name": role_name,
        "job_requisitions": job_requisitions,
    }
    
    return render(request, "dashboard.html", context)

def logout_view(request):
    logout(request)
    return redirect("/")

# Define a view function for the registration page
def register_page(request):
    # Check if the HTTP request method is POST (form submission)
    # if request.method == 'POST':
    #     first_name = request.POST.get('first_name')
    #     last_name = request.POST.get('last_name')
    #     username = request.POST.get('username')
    #     password = request.POST.get('password')
        
    #     # Check if a user with the provided username already exists
    #     user = User.objects.filter(username=username)
        
    #     if user.exists():
    #         # Display an information message if the username is taken
    #         messages.info(request, "Username already taken!")
    #         return redirect('/register/')
        
    #     # Create a new User object with the provided information
    #     user = User.objects.create_user(
    #         first_name=first_name,
    #         last_name=last_name,
    #         username=username
    #     )
        
    #     # Set the user's password and save the user object
    #     user.set_password(password)
    #     user.save()
        
    #     # Display an information message indicating successful account creation
    #     messages.info(request, "Account created Successfully!")
    #     return redirect('/register/')
    
    # Render the registration page template (GET request)
    return render(request, 'register.html')

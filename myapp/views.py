# Import necessary modules and models
import os
from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from .models import *
from django.contrib.auth import logout
from django.db import connection
from django.conf import settings



def submit_candidate(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        email = request.POST.get('email')
        resume = request.FILES.get('resume')

        if name and email and resume:
            resume_filename = resume.name
            resume_path = os.path.join(settings.MEDIA_ROOT, resume_filename)

            # Save file to media directory
            with open(resume_path, 'wb+') as destination:
                for chunk in resume.chunks():
                    destination.write(chunk)
            try:
                with connection.cursor() as cursor:
                    sql = "INSERT INTO candidates (Name, Email, Resume) VALUES (%s, %s, %s)"
                    cursor.execute(sql, (name, email, resume_filename))
                    connection.commit()

                return render(request, 'dashboard.html', {'message': 'Candidate details submitted successfully!'})
            except Exception as e:
                return HttpResponse(f"Error: {str(e)}")

    return render(request, 'dashboard.html')


# Define a view function for the home page
def home(request):
    return render(request, 'home.html')

def dashboard(request):
    return render(request, "dashboard.html")

def logout_view(request):
    logout(request)
    return redirect("/login/")

# Define a view function for the login page
def login_page(request):
    # Check if the HTTP request method is POST (form submission)
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        with connection.cursor() as cursor:
            cursor.execute("SELECT PasswordHash FROM users WHERE Email = %s", [username])
            user_data = cursor.fetchone()

        if user_data and user_data[0] == password:  # Compare passwords
            request.session["username"] = username
            return redirect("/dashboard/")
            
        return render(request, "login.html", {"error": "Invalid username or password"})


    return render(request, 'login.html')

# Define a view function for the registration page
def register_page(request):
    # Check if the HTTP request method is POST (form submission)
    if request.method == 'POST':
        first_name = request.POST.get('first_name')
        last_name = request.POST.get('last_name')
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        # Check if a user with the provided username already exists
        user = User.objects.filter(username=username)
        
        if user.exists():
            # Display an information message if the username is taken
            messages.info(request, "Username already taken!")
            return redirect('/register/')
        
        # Create a new User object with the provided information
        user = User.objects.create_user(
            first_name=first_name,
            last_name=last_name,
            username=username
        )
        
        # Set the user's password and save the user object
        user.set_password(password)
        user.save()
        
        # Display an information message indicating successful account creation
        messages.info(request, "Account created Successfully!")
        return redirect('/register/')
    
    # Render the registration page template (GET request)
    return render(request, 'register.html')

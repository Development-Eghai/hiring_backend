# pixel_hiring
Hiring Backend (Django)
This repository contains the backend for the Hiring Management System, developed using Django, designed to streamline job applications, candidate evaluations, and hiring workflows
Features
- Authentication & Authorization (Django's built-in auth system)
- Job Posting Management
- Candidate Application Processing
- Interview Scheduling
- Admin and HR Dashboard
- REST API endpoints using Django REST Framework (DRF)

Tech Stack
- Backend: Django, Django REST Framework
- Database:  MySQL
- Authentication: Django's built-in authentication, JWT
- Deployment: Docker

Installation
Local Setup
- Clone this repository:
- git clone https://github.com/Development-Eghai/hiring_backend.git
- cd hiring_backend
- python -m venv venv
- source venv/bin/activate  # For Mac/Linux
- venv\Scripts\activate  # For Windows
- pip install -r requirements.txt
- python manage.py migrate
- python manage.py runserver

Setting Up MySQL Database
Install MySQL
- Download and install MySQL from the official site: MySQL Download.
- Follow the installation process and ensure MySQL Server is running.
- Set up your root password during installation.
Import Database File (.sql)
- Place your MySQL file (recruitingdb.sql) in a known directory.
- Open a terminal or command prompt and log in to MySQL:
- mysql -u root -p
- Create a new database (replace hiring_db with your preferred name):
- CREATE DATABASE  recruitingdb;
- Exit MySQL and import the .sql file
- mysql -u root -p  recruitingdb < /path/to/recruitingdb.sql

Docker Setup
- Build the Docker image:
- docker build -t hiring-backend .
- docker run -d -p 8000:8000 --name hiring-backend-container hiring-backend
- docker stop hiring-backend-container
- docker rm hiring-backend-container


  
  
  



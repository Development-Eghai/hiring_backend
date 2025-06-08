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

## Installation
### Local Setup
- Clone this repository:
- git clone https://github.com/Development-Eghai/hiring_backend.git
- cd hiring_backend
- python -m venv venv
- source venv/bin/activate  # For Mac/Linux
- venv\Scripts\activate  # For Windows
- pip install -r requirements.txt
- python manage.py migrate
- python manage.py runserver

## Setting Up MySQL Database
### Install MySQL
- Download and install MySQL from the official site: MySQL Download.
- Follow the installation process and ensure MySQL Server is running.
- Set up your root password during installation.
### Import Database File (.sql)
  - Place your MySQL file (recruitingdb.sql) in a known directory.
  - Open a terminal or command prompt and log in to MySQL:
  - mysql -u root -p
  - Create a new database (replace hiring_db with your preferred name):
  - CREATE DATABASE  recruitingdb;
  - Exit MySQL and import the .sql file
  - mysql -u root -p  pixeladvant_hiring < hiring_backend/pixeladvant_hiring_mysql.sql
### Alternative DB setup
  - set env variable DUMP_FILE=pixeladvant_hiring_mysql.sql
  - set env variable MYSQL_DB_PASSWORD=<your-password>
  - run setup_db_mysql.py

### Docker Setup
- Build the Docker image:
- docker build -t hiring-backend .
- docker run -d -p 8000:8000 --name hiring-backend-container hiring-backend
- docker stop hiring-backend-container
- docker rm hiring-backend-container

### Running the Ollama Resume Scoring Program

  1.pip install ollama pymupdf
  2.cd /path/to/hiring_backend
  3.source venv/bin/activate  # Mac/Linux
    venv\Scripts\activate  # Windows
  4.ls media/resumes  # Check if resumes exist
  5.python olama_test.py > scores.txt

### API Testing with Postman
This project includes a Postman collection named pixel_advant_endpoint_details.postman_collection that contains all the API endpoint details for testing.
Steps to Import and Use Postman Collection
1. Install Postman
- Download and install Postman from Postman’s official website.
2. Import the Collection
- Open Postman.
- Click on File → Import.
- Select pixel_advant_endpoint_details.postman_collection from the project directory.
- Click Import to load the endpoints.
3. Set Up Environment Variables
If your API requires environment variables (such as authentication keys, base URL, etc.), follow these steps:
- Click Environments in Postman.
- Create a new environment and add required variables (e.g., BASE_URL, API_KEY).
- Use {{BASE_URL}} in endpoint URLs.
4. Run API Tests
- Select an endpoint from the imported collection.
- Enter required parameters or body content.
- Click Send to execute the API request.

  
  
  



# Use the Python 3.13 base image
FROM python:3.13  

# Create the app directory
RUN mkdir /app  

# Set the working directory inside the container
WORKDIR /app  

# Set environment variables  
ENV PYTHONDONTWRITEBYTECODE=1  
ENV PYTHONUNBUFFERED=1  

# Upgrade pip  
RUN pip install --upgrade pip  

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh  

# Copy the Django project requirements file  
COPY requirements.txt /app/  

# Install dependencies  
RUN pip install --no-cache-dir -r requirements.txt  

# Pull the ATS model for Ollama  
RUN ollama pull ats_model  

# Copy the Django project files  
COPY . /app/  

# Expose the Django port  
EXPOSE 8000  

# Run Django’s development server  
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
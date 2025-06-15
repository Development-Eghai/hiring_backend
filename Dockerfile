# Use Python 3.13 as the base image
FROM python:3.13

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Update package lists and install necessary packages, including netcat-openbsd
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    default-mysql-client \
    iputils-ping \
    dnsutils \
    gcc \
    netcat-openbsd

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files including wait-for-it.sh
COPY . /app/

# Ensure wait-for-it.sh is executable
RUN chmod +x /app/wait-for-it.sh

# Expose the Django port
EXPOSE 8000

# Use wait-for-it to wait until MySQL is ready before launching Django
CMD ["/app/wait-for-it.sh", "mysql", "3306", "--", "python", "manage.py", "runserver", "0.0.0.0:8000"]

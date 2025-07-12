import os
import sys
import django
from django.core.mail import send_mail

# Add the project root to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'hiring_backend.settings')
django.setup()

# Send test email
send_mail(
    subject='Test Email',
    message='This is a test email from Django using Zoho SMTP.',
    from_email='hiring@pixeladvant.com',
    recipient_list=['anand040593@gmail.com'],
    fail_silently=False,
)

send_mail()
# Import necessary modules
from django.contrib import admin  # Django admin module
from django.urls import path       # URL routing
from myapp.views import *  # Import views from the authentication app
from django.conf import settings   # Application settings
from django.contrib.staticfiles.urls import staticfiles_urlpatterns  # Static files serving
from .views import login_page,CandidateDetails
from django.conf.urls.static import static



# Define URL patterns
urlpatterns = [
    path('home/', home, name="recipes"),      # Home page
    path("admin/", admin.site.urls),          # Admin interface
    path('login/', login_page, name='login_page'),    # Login page
    path('register/', register_page, name='register'),  # Registration page
    path("dashboard/", dashboard, name="dashboard"),
    path("dashboard_Buss/", dashboard_Buss, name="dashboard_Buss"),
    path("dashboard_rec/", dashboard_rec, name="dashboard_rec"),
    path("logout/", logout_view, name="logout"),
    # path('submit-candidate/', submit_candidate, name='submit_candidate'),
    path('candidate/', CandidateDetails.as_view(), name='candidate'),
    path('hiring/', hiring, name='hiring'),
    # path('create-job/', create_job_requisition, name='create_job_requisition'),
    path('create_job_requisition/', create_job_requisition, name='create_job_requisition'),
    path("get-recruiters/", get_recruiters, name="get_recruiters"),
    path("update-job-status/", update_job_status, name="update_job_status"),
    path("update-job/", update_job, name="update_job"),
    path('get-job-requisitions/', get_job_requisitions, name='get_job_requisitions1'),
    path('get-job-extra-details/', get_job_extra_details, name='get_job_extra_details'),
    path('upload-candidate/', upload_candidate, name='upload_candidate'),
    path('get-candidates/', get_candidates, name='get_candidates'),
    path('api/match-resumes/', ResumeMatchingAPI.as_view(), name='match_resumes'),

  

]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


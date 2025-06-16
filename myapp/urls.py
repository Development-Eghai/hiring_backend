# Import necessary modules
from django.contrib import admin  # Django admin module
from django.urls import path,include      # URL routing
from myapp.views import *  # Import views from the authentication app
from django.conf import settings   # Application settings
from django.contrib.staticfiles.urls import staticfiles_urlpatterns  # Static files serving
from .views import login_page
from django.conf.urls.static import static
from .views import JobRequisitionViewSet,JobRequisitionViewSetget
from rest_framework.routers import DefaultRouter
from .views import HiringPlanOverviewDetails,HiringInterviewRounds,HiringInterviewSkills
from .views import InterviewPlannerCalculation



router = DefaultRouter()
router.register(r'jobrequisition', JobRequisitionViewSet)
router1 = DefaultRouter()
router1.register(r'job-requisition', JobRequisitionViewSetget) 
# router2 = DefaultRouter()
# router2.register(r'upload-resumes', BulkUploadResumeView)


# Define URL patterns
urlpatterns = [
    path("admin/", admin.site.urls),          # Admin interface TODO not yet implemented
    path('login/', login_page, name='login_page'),    # Login page TODO screen to develop and integrated
    # path('submit-candidate/', submit_candidate, name='submit_candidate'),
    path('get-job-requisitions/', get_job_requisitions, name='get_job_requisitions1'), #TODO screen to develop and integrated
    path('api/match-resumes/', ResumeMatchingAPI.as_view(), name='match_resumes'),#TODO screen to develop and integrated
    path('api/', include(router.urls)), #TODO Hiring Manager create requsition
    path('api/', include(router1.urls)), #TODO home Screen Hiring Manager
    path("api/upload-resumes/", BulkUploadResumeView.as_view(), name="bulk-upload-resumes"), #TODO screen to develop and integrated
    path("forgot-password/", ForgotPasswordView.as_view(), name="forgot_password"),#TODO screen to develop and integrated
    path("reset-password/", ResetPasswordView.as_view(), name="reset_password"),#TODO screen to develop and integrated
    
    #planning API
    path('hiring_plan/', HiringPlanOverviewDetails.as_view(), name='hiring_plan_overview'), #TODO screen to develop and integrated
    path('hiring_interview_rounds/', HiringInterviewRounds.as_view(), name='hiring_interview_rounds'),#Django Flow is Done
    path('hiring_skills/', HiringInterviewSkills.as_view(), name='hiring_skills'),#TODO screen to develop and integrated
    path('interview_planner_calc/', InterviewPlannerCalculation.as_view(), name='interview_planner_calc'),#TODO screen to develop and integrated


]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


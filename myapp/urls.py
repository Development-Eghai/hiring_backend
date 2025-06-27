# Import necessary modules
from django.contrib import admin  # Django admin module
from django.urls import path,include      # URL routing
from myapp.views import *  # Import views from the authentication app
from django.conf import settings   # Application settings
from django.contrib.staticfiles.urls import staticfiles_urlpatterns  # Static files serving
from .views import login_page
from django.conf.urls.static import static
from .views import JobRequisitionViewSet,JobRequisitionPublicViewSet
from rest_framework.routers import DefaultRouter
from .views import HiringPlanOverviewDetails,HiringInterviewRounds,HiringInterviewSkills
from .views import InterviewPlannerCalculation
# from rest_framework_simplejwt.views import (
#     TokenObtainPairView,
#     TokenRefreshView,
# )


router = DefaultRouter()
router.register(r'jobrequisition', JobRequisitionViewSet)
router1 = DefaultRouter()
# router1.register(r'job-requisition', JobRequisitionViewSetget) 
router1.register(r'jobrequisition-dynamic', JobRequisitionFlatViewSet,basename='jobrequisition-dynamic')

router2 = DefaultRouter()
router2.register(r'public/job-requisitions', JobRequisitionPublicViewSet, basename='public-job-requisition')



# Define URL patterns
urlpatterns = [
    path("admin/", admin.site.urls),          # Admin interface TODO not yet implemented
    path('login/', login_page, name='login_page'),    # Login page TODO screen to develop and integrated
    # path('submit-candidate/', submit_candidate, name='submit_candidate'),#TODO screen to develop and integrated
    path('api/match-resumes/', ResumeMatchingAPI.as_view(), name='match_resumes'),#TODO screen to develop and integrated
    path('api/', include(router.urls)), #TODO Hiring Manager create requsition
    path("api/upload-resumes/", BulkUploadResumeView.as_view(), name="bulk-upload-resumes"), #TODO screen to develop and integrated
    path("forgot-password/", ForgotPasswordView.as_view(), name="forgot_password"),#TODO screen to develop and integrated
    path("reset-password/", ResetPasswordView.as_view(), name="reset_password"),#TODO screen to develop and integrated
    
    #planning API
    path('hiring_plan/', HiringPlanOverviewDetails.as_view(), name='hiring_plan_overview'), #TODO screen to develop and integrated
    path('hiring_interview_rounds/', HiringInterviewRounds.as_view(), name='hiring_interview_rounds'),#Django Flow is Done
    path('hiring_skills/', HiringInterviewSkills.as_view(), name='hiring_skills'),#TODO screen to develop and integrated
    path('interview_planner_calc/', InterviewPlannerCalculation.as_view(), name='interview_planner_calc'),#TODO screen to develop and integrated
    # path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    # path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('interview_design_screen/', InterviewDesignScreenView.as_view(), name='interview_design_screen'),
    path('state_alert_responsibility/', StateAlertResposibilityView.as_view(), name='state_alert_responsibility'),
    # path('interviewer_calender/', InterviewerCalenderView.as_view(), name='interviewer_calender'),
    path('candidate_interview_stages/', CandidateInterviewStagesView.as_view(), name='candidate_interview_stages'),

    path('api/hiring-plans/', get_hiring_plans, name='hiring_plans'), #TODO screen to develop and integrated
    path('api/hiring-plan/details/', get_hiring_plan_details, name='hiring_plan_details'), #TODO screen to develop and integrated
    path('get_requisition_by_id/', JobRequisitionViewSet.as_view({'post': 'get_requisition_by_id'}), name='get_requisition_by_id'), #TODO screen to develop and integrated

    path('api/', include(router1.urls)),#TODO home screen to develop and integrated
    path('api/', include(router2.urls)),#TODO get template to develop and integrated
    path("candidates/screening/", CandidateScreeningView.as_view(), name="candidate-screening"),#TODO screen to develop and integrated
    path("candidates/schedule-meet/", ScheduleMeetView.as_view(), name="schedule-meet"),# TODO testing in process
    
    path('api/schedule/context/', ScheduleContextAPIView.as_view()),
    path('api/interviewers/', InterviewerListCreateAPIView.as_view(), name='interviewer-list-create'),# create interviewer slot

    path('api/interview/review/', SubmitInterviewReviewView.as_view()),  # Submitting feedback
    path('api/interview/report/', InterviewReportAPIView.as_view()),  # Generating interview report

    path("api/interview/schedules/", GetInterviewScheduleAPIView.as_view()),

]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


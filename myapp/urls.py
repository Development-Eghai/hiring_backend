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
from myapp import views
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


router3 = DefaultRouter()
router3.register(r'offer-negotiations', OfferNegotiationViewSet, basename='offer-negotiation')


router4 = DefaultRouter()
router4.register(r'candidate-submissions', CandidateSubmissionViewSet, basename='candidate-submission')





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

    path('reqs/ids/', get_all_req_ids, name='get_all_req_ids'),

    path('api/', include(router3.urls)),

    path('api/set-approver/', ApproverCreateListView.as_view(), name='set-approver'),
    path('api/set-approver/filter/', ApproverFilterView.as_view(), name='filter-approver'),

    path('interivew_design_dashboard/', InterviewScreenDashboardView.as_view(), name='interivew_desing_dashboard'),
    path('get_plan_id_position_role/', get_plan_id_position_role, name='get_plan_id_position_role'),

    path('filter_candidates_dashboard/', filter_candidates_dashboard, name='filter_candidates_dashboard'),
    
    path('api/', include(router4.urls)),
    path('api/candidate-submissions/get-submissions-by-candidate-id/', CandidateSubmissionViewSet.as_view({'post': 'get_submissions_by_candidate_id'})),
    path('approval/approve/<int:negotiation_id>/', views.approve_offer, name='approve-offer'),
    path('approval/reject/<int:negotiation_id>/', views.reject_offer, name='reject-offer'),


    path('configuration/', admin_configuration, name='configuration'),
    path('config_position_role/', ConfigPositionRoleView.as_view(), name='config_position_role'),
    path('position-role/search/', ConfigPositionRoleSearchView.as_view(), name='position_role_search'),
    path('screening-type/search/', ConfigScreeningTypeSearchView.as_view(), name='screening_type_search'),
    path('scorecard/search/', ConfigScoreCardSearchView.as_view(), name='score_card_search'),
    path('config_screening_type/', ConfigScreeningTypeView.as_view(), name='config_screening_type'),
    path('config_score_card/', ConfigScoreCardView.as_view(), name='config_score_card'),
    path('design_screen_list_data/', design_screen_list_data, name='design_screen_list_data'),
    path('manage-requisition/', ManageRequisitionView.as_view(), name='manage_requisition'),

    path('api/candidates/interview-details/', CandidateInterviewDetailView.as_view(), name='candidate-interview-details'),
    path("api/candidates/all-details/", CandidateAllRequisitionsView.as_view(), name="candidate-all-details"),
    path("api/candidates/update-details/", CandidateUpdateView.as_view(), name="candidate-update-details"),
    path("api/candidates/resume/", ResumeAccessView.as_view(), name="candidate-resume-url"),
    path("api/candidates/export-excel/", CandidateExcelExportView.as_view(), name="candidate-export-excel")



]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


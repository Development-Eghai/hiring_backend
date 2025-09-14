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
from .views import InterviewPlannerCalculation,AdminConfigurationView
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
    path("bg-packages/dropdown/", get_bg_package_dropdown, name="bg-package-dropdown"),
    path('api/requisition/assign-recruiter/', assign_recruiter_to_requisition, name='assign-recruiter'),

    path('resend-approval-emails/', resend_approval_emails, name='resend_approval_emails'),


    path('api/hiring-plan/compensation-ranges/', get_all_compensation_ranges, name='get_all_compensation_ranges'),
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
    # path('candidate-interview-stage-details/', CandidateInterviewStageView.as_view(), name='candidate-interview-stage-details'),
    path('candidate-interview-journey/', InterviewJourneyView.as_view(), name='candidate-interview-journey'),
    path('api/interview-review/', GetCandidateReviewView.as_view(), name='get_candidate_review'),

    path('api/hiring-plans/', get_hiring_plans, name='hiring_plans'), #TODO screen to develop and integrated
    path('api/hiring-plan/details/', get_hiring_plan_details, name='hiring_plan_details'), #TODO screen to develop and integrated
    path('get_requisition_by_id/', JobRequisitionViewSet.as_view({'post': 'get_requisition_by_id'}), name='get_requisition_by_id'), #TODO screen to develop and integrated

    path('api/', include(router1.urls)),#TODO home screen to develop and integrated
    path('api/', include(router2.urls)),#TODO get template to develop and integrated
    
    path("candidates/by-requisition/", CandidateListByRequisitionView.as_view(), name="candidates-by-req"),
    path("interviewer/by-requisition/", InterviewerListByRequisitionView.as_view(), name="interviewer-by-req"),
    path("api/interviewer-context/", InterviewerContextAPIView.as_view(), name="interviewer_context"),

    path("candidates/detail/", CandidateDetailView.as_view(), name="candidate-detail"),
    path("get-reviews-by-candidate/", get_reviews_by_candidate, name="get-reviews-by-candidate"),
    path("candidates/screening/", CandidateScreeningView.as_view(), name="candidate-screening"),#TODO screen to develop and integrated
    path("candidates/screening/view/", CandidateScreening.as_view(), name="candidate-screening-view"),#TODO screen to develop and integrated
    path('api/approve-decision', CandidateApprovalDecisionView.as_view(), name='candidate_approval_decision'),

    path("candidates/schedule-meet/", ScheduleMeetView.as_view(), name="schedule-meet"),# TODO testing in process
    path("schedule-meet/", ScheduleCandidateRecruiterMeetView.as_view(), name="schedule_meet"),
    path("api/schedule/update/", update_interview_schedule, name="update-interview-schedule"),
    path("api/schedule/delete/", delete_interview_schedule, name="delete-interview-schedule"),
    path("api/schedule/get/", get_interview_schedule_by_id, name="get-interview-schedule-by-id"),

    path('api/schedule/context/', ScheduleContextAPIView.as_view()),
    path('api/interviewers/', InterviewerListCreateAPIView.as_view(), name='interviewer-list-create'),# create interviewer slot

    path('api/interview/review/', SubmitInterviewReviewView.as_view()),  # Submitting feedback
    path('api/interview-reviews/', GetInterviewReviewsByCandidate.as_view(), name='get_interview_reviews_by_candidate'),
    path('api/interview/report/', InterviewReportAPIView.as_view()),  # Generating interview report

    path("api/interview/schedules/", GetInterviewScheduleAPIView.as_view()),

    path('reqs/ids/', get_all_req_ids, name='get_all_req_ids'),

    path('api/', include(router3.urls)),

    path('api/set-approver/', ApproverCreateListView.as_view(), name='set-approver'),
    path('api/set-approver/filter/', ApproverFilterView.as_view(), name='filter-approver'),
    path("api/approvers/by-requisition/", get_approvers_by_requisition, name="get-approvers-by-requisition"),


    path('interivew_design_dashboard/', InterviewScreenDashboardView.as_view(), name='interivew_desing_dashboard'),
    path('get_plan_id_position_role/', get_plan_id_position_role, name='get_plan_id_position_role'),

    path('filter_candidates_dashboard/', filter_candidates_dashboard, name='filter_candidates_dashboard'),
    
    path('api/', include(router4.urls)),
    path('api/candidate-submissions/get-submissions-by-candidate-id/', CandidateSubmissionViewSet.as_view({'post': 'get_submissions_by_candidate_id'})),
    path("send-form-link/", send_form_invite, name="send-form-link"),

    
    path('approval/approve/<int:negotiation_id>/', views.approve_offer, name='approve-offer'),
    path('approval/reject/<int:negotiation_id>/', views.reject_offer, name='reject-offer'),
    path('candidate-approver-status/', CandidateApprovalStatusView.as_view(), name='candidate-approver-status'),
    path("offer-approvals/status/", OfferApprovalStatusView.as_view(), name="offer-approval-status"),


    path('configuration/', admin_configuration, name='configuration'),
    path('admin_configuration/', AdminConfigurationView.as_view(), name='admin_configuration'),
    path('admin_configuration/mapped_admin_configurations/', MappedAdminConfigView.as_view()),
    path('config_position_role/', ConfigPositionRoleView.as_view(), name='config_position_role'),
    path('position-role/search/', ConfigPositionRoleSearchView.as_view(), name='position_role_search'),
    path('screening-type/search/', ConfigScreeningTypeSearchView.as_view(), name='screening_type_search'),
    path('scorecard/search/', ConfigScoreCardSearchView.as_view(), name='score_card_search'),    
    path('design_screen_list_data/', design_screen_list_data, name='design_screen_list_data'),
    path('design_screen_list_data_interviewer/', design_screen_list_data_interviewer, name='design_screen_list_data_interviewer'),
    path('manage-requisition/', ManageRequisitionView.as_view(), name='manage_requisition'),
    path('api/candidates/interview-details/', CandidateInterviewDetailView.as_view(), name='candidate-interview-details'),
    path("api/candidates/all-details/", CandidateAllRequisitionsView.as_view(), name="candidate-all-details"),
    path("api/candidates/update-details/", CandidateUpdateView.as_view(), name="candidate-update-details"),
    path("api/candidates/resume/", ResumeAccessView.as_view(), name="candidate-resume-url"),
    path("api/candidates/export-excel/", CandidateExcelExportView.as_view(), name="candidate-export-excel"),
    path("candidates/delete/", CandidateDeleteView.as_view(), name="candidate-delete"),
    path('interviewer_bandwidth_dashboard/', InterviewerBandwidthDashboard.as_view(), name='interviewer_bandwidth_dashboard'),
    path('api/client-lookup/', client_lookup_from_plan, name='client-lookup'),
    path("api/job/metadata/", job_metadata_lookup, name="job-metadata-lookup"),
    path("api/design/by-id/", interview_design_by_id, name="interview-design-by-id"),
    path("api/planner/by-id/", interview_planner_by_id, name="interview-planner-by-id"),
    path('api/hiringplan/detail/', HiringPlanDetailView.as_view(), name='hiringplan-detail'),
    path("offer/generate/", GenerateOfferView.as_view(), name="generate-offer"),
    path('api/offer-details/', OfferDetailsViewSet.as_view(), name='offer-details'),
    path("offer-details/fetch-offer/", OfferRetrievalView.as_view(), name="fetch_offer"),
    path("offer-details/prefill-generate-offer/", GenerateOfferPrefillView.as_view(), name="prefill_generate_offer"),

    path("bg-package-setup/", BgPackageSetupView.as_view(), name="bg-package-setup"),
    path("initiate-bg-check/", BgCheckRequestView.as_view(), name="initiate-bg-check"),
    path('api/bg-check-dashboard/', BgCheckDashboardView.as_view(), name='bg-check-dashboard'),
    # path("bg-check-request/", BgCheckRequestView.as_view(), name="bg-check-request"),
    path('api/bg-check/contextual-data/', BgCheckContextualDetailsView.as_view(), name='bg-check-contextual-data'),
    path('bg/contextual/checks/', BgAddonChecksView.as_view(),name='bg-addon-checks'),
    path('vendor-packages/', VendorPackageView.as_view(),name='vendor-packages'),
    path("bg-check/packages-by-vendor/", BgPackageByVendorView.as_view(), name="bg-packages-by-vendor"),



    path('recruiter/send_pre_onboarding_form_invite/', send_pre_onboarding_form_invite, name='send_pre_onboarding_form_invite'),



    path("api/candidate/pre-onboarding-form/all/", get_all_pre_onboarding_forms, name="get_all_pre_onboarding_forms"),
    path(
        "api/candidate/pre-onboarding-form/",
        submit_pre_onboarding_form,
        name="submit_pre_onboarding_form"
    ),

    path('api/candidate-feedback/add/', views.add_candidate_feedback, name='add_candidate_feedback'),
    path('api/candidate-feedback/export/', views.export_candidate_feedback_excel, name='export_candidate_feedback_excel'),
    path('api/candidate-feedback/', get_all_candidate_feedback, name='get_all_candidate_feedback'),
    path("api/offer-report/", get_candidate_offer_report, name="get_candidate_offer_report"),
    path('report/export-offer/', export_candidate_offer_excel, name='export-candidate-offer-excel'),

    path('api/declined-offer-report/', get_declined_offer_report, name='declined_offer_report'),
    path('report/export-declined/', export_declined_offer_excel, name='export-declined-offer-excel'),

    path('api/yet-to-join-report/', get_yet_to_join_offer_report, name='yet_to_join_report'),
     path('report/export-yet-to-join/', export_yet_to_join_offer_excel, name='export-yet-to-join-offer-excel'),


    path('report/dropdowns/', get_report_dropdowns, name='get-report-dropdowns'),


]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


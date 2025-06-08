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



router = DefaultRouter()
router.register(r'jobrequisition', JobRequisitionViewSet)
router1 = DefaultRouter()
router1.register(r'job-requisition', JobRequisitionViewSetget)


# Define URL patterns
urlpatterns = [
    path("admin/", admin.site.urls),          # Admin interface
    path('login/', login_page, name='login_page'),    # Login page
    # path('submit-candidate/', submit_candidate, name='submit_candidate'),
    path('get-job-requisitions/', get_job_requisitions, name='get_job_requisitions1'),
    path('api/match-resumes/', ResumeMatchingAPI.as_view(), name='match_resumes'),
    path('api/', include(router.urls)),
    path('api/', include(router1.urls)),
]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


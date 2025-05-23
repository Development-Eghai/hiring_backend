# Import necessary modules
from django.contrib import admin  # Django admin module
from django.urls import path       # URL routing
from myapp.views import *  # Import views from the authentication app
from django.conf import settings   # Application settings
from django.contrib.staticfiles.urls import staticfiles_urlpatterns  # Static files serving

# Define URL patterns
urlpatterns = [
    path('home/', home, name="recipes"),      # Home page
    path("admin/", admin.site.urls),          # Admin interface
    path('login/', login_page, name='login_page'),    # Login page
    path('register/', register_page, name='register'),  # Registration page
    path("dashboard/", dashboard, name="dashboard"),
     path("logout/", logout_view, name="logout")
]

# Serve media files if DEBUG is True (development mode)
# if settings.DEBUG:
#     urlpatterns += staticfiles_urlpatterns(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# # Serve static files using staticfiles_urlpatterns
# urlpatterns += staticfiles_urlpatterns()
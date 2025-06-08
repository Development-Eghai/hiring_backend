from django.db import models

# Create your models here.
class Candidates(models.Model):
    CandidateID = models.AutoField(primary_key=True)
    Name = models.CharField(max_length=255,blank=True)
    Email = models.CharField(max_length=255,unique=True)
    Resume = models.FileField(upload_to='resumes/')
    ProfileCreated = models.DateTimeField(auto_now_add=True)
    #  pdf_file = models.FileField(upload_to='pdfs/')

    def __str__(self):
        return self.Name
    
    class Meta:
        db_table = 'candidates'
        managed = False

class UserDetails(models.Model):
    UserID = models.AutoField(primary_key=True)
    Name = models.CharField(max_length=255,blank=True)
    RoleID = models.IntegerField()
    Email = models.CharField(max_length=255,blank=True)
    PasswordHash = models.CharField(max_length=255,blank=True)
    Created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.Name
    
    class Meta:
        db_table = 'users_details'
        managed = False

class UserroleDetails(models.Model):
    RoleID = models.IntegerField(primary_key=True)  # Explicitly set primary key
    RoleName = models.CharField(max_length=255, blank=True)

    class Meta:
        db_table = 'userrole'
        managed = False
  

# class JobRequisition(models.Model):
#     RequisitionID = models.AutoField(primary_key=True)
#     PositionTitle = models.CharField(max_length=191)
#     No_of_positions = models.PositiveIntegerField(default=1)  # New field for number of positions
#     HiringManagerID = models.IntegerField()
#     recruiter = models.CharField(max_length=255,blank=True)
#     STATUS_CHOICES = [
#         ('Draft', 'Draft'),
#         ('Pending Approval', 'Pending Approval'),
#         ('Approved', 'Approved'),
#         ('Posted', 'Posted'),
#     ]
#     Status = models.CharField(max_length=50, choices=STATUS_CHOICES, default='Draft')
#     CreatedDate = models.DateTimeField(auto_now_add=True)
#     class Meta:
#         db_table = 'jobrequisition'
#     def __str__(self):
#         return self.PositionTitle


class JobRequisition(models.Model):
    RequisitionID = models.AutoField(primary_key=True)
    PositionTitle = models.CharField(max_length=191, null=True, blank=True, default="Not Provided")
    HiringManagerID = models.IntegerField(null=True, blank=True)
    Recruiter = models.CharField(max_length=191, null=True, blank=True, default="Not Assigned")
    No_of_positions = models.IntegerField(null=True, blank=True, default=1)
    Status = models.CharField(
        max_length=50,
        choices=[('Draft', 'Draft'),
                 ('Pending Approval', 'Pending Approval'),
                 ('Approved', 'Approved'),
                 ('Posted', 'Posted')],
        default='Draft'
    )
    CreatedDate = models.DateTimeField(auto_now_add=True)
    UpdatedDate = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'jobrequisition'

    def __str__(self):
        return self.PositionTitle

class RequisitionDetails(models.Model):
    requisition = models.OneToOneField(JobRequisition, on_delete=models.CASCADE, related_name="details")
    # requisition = models.ForeignKey(JobRequisition, on_delete=models.CASCADE, related_name="details",unique=True)

    internal_title = models.CharField(max_length=255, null=True, blank=True, default="Unknown Title")
    external_title = models.CharField(max_length=255, null=True, blank=True, default="Unknown Title")
    position = models.CharField(max_length=255, null=True, blank=True, default="Not Provided")
    business_line = models.CharField(max_length=255, null=True, blank=True, default="General Business")
    business_unit = models.CharField(max_length=255, null=True, blank=True, default="General Unit")
    division = models.CharField(max_length=255, null=True, blank=True, default="Unknown Division")
    department = models.CharField(max_length=255, null=True, blank=True, default="Unknown Department")
    location = models.CharField(max_length=255, null=True, blank=True, default="Not Provided")
    geo_zone = models.CharField(max_length=255, null=True, blank=True, default="Global")
    employee_group = models.CharField(max_length=255, null=True, blank=True, default="General Employee Group")
    employee_sub_group = models.CharField(max_length=255, null=True, blank=True, default="General Sub Group")
    
    contract_start_date = models.DateField(null=True, blank=True, default=None)
    contract_end_date = models.DateField(null=True, blank=True, default=None)
    
    career_level = models.CharField(max_length=50, null=True, blank=True, default="Entry Level")
    band = models.CharField(max_length=50, null=True, blank=True, default="N/A")
    sub_band = models.CharField(max_length=50, null=True, blank=True, default="N/A")
    
    primary_skills = models.TextField(null=True, blank=True, default="Not Specified")
    secondary_skills = models.TextField(null=True, blank=True, default="None")
    
    mode_of_working = models.CharField(max_length=50, null=True, blank=True, default="Office")
    requisition_type = models.CharField(max_length=50, null=True, blank=True, default="Standard Hiring")
    
    client_interview = models.BooleanField(default=False)
    required_score = models.IntegerField(null=True, blank=True, default=0)
    
    onb_coordinator = models.CharField(max_length=255, null=True, blank=True, default="Not Assigned")
    onb_coordinator_team = models.TextField(null=True, blank=True, default="No Team Assigned")
    isg_team = models.TextField(null=True, blank=True, default="No ISG Team Assigned")
    
    interviewer_teammate_employee_id = models.CharField(max_length=50, null=True, blank=True, default="Not Available")

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'requisition_details'

    def __str__(self):
        return self.requisition.PositionTitle

class BillingDetails(models.Model):
    # One-to-One relationship with JobRequisition
    requisition = models.OneToOneField(JobRequisition, on_delete=models.CASCADE, related_name="billing_details")
    billing_type = models.CharField(max_length=50, null=True, blank=True, default="Non-Billable")
    billing_start_date = models.DateField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'billing_details'

    def __str__(self):
        return f"Billing for {self.requisition}"


class PostingDetails(models.Model):
    # One-to-One relationship with JobRequisition
    requisition = models.OneToOneField(JobRequisition, on_delete=models.CASCADE, related_name="posting_details")
    experience = models.CharField(max_length=255, null=True, blank=True, default="0+ years")
    designation = models.CharField(max_length=255, null=True, blank=True, default="Unknown Role")
    job_category = models.CharField(max_length=255, null=True, blank=True, default="General")
    job_region = models.CharField(max_length=255, null=True, blank=True, default="Global")
    internal_job_description = models.TextField(null=True, blank=True, default="No Description")
    external_job_description = models.TextField(null=True, blank=True, default="No Description Available")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'posting_details'

    def __str__(self):
        return f"Posting for {self.requisition}"


class InterviewTeam(models.Model):
    # Many-to-One relationship with JobRequisition
    requisition = models.ForeignKey(JobRequisition, on_delete=models.CASCADE, related_name="interview_team")
    employee_id = models.CharField(max_length=50, null=True, blank=True, default="Unknown ID")
    name = models.CharField(max_length=255, null=True, blank=True, default="Unknown Interviewer")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'interview_team'

    def __str__(self):
        return f"Interview team for {self.requisition}"


class Teams(models.Model):
    # Many-to-One relationship with JobRequisition
    requisition = models.ForeignKey(JobRequisition, on_delete=models.CASCADE, related_name="teams")
    team_type = models.CharField(max_length=50, null=True, blank=True, default="General Team")
    team_name = models.CharField(max_length=255, null=True, blank=True, default="Unknown Team")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'teams'

    def __str__(self):
        return f"Team {self.team_name} for {self.requisition}"


class Posting(models.Model):
    PostingID  = models.AutoField(primary_key=True)
    RequisitionID  = models.IntegerField(db_index=True)
    PostingType = models.CharField(
        max_length=10,
        choices=[
            ('Intranet', 'Intranet'),
            ('External', 'External'),
            ('Private', 'Private')
        ]
    )
    PostingStatus = models.CharField(
        max_length=10,
        choices=[
            ('Pending', 'Pending'),
            ('Posted', 'Posted'),
            ('Closed', 'Closed')
        ],
        default='Pending'
    )
    StartDate = models.DateField(null=True, blank=True)
    EndDate = models.DateField(null=True, blank=True)
    class Meta:
        db_table = 'jobposting'
    def __str__(self):
        return f"{self.posting_id} - {self.posting_type}"


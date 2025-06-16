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
    ResetToken = models.CharField(max_length=64, blank=True, null=True)
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
    HiringManager = models.ForeignKey(UserDetails, on_delete=models.SET_NULL, null=True, db_column="HiringManagerID", related_name="requisitions")
    # HiringManager = models.ForeignKey(UserDetails, on_delete=models.CASCADE, db_column="HiringManagerID", related_name="requisitions")  # ForeignKey
    Recruiter = models.CharField(max_length=191, null=True, blank=True, default="Not Assigned")
    No_of_positions = models.IntegerField(null=True, blank=True, default=1)
    Status = models.CharField(
        max_length=50,
        choices=[
            ('Draft', 'Draft'),
            ('Pending Approval', 'Pending Approval'),
            ('Approved', 'Approved'),
            ('Posted', 'Posted')
        ],
        default='Pending Approval'
    )
    CreatedDate = models.DateTimeField(auto_now_add=True)
    UpdatedDate = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'jobrequisition'

    def __str__(self):
        return f"{self.PositionTitle} - Managed by {self.HiringManager.Name}"
    
    
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

class Candidate(models.Model):
    CandidateID = models.AutoField(primary_key=True)
    Name = models.CharField(max_length=191)
    Email = models.CharField(max_length=191)
    Resume = models.TextField(null=True, blank=True)
    ProfileCreated = models.DateTimeField(auto_now_add=True)
    class Meta:
        db_table = 'candidates'
    def __str__(self):
        return f"{self.CandidateID} - {self.Name}"

class HiringPlan(models.Model):
    hiring_plan_id = models.AutoField(primary_key=True)
    job_position = models.CharField(max_length=255,blank=True)
    tech_stacks = models.CharField(max_length=255,unique=True)
    jd_details = models.CharField(max_length=255,unique=True)    
    designation = models.CharField(max_length=255,blank=True)
    experience_range = models.CharField(max_length=255,blank=True)
    target_companies = models.CharField(max_length=255,blank=True)
    compensation = models.CharField(max_length=255,blank=True)
    working_model = models.CharField(max_length=255,blank=True)
    interview_status = models.CharField(max_length=255,blank=True)
    location = models.CharField(max_length=255,blank=True)
    education_decision = models.CharField(max_length=255,blank=True)
    relocation = models.CharField(max_length=255,blank=True)
    travel_opportunities = models.CharField(max_length=255,blank=True)
    domain_knowledge = models.CharField(max_length=255,blank=True)
    visa_requirements = models.CharField(max_length=255,blank=True)
    background_verification = models.CharField(max_length=255,blank=True)
    shift_timings = models.CharField(max_length=255,blank=True)
    role_type = models.CharField(max_length=255,blank=True)
    job_type = models.CharField(max_length=255,blank=True)
    communication_language = models.CharField(max_length=255,blank=True)
    notice_period = models.CharField(max_length=255,blank=True)
    additional_comp = models.CharField(max_length=255,blank=True)
    citizen_requirement = models.CharField(max_length=255,blank=True)
    career_gap = models.CharField(max_length=255,blank=True)
    sabbatical = models.CharField(max_length=255,blank=True)
    screening_questions = models.CharField(max_length=255,blank=True)
    job_health_requirements = models.CharField(max_length=255,blank=True)
    social_media_links = models.CharField(max_length=255,blank=True)
    language_proficiency = models.CharField(max_length=255,blank=True)
    
    class Meta:
        db_table = 'job_hiring_overview'
        managed = False

class InterviewRounds(models.Model):
    id = models.AutoField(primary_key=True)
    requisition_id = models.IntegerField()
    round_name = models.CharField(max_length=255,blank=True)
    updt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'job_request_interview_rounds'
        managed = False

class CommunicationSkills(models.Model):
    id = models.AutoField(primary_key=True)
    requisition_id = models.IntegerField()
    skill_name = models.CharField(max_length=255,blank=True)
    skill_value = models.CharField(max_length=255,blank=True)
    updt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'job_communication_skills'
        managed = False



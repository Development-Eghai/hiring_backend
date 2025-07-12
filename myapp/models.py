from django.db import models
from django.core.mail import send_mail
from django.conf import settings
from django.utils.timezone import now


class HiringPlan(models.Model):
    id = models.AutoField(primary_key=True)
    hiring_plan_id = models.CharField(max_length=50,blank=True,unique=True,db_index=True)
    job_position = models.CharField(max_length=255,blank=True)
    tech_stacks = models.CharField(max_length=255,blank=True)
    jd_details = models.CharField(max_length=255,blank=True)    
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
    # requisition_date = models.DateField(null=True, blank=True)
    # due_requisition_date = models.DateField(null=True, blank=True)
    requisition_template = models.CharField(max_length=255,blank=True)
    no_of_openings = models.IntegerField(default=0)
    mode_of_working = models.CharField(max_length=255, blank=True)
    relocation_amount = models.CharField(max_length=255, blank=True)
    domain_yn = models.CharField(max_length=255, blank=True)
    domain_name = models.CharField(max_length=255, blank=True)
    education_qualification = models.CharField(max_length=255, blank=True)
    visa_country = models.CharField(max_length=255, blank=True)
    visa_type = models.CharField(max_length=255, blank=True)
    github_link = models.CharField(max_length=255, blank=True)

    Created_at = models.DateTimeField(auto_now_add=True) 
    
    class Meta:
        db_table = 'job_hiring_overview'
        managed = False

class InterviewRounds(models.Model):
    id = models.AutoField(primary_key=True)
    plan_id = models.CharField(max_length=50,blank=True)
    round_name = models.CharField(max_length=255,blank=True)
    updt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'job_request_interview_rounds'
        managed = False

class CommunicationSkills(models.Model):
    id = models.AutoField(primary_key=True)
    plan_id = models.CharField(max_length=50,blank=True)
    skill_name = models.CharField(max_length=255,blank=True)
    skill_value = models.CharField(max_length=255,blank=True)
    updt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'job_communication_skills'
        managed = False
# Create your models here.
class Candidates(models.Model):
    CandidateID = models.AutoField(primary_key=True)
    Name = models.CharField(max_length=255,blank=True)
    Email = models.CharField(max_length=255,unique=True)
    Resume = models.FileField(upload_to='resumes/')
    #  pdf_file = models.FileField(upload_to='pdfs/')
    Final_rating = models.IntegerField()
    Feedback = models.TextField(null=True, blank=True)
    Result = models.CharField(max_length=50,blank=True)
    ProfileCreated = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.Name
    
    class Meta:
        db_table = 'candidates'
        managed = False

class CandidateSubmission(models.Model):
    candidate = models.ForeignKey(
        'Candidates',  # Referencing existing model
        to_field='CandidateID',
        on_delete=models.CASCADE,
        related_name='submissions'
    )

    recruiter_email = models.EmailField()
    job_title = models.CharField(max_length=100)
    start_date = models.DateField()
    city = models.CharField(max_length=100)
    country = models.CharField(max_length=100)
    currency = models.CharField(max_length=10)

    salary = models.DecimalField(max_digits=12, decimal_places=2)
    variable_pay = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)

    status = models.CharField(max_length=50)
    open_date = models.DateField()
    target_start_date = models.DateField()
    close_date = models.DateField(null=True, blank=True)
    close_reason = models.TextField(null=True, blank=True)
    opening_salary_currency = models.CharField(max_length=10)
    opening_salary_range = models.CharField(max_length=50)

    driving_license_number = models.CharField(max_length=50, null=True, blank=True)
    driving_license_validity = models.DateField(null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'candidate_submission'

    def __str__(self):
        return f"{self.candidate.Name} — {self.job_title}"
    
class CandidateReference(models.Model):
    candidate_submission = models.ForeignKey(
        CandidateSubmission,
        on_delete=models.CASCADE,
        related_name='references'
    )

    name = models.CharField(max_length=100)
    designation = models.CharField(max_length=100)
    organization = models.CharField(max_length=100)
    relationship = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=20)
    email = models.EmailField()
    address = models.TextField()

    class Meta:
        db_table = 'candidate_reference'

class UserDetails(models.Model):
    id = models.AutoField(primary_key=True)
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
    id = models.AutoField(primary_key=True)
    RequisitionID = models.CharField(max_length=50, unique=True, db_index=True)
    Planning_id = models.ForeignKey(
    'myapp.HiringPlan',  # Explicitly reference the app name
    on_delete=models.CASCADE,
    db_column="Planning_id",
    related_name="requisition"
    )
    PositionTitle = models.CharField(max_length=191, null=True, blank=True, default="Not Provided")
    HiringManager = models.ForeignKey(UserDetails, on_delete=models.SET_NULL, null=True, db_column="HiringManagerID", related_name="requisitions")
    Recruiter = models.CharField(max_length=191, null=True, blank=True, default="Not Assigned")
    No_of_positions = models.IntegerField(null=True, blank=True, default=1)
    # Inside JobRequisition model
    LegalEntityID = models.CharField(max_length=50, null=True, blank=True, default="0")  # for legal_entry
    QualificationID = models.CharField(max_length=100, null=True, blank=True, default="B.Tech")  # for qualification
    Status = models.CharField(
    max_length=50,
    choices=[
        ('Pending Approval', 'Pending Approval'),
        ('Need More Details', 'Need More Details'),
        ('Approved', 'Approved'),
        ('Rejected', 'Rejected')
    ],
    default='Pending Approval'
    )
    CommentFromBusinessOps = models.TextField(
    null=True,
    blank=True,
    default="",
    help_text="Optional remarks or clarification from Business Ops during review."
    )
    CreatedDate = models.DateTimeField(auto_now_add=True)
    UpdatedDate = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'jobrequisition'
        


    def __str__(self):
        hiring_manager_name = self.HiringManager.Name if self.HiringManager else "Unknown"
        return f"{self.PositionTitle} - Managed by {hiring_manager_name}"
    
    
class RequisitionDetails(models.Model):
    requisition = models.OneToOneField(
    JobRequisition,
    to_field='RequisitionID',
    on_delete=models.CASCADE,
    related_name='position_information'
    )
    # requisition = models.OneToOneField(JobRequisition, on_delete=models.CASCADE, related_name="details")
    # requisition = models.ForeignKey(JobRequisition, on_delete=models.CASCADE, related_name="details",unique=True)

    internal_title = models.CharField(max_length=255, null=True, blank=True, default="Unknown Title")
    external_title = models.CharField(max_length=255, null=True, blank=True, default="Unknown Title")
    job_position = models.CharField(max_length=255, null=True, blank=True, default="Not Provided")
    business_line = models.CharField(max_length=255, null=True, blank=True, default="General Business")
    business_unit = models.CharField(max_length=255, null=True, blank=True, default="General Unit")
    division = models.CharField(max_length=255, null=True, blank=True, default="Unknown Division")
    department = models.CharField(max_length=255, null=True, blank=True, default="Unknown Department")
    location = models.CharField(max_length=255, null=True, blank=True, default="Not Provided")
    geo_zone = models.CharField(max_length=255, null=True, blank=True, default="Global")
    employee_group = models.CharField(max_length=255, null=True, blank=True, default="General Employee Group")
    employee_sub_group = models.CharField(max_length=255, null=True, blank=True, default="General Sub Group")
    company_client_name = models.CharField(max_length=255, null=True, blank=True, default="")
    contract_start_date = models.DateField(null=True, blank=True, default=None)
    contract_end_date = models.DateField(null=True, blank=True, default=None)
    
    career_level = models.CharField(max_length=50, null=True, blank=True, default="Entry Level")
    band = models.CharField(max_length=50, null=True, blank=True, default="N/A")
    sub_band = models.CharField(max_length=50, null=True, blank=True, default="N/A")
    
    primary_skills = models.TextField(null=True, blank=True, default="Not Specified")
    secondary_skills = models.TextField(null=True, blank=True, default="None")
    
    working_model = models.CharField(max_length=50, null=True, blank=True, default="Office")
    requisition_type = models.CharField(max_length=50, null=True, blank=True, default="Standard Hiring")
    
    client_interview = models.CharField(max_length=10, null=True, blank=True, default="NO")
    required_score = models.IntegerField(null=True, blank=True, default=0)
    requisition_date = models.DateField(null=True, blank=True)
    due_requisition_date = models.DateField(null=True, blank=True)
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
    requisition = models.OneToOneField(
        JobRequisition,
        to_field='RequisitionID',
        on_delete=models.CASCADE,
        related_name='billing_details'
    )

    billing_type = models.CharField(max_length=50, null=True, blank=True, default="Non-Billable")
    billing_start_date = models.DateField(null=True, blank=True)
    billing_end_date = models.DateField(null=True, blank=True)
    contract_start_date = models.DateField(null=True, blank=True)
    contract_end_date = models.DateField(null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'billing_details'

    def __str__(self):
        return f"Billing for {self.requisition}"


class PostingDetails(models.Model):
    # One-to-One relationship with JobRequisition
    # requisition = models.OneToOneField(JobRequisition, on_delete=models.CASCADE, related_name="posting_details")
    requisition = models.OneToOneField(
    JobRequisition,
    to_field='RequisitionID',
    on_delete=models.CASCADE,
    related_name='posting_details'
    )
    
    experience = models.CharField(max_length=255, null=True, blank=True, default="0+ years")
    designation = models.CharField(max_length=255, null=True, blank=True, default="Unknown Role")
    job_category = models.CharField(max_length=255, null=True, blank=True, default="General")
    job_region = models.CharField(max_length=255, null=True, blank=True, default="Global")
    internal_job_description = models.TextField(null=True, blank=True, default="No Description")
    qualification = models.CharField(max_length=255, null=True, blank=True)
    external_job_description = models.TextField(null=True, blank=True, default="No Description Available")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'posting_details'

    def __str__(self):
        return f"Posting for {self.requisition}"


class InterviewTeam(models.Model):
    # Many-to-One relationship with JobRequisition
    # requisition = models.ForeignKey(JobRequisition, on_delete=models.CASCADE, related_name="interview_team")
    requisition = models.ForeignKey(
    JobRequisition,
    to_field='RequisitionID',
    on_delete=models.CASCADE,
    related_name='interview_team'
    )
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
    # requisition = models.ForeignKey(JobRequisition, on_delete=models.CASCADE, related_name="teams")
    requisition = models.ForeignKey(
    JobRequisition,
    to_field='RequisitionID',
    on_delete=models.CASCADE,
    related_name='teams'
    )
    team_type = models.CharField(max_length=50, null=True, blank=True, default="General Team")
    team_name = models.CharField(max_length=255, null=True, blank=True, default="Unknown Team")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'teams'

    def __str__(self):
        return f"Team {self.team_name} for {self.requisition}"

class AssetDetails(models.Model):
    requisition = models.OneToOneField(
        JobRequisition,
        to_field='RequisitionID',
        on_delete=models.CASCADE,
        related_name='asset_details'
    )
    laptop_type = models.CharField(max_length=100, null=True, blank=True, default="Not Specified")
    laptop_needed = models.CharField(max_length=10, null=True, blank=True, default="No")
    additional_questions = models.CharField(max_length=10, null=True, blank=True, default="No")
    comments = models.TextField(null=True, blank=True, default="No Comments")

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'asset_details'

    def __str__(self):
        return f"Assets for {self.requisition}"

class RequisitionCompetency(models.Model):
    requisition = models.ForeignKey(
        JobRequisition,
        to_field='RequisitionID',
        on_delete=models.CASCADE,
        related_name='requisition_competencies'
    )
    competency = models.CharField(max_length=50, null=True, blank=True)
    library = models.CharField(max_length=50, null=True, blank=True)
    category = models.CharField(max_length=50, null=True, blank=True)
    expected_rating = models.CharField(max_length=50, null=True, blank=True)
    weight = models.CharField(max_length=50, null=True, blank=True)

    class Meta:
        db_table = 'requisition_competency'

class RequisitionQuestion(models.Model):
    requisition = models.ForeignKey(
        JobRequisition,
        to_field='RequisitionID',
        on_delete=models.CASCADE,
        related_name='requisition_questions'
    )
    question = models.CharField(max_length=100, null=True, blank=True)
    required = models.CharField(max_length=50, null=True, blank=True)
    disqualifier = models.CharField(max_length=10, null=True, blank=True)
    score = models.CharField(max_length=10, null=True, blank=True)
    weight = models.CharField(max_length=10, null=True, blank=True)

    class Meta:
        db_table = 'requisition_question'

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

    Req_id_fk = models.ForeignKey(
        JobRequisition,
        to_field='RequisitionID',
        on_delete=models.CASCADE,
        related_name="candidates",
        db_column="Req_id_fk"
    )

    Name = models.CharField(max_length=191)
    Email = models.CharField(max_length=191)
    Resume = models.TextField(null=True, blank=True)
    Final_rating = models.IntegerField(null=True, blank=True)
    Feedback = models.TextField(null=True, blank=True)
    Result = models.CharField(max_length=50, null=True, blank=True)
    ProfileCreated = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'candidates'

    def __str__(self):
        return f"{self.CandidateID} - {self.Name}"


class CandidateReview(models.Model):
    ReviewID = models.AutoField(primary_key=True)
    CandidateID = models.ForeignKey(
        Candidate,
        on_delete=models.CASCADE,
        db_column="CandidateID",
        related_name="reviews"
    )
    ParameterDefined = models.CharField(max_length=100, null=True, blank=True)
    Guidelines = models.CharField(max_length=100, null=True, blank=True)
    MinimumQuestions = models.IntegerField(null=True, blank=True)
    ActualRating = models.DecimalField(max_digits=3, decimal_places=1, null=True, blank=True)
    Feedback = models.TextField(null=True, blank=True)
    Created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'candidate_reviews'

    def __str__(self):
        return f"Review {self.ReviewID} for Candidate {self.CandidateID_id}"


class Interviewer(models.Model):
    interviewer_id = models.BigAutoField(primary_key=True)
    req_id = models.ForeignKey(
        JobRequisition,
        on_delete=models.CASCADE,
        related_name="interviewer",
        to_field='RequisitionID',
        db_column="req_id"
    )
    client_id = models.CharField(max_length=100)
    first_name = models.CharField(max_length=50, null=True, blank=True)
    last_name = models.CharField(max_length=50, null=True, blank=True)
    job_title = models.CharField(max_length=100, null=True, blank=True)
    interview_mode = models.CharField(max_length=50, null=True, blank=True)
    interviewer_stage = models.CharField(max_length=100, null=True, blank=True)
    email = models.EmailField(max_length=254, null=True, blank=True)
    contact_number = models.CharField(max_length=15, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'interviewer'

class InterviewSlot(models.Model):
    id = models.BigAutoField(primary_key=True)
    interviewer   = models.ForeignKey(Interviewer, on_delete=models.CASCADE,null=True,blank=True,db_column="interviewer_id", related_name='slots')
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'interview_slot'

class InterviewSchedule(models.Model):
    id = models.BigAutoField(primary_key=True)
    candidate = models.ForeignKey(Candidate, on_delete=models.CASCADE,db_column="candidate_id")
    interviewer = models.ForeignKey(Interviewer, on_delete=models.CASCADE,db_column="interviewer_id")
    round_name = models.CharField(max_length=100)
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    meet_link = models.URLField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'interview_schedule'

class InterviewReview(models.Model):
    schedule = models.ForeignKey(InterviewSchedule, on_delete=models.CASCADE, related_name='reviews')
    feedback = models.TextField(blank=True)
    result = models.CharField(max_length=100, blank=True)  # e.g., "Selected", "Rejected", etc.
    reviewed_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'interview_review'


class InterviewDesignScreen(models.Model):
    interview_design_id = models.AutoField(primary_key=True)
    hiring_plan_id = models.CharField(max_length=50,blank=True)
    req_id = models.CharField(max_length=50,blank=True)
    position_role = models.CharField(max_length=255,blank=True)
    tech_stacks = models.CharField(max_length=255,blank=True)
    screening_type = models.CharField(max_length=255,blank=True)
    no_of_interview_round = models.IntegerField(default=0)
    final_rating = models.IntegerField(default=0)
    status = models.CharField(max_length=255,blank=True)
    feedback = models.CharField(max_length=255,blank=True)

    class Meta:
        db_table = 'job_interview_design_screen'
        managed = False

class InterviewDesignParameters(models.Model):
    interview_desing_params_id = models.AutoField(primary_key=True)
    hiring_plan_id = models.CharField(max_length=50,blank=True)
    interview_design_id = models.IntegerField(default=0)
    score_card = models.CharField(max_length=255,blank=True)
    options = models.CharField(max_length=255,blank=True)
    guideline = models.CharField(max_length=255,blank=True)
    min_questions = models.IntegerField(default=0)
    screen_type = models.CharField(max_length=255,blank=True)
    duration = models.IntegerField(default=0)
    mode = models.CharField(max_length=255,blank=True)
    feedback = models.CharField(max_length=255,blank=True)

    class Meta:
        db_table = 'job_interview_design_parameters'
        managed = False

class CandidateInterviewStages(models.Model):
    interview_stage_id = models.AutoField(primary_key=True)
    interview_plan_id = models.IntegerField(default=0)
    candidate_id = models.IntegerField(default=0)
    recuiter_id = models.IntegerField(default=0)
    interview_stage = models.CharField(max_length=255,blank=True)  
    interview_date = models.DateField()
    mode_of_interview = models.CharField(max_length=255,blank=True)
    feedback = models.CharField(max_length=255,blank=True)
    status = models.CharField(max_length=255,blank=True)    
    
    class Meta:
        db_table = 'candidate_interview_stages'
        managed = False

class StageAlertResponsibility(models.Model):
    stage_id = models.AutoField(primary_key=True)
    hiring_plan_id = models.CharField(max_length=50,blank=True)
    role_name = models.CharField(max_length=255,blank=True)
    application_review = models.IntegerField(default=0)
    phone_review = models.IntegerField(default=0)  
    reference_check = models.IntegerField(default=0)
    face_to_face = models.IntegerField(default=0)
    verbal_offer = models.IntegerField(default=0)
    other = models.IntegerField(default=0)
    first_name = models.CharField(max_length=255,blank=True)
    last_name = models.CharField(max_length=255,blank=True)
    email_id = models.CharField(max_length=255,blank=True)
    phone_no = models.CharField(max_length=255,blank=True)   
    
    class Meta:
        db_table = 'job_stage_responsibility'
        managed = False

class OfferNegotiation(models.Model):
    requisition = models.ForeignKey(
        JobRequisition,
        to_field='RequisitionID',
        on_delete=models.CASCADE,
        related_name="offer_negotiations"
    )
    client_name = models.CharField(max_length=100)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    position_applied = models.CharField(max_length=150)
    
    expected_salary = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    offered_salary = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    
    expected_title = models.CharField(max_length=150, null=True, blank=True)
    offered_title = models.CharField(max_length=150, null=True, blank=True)
    
    expected_location = models.CharField(max_length=100, null=True, blank=True)
    offered_location = models.CharField(max_length=100, null=True, blank=True)
    
    expected_doj = models.DateField(null=True, blank=True)
    offered_doj = models.DateField(null=True, blank=True)
    
    expected_work_mode = models.CharField(max_length=50, null=True, blank=True)
    offered_work_mode = models.CharField(max_length=50, null=True, blank=True)
    
    negotiation_status = models.CharField(
        max_length=50,
        choices=[
            ("Successful", "Successful"),
            ("Closed", "Closed"),
            ("Sent for Realignment", "Sent for Realignment"),
            ("Failed", "Failed"),
            ("Open", "Open"),
            ("In progress", "In progress")
        ],
        default="Open"
    )
    
    comments = models.TextField(blank=True)
    benefits = models.ManyToManyField(
        'Benefit',
        through='OfferNegotiationBenefit',
        blank=True
    )


    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'offer_negotiation'

    def __str__(self):
        return f"{self.first_name} {self.last_name} - {self.position_applied} ({self.negotiation_status})"
    
    def save(self, *args, **kwargs):
        notify = False
        if self.pk:
            prev = OfferNegotiation.objects.get(pk=self.pk)
            if prev.negotiation_status != self.negotiation_status and self.negotiation_status == "Successful":
                notify = True
        else:
            if self.negotiation_status == "Successful":
                notify = True

        super().save(*args, **kwargs)

        if notify:
            self.notify_pending_approvers()

    def notify_pending_approvers(self):
        try:
            pending = ApprovalStatus.objects.filter(
                offer_negotiation=self, status="Pending"
            ).select_related('approver')

            for approval in pending:
                approver = approval.approver
                if not approver.email:
                    continue

                # approve_url = f"http://localhost:8000/approval/approve/{self.pk}/?role={approver.role}&email={approver.email}"
                # reject_url = f"http://localhost:8000/approval/reject/{self.pk}/?role={approver.role}&email={approver.email}"
                approve_url = f"https://api.pixeladvant.com/approval/approve/{self.pk}/?role={approver.role}&email={approver.email}"
                reject_url = f"https://api.pixeladvant.com/approval/reject/{self.pk}/?role={approver.role}&email={approver.email}"

                subject = f"✅ Offer Finalized — Action Needed: {self.first_name} {self.last_name}"
                html_message = f"""
                <html><body style="font-family: Arial, sans-serif;">
                    <h2>Offer Finalized</h2>
                    <p>The offer for <strong>{self.first_name} {self.last_name}</strong> (Position: <strong>{self.position_applied}</strong>) has been marked as <strong>Successful</strong>.</p>
                    <p><strong>Your approval is still pending.</strong></p>
                    <p>
                        <a href="{approve_url}" style="padding: 10px 20px; background-color: #28a745; color: white; text-decoration: none; border-radius: 4px;">✅ Approve</a>
                        <a href="{reject_url}" style="padding: 10px 20px; background-color: #dc3545; color: white; text-decoration: none; border-radius: 4px; margin-left: 15px;">❌ Reject</a>
                    </p>
                    <p><strong>Client:</strong> {self.client_name}</p>
                    <p><strong>Requisition ID:</strong> {self.requisition.RequisitionID}</p>
                    <p><strong>Comments:</strong> {self.comments or 'N/A'}</p>
                    <p style="font-size: 12px; color: gray;">Sent on {now().strftime('%d %b %Y, %I:%M %p')}</p>
                    <p>This is an automated system notification.</p>
                </body></html>
                """

                send_mail(
                    subject=subject,
                    message="Please view this in HTML format.",
                    html_message=html_message,
                    from_email=settings.DEFAULT_FROM_EMAIL,
                    recipient_list=[approver.email],
                )

        except Exception as e:
            print(f"[OfferNegotiation] Email failed: {e}")



class Benefit(models.Model):
    name = models.CharField(max_length=100, unique=True)

    class Meta:
        db_table = 'benefit'

    def __str__(self):
        return self.name
    
class OfferNegotiationBenefit(models.Model):
    offer_negotiation = models.ForeignKey(
        'OfferNegotiation',
        on_delete=models.CASCADE,
        related_name='offer_benefits'
    )
    benefit = models.ForeignKey(
        'Benefit',
        on_delete=models.CASCADE,
        related_name='benefit_offers'
    )

    class Meta:
        db_table = 'offer_negotiation_benefits'
        unique_together = ('offer_negotiation', 'benefit')

    def __str__(self):
        return f"{self.offer_negotiation} ↔ {self.benefit.name}"


class Approver(models.Model):
    ROLE_CHOICES = [
        ('HM', 'Hiring Manager'),
        ('FPNA', 'FPNA/Business Ops'),
        ('HR', 'HR/Recruitment Head'),
        ('CEO', 'CEO'),
        ('COO', 'COO'),
    ]

    hiring_plan = models.ForeignKey(HiringPlan, to_field='hiring_plan_id',on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField()
    contact_number = models.CharField(max_length=15, blank=True, null=True)
    job_title = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.role})"

    class Meta:
        db_table = 'approver'  # optional: use custom table name
        managed = False

class ApprovalStatus(models.Model):
    STATUS_CHOICES = [
        ("Pending", "Pending"),
        ("Approved", "Approved"),
        ("Rejected", "Rejected")
    ]

    offer_negotiation = models.ForeignKey(
        'OfferNegotiation',
        on_delete=models.CASCADE,
        related_name='approvals'
    )
    approver = models.ForeignKey(
        'Approver',
        on_delete=models.CASCADE
    )
    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="Pending"
    )
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'approval_status'
        unique_together = ('offer_negotiation', 'approver')  # Optional: prevent duplicate approvals

    def __str__(self):
        return f"{self.approver} - {self.offer_negotiation} [{self.status}]"
    

class ConfigPositionRole(models.Model):
    id = models.AutoField(primary_key=True)    
    position_role = models.CharField(max_length=255,blank=True)
    class Meta:
        db_table = 'config_job_position'
        managed = False
    
class ConfigScreeningType(models.Model):
    id = models.AutoField(primary_key=True)    
    screening_type_name = models.CharField(max_length=255,blank=True)
    class Meta:
        db_table = 'config_screening_type'
        managed = False

class ConfigScoreCard(models.Model):
    id = models.AutoField(primary_key=True)    
    score_card_name = models.CharField(max_length=255,blank=True)
    class Meta:
        db_table = 'config_score_card'
        managed = False
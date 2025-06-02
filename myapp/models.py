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
  

class JobRequisition(models.Model):
    RequisitionID = models.AutoField(primary_key=True)
    PositionTitle = models.CharField(max_length=191)
    No_of_positions = models.PositiveIntegerField(default=1)  # New field for number of positions
    HiringManagerID = models.IntegerField()
    recruiter = models.CharField(max_length=255,blank=True)
    STATUS_CHOICES = [
        ('Draft', 'Draft'),
        ('Pending Approval', 'Pending Approval'),
        ('Approved', 'Approved'),
        ('Posted', 'Posted'),
    ]
    Status = models.CharField(max_length=50, choices=STATUS_CHOICES, default='Draft')
    CreatedDate = models.DateTimeField(auto_now_add=True)
    class Meta:
        db_table = 'jobrequisition'
    def __str__(self):
        return self.PositionTitle


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
    
class JobRequisitionExtraDetails(models.Model):
    RequisitionID = models.ForeignKey(
        "JobRequisition", on_delete=models.CASCADE, db_column="RequisitionID"
    )
  # Foreign key to JobRequisition
    LegalEntity = models.CharField(max_length=255)
    PrimaryLocation = models.CharField(max_length=255)
    Geo_zone = models.CharField(max_length=255, blank=True, null=True)
    EmployeeGroup = models.CharField(max_length=255, blank=True, null=True)
    EmployeeSubGroup = models.CharField(max_length=255, blank=True, null=True)
    BussinessLine = models.CharField(max_length=255, blank=True, null=True)
    BussinessUnit = models.CharField(max_length=255, blank=True, null=True)
    Division = models.CharField(max_length=255, blank=True, null=True)
    Department = models.CharField(max_length=255, blank=True, null=True)
    RequisitionType = models.CharField(max_length=255)
    CareerLevel = models.CharField(max_length=255)
    Is_contract = models.BooleanField(default=False)
    Start_date = models.DateField()
    End_date = models.DateField(blank=True, null=True)
    Band = models.CharField(max_length=255, blank=True, null=True)
    SubBand = models.CharField(max_length=255, blank=True, null=True)
    Client_interview = models.BooleanField(default=False)
    Secondary_skill = models.CharField(max_length=255, blank=True, null=True)
    ModeOfWorking = models.CharField(max_length=255)
    Skills = models.TextField()

    class Meta:
        db_table = 'jobrequisitionextradetails'

    def __str__(self):
        return f"Extra Details for Requisition {self.RequisitionID}"


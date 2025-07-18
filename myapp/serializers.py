from datetime import datetime
from rest_framework import serializers
from .models import Approver, AssetDetails, Benefit, Candidate, CandidateInterviewStages, CandidateReference, CandidateReview, CandidateSubmission, Candidates, ConfigPositionRole, ConfigScoreCard, ConfigScreeningType, InterviewDesignParameters, InterviewDesignScreen, InterviewPlanner, OfferNegotiation, OfferNegotiationBenefit, RequisitionCompetency, RequisitionQuestion, StageAlertResponsibility,UserDetails
from .models import JobRequisition, RequisitionDetails, BillingDetails, PostingDetails, InterviewTeam, Teams
import logging
from .models import CommunicationSkills,InterviewRounds,HiringPlan
from django.core.exceptions import ObjectDoesNotExist
from .models import Interviewer, InterviewSlot

logger = logging.getLogger(__name__)
  
class HiringPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = HiringPlan
        fields = '__all__'

class HiringInterviewRoundsSerializer(serializers.ModelSerializer):
    class Meta:
        model = InterviewRounds
        fields = '__all__'

class HiringSkillsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunicationSkills
        fields = '__all__'



class JobRequisitionSerializerget(serializers.ModelSerializer):
    # RequisitionDetails (1:1)
    division = serializers.SerializerMethodField()
    department = serializers.SerializerMethodField()
    location = serializers.SerializerMethodField()
    internal_title = serializers.SerializerMethodField()
    external_title = serializers.SerializerMethodField()
    job_position = serializers.SerializerMethodField()
    business_line = serializers.SerializerMethodField()
    geo_zone = serializers.SerializerMethodField()
    primary_skills = serializers.SerializerMethodField()
    secondary_skills = serializers.SerializerMethodField()
    contract_start_date = serializers.SerializerMethodField()
    contract_end_date = serializers.SerializerMethodField()
    band = serializers.SerializerMethodField()
    sub_band = serializers.SerializerMethodField()
    career_level = serializers.SerializerMethodField()
    client_interview = serializers.SerializerMethodField()

    # HiringPlan (ForeignKey)
    tech_stacks = serializers.SerializerMethodField()
    designation = serializers.SerializerMethodField()
    experience_range = serializers.SerializerMethodField()
    target_companies = serializers.SerializerMethodField()
    compensation = serializers.SerializerMethodField()
    working_model = serializers.SerializerMethodField()
    visa_requirements = serializers.SerializerMethodField()
    notice_period = serializers.SerializerMethodField()
    requisition_date = serializers.SerializerMethodField()
    due_requisition_date = serializers.SerializerMethodField()

    class Meta:
        model = JobRequisition
        fields = [
            "RequisitionID", "PositionTitle", "Recruiter", "Status",
            "division", "department", "location",
            "internal_title", "external_title", "job_position",
            "business_line", "geo_zone", "primary_skills", "secondary_skills",
            "contract_start_date", "contract_end_date", "band", "sub_band",
            "career_level", "client_interview",
            "tech_stacks", "designation", "experience_range",
            "target_companies", "compensation", "working_model",
            "visa_requirements", "notice_period","requisition_date", "due_requisition_date"
        ]

    # RequisitionDetails methods
    def get_division(self, obj): return getattr(obj.position_information, "division", None)
    def get_department(self, obj): return getattr(obj.position_information, "department", None)
    def get_location(self, obj): return getattr(obj.position_information, "location", None)
    def get_internal_title(self, obj): return getattr(obj.position_information, "internal_title", None)
    def get_external_title(self, obj): return getattr(obj.position_information, "external_title", None)
    def get_job_position(self, obj): return getattr(obj.position_information, "job_position", None)
    def get_business_line(self, obj): return getattr(obj.position_information, "business_line", None)
    def get_geo_zone(self, obj): return getattr(obj.position_information, "geo_zone", None)
    def get_primary_skills(self, obj): return getattr(obj.position_information, "primary_skills", None)
    def get_secondary_skills(self, obj): return getattr(obj.position_information, "secondary_skills", None)
    def get_contract_start_date(self, obj):
        return obj.position_information.contract_start_date.isoformat() if getattr(obj, "position_information", None) and obj.position_information.contract_start_date else None
    def get_contract_end_date(self, obj):
        return obj.position_information.contract_end_date.isoformat() if getattr(obj, "position_information", None) and obj.position_information.contract_end_date else None
    def get_band(self, obj): return getattr(obj.position_information, "band", None)
    def get_sub_band(self, obj): return getattr(obj.position_information, "sub_band", None)
    def get_career_level(self, obj): return getattr(obj.position_information, "career_level", None)
    def get_client_interview(self, obj): return getattr(obj.position_information, "client_interview", None)

    # HiringPlan methods
    def get_tech_stacks(self, obj): return getattr(obj.Planning_id, "tech_stacks", None)
    def get_designation(self, obj): return getattr(obj.Planning_id, "designation", None)
    def get_experience_range(self, obj): return getattr(obj.Planning_id, "experience_range", None)
    def get_target_companies(self, obj): return getattr(obj.Planning_id, "target_companies", None)
    def get_compensation(self, obj): return getattr(obj.Planning_id, "compensation", None)
    def get_working_model(self, obj): return getattr(obj.Planning_id, "working_model", None)
    def get_visa_requirements(self, obj): return getattr(obj.Planning_id, "visa_requirements", None)
    def get_notice_period(self, obj): return getattr(obj.Planning_id, "notice_period", None)
    def get_requisition_date(self, obj):
        return obj.position_information.requisition_date.isoformat() if getattr(obj, "position_information", None) and obj.position_information.requisition_date else None
    def get_due_requisition_date(self, obj):
        return obj.position_information.due_requisition_date.isoformat() if getattr(obj, "position_information", None) and obj.position_information.due_requisition_date else None
    
class BillingDetailsSerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(
        queryset=JobRequisition.objects.all(), required=False
    )
    class Meta:
        model = BillingDetails
        fields = '__all__'

class PostingDetailsSerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(
        queryset=JobRequisition.objects.all(), required=False
    )
    internalDesc = serializers.CharField(source="internal_job_description", required=False)
    externalDesc = serializers.CharField(source="external_job_description", required=False)

    class Meta:
        model = PostingDetails
        fields = '__all__'

class InterviewTeamSerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(
        queryset=JobRequisition.objects.all(), required=False
    )
    class Meta:
        model = InterviewTeam
        fields = '__all__'

class TeamsSerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(
        queryset=JobRequisition.objects.all(), required=False
    )
    class Meta:
        model = Teams
        fields = '__all__'

class RequisitionDetailsSerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(
        queryset=JobRequisition.objects.all(), required=False
    )

    class Meta:
        model = RequisitionDetails
        fields = '__all__'

class AssetDetailsSerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(
        queryset=JobRequisition.objects.all(), required=False
    )

    class Meta:
        model = AssetDetails
        fields = '__all__'

class RequisitionQuestionSerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(queryset=JobRequisition.objects.all(), required=False)
    class Meta:
        model = RequisitionQuestion
        fields = '__all__'

class RequisitionCompetencySerializer(serializers.ModelSerializer):
    requisition = serializers.PrimaryKeyRelatedField(queryset=JobRequisition.objects.all(), required=False)
    class Meta:
        model = RequisitionCompetency
        fields = '__all__'
# class JobRequisitionSerializer(serializers.ModelSerializer):
#     details = HiringPlanSerializer(required=False)
#     # billing_details = BillingDetailsSerializer(required=False)
#     # posting_details = PostingDetailsSerializer(required=False)
#     # interview_team = InterviewTeamSerializer(many=True, required=False)
#     # teams = TeamsSerializer(many=True, required=False)

#     class Meta:
#         model = JobRequisition
#         fields = '__all__'

#     def create(self, validated_data):
#         """Insert JobRequisition first, then add related details"""
#         logger.info("Creating JobRequisition with data: %s", validated_data)
#         details_data = validated_data.pop('details', None)
#         planning_id = validated_data.get('Planning_id')
        
#         # billing_data = validated_data.pop('billing_details', None)
#         # posting_data = validated_data.pop('posting_details', None)
#         # interview_data = validated_data.pop('interview_team', [])
#         # teams_data = validated_data.pop('teams', [])
#         if not planning_id:
#             raise serializers.ValidationError({"error": "Planning_id is required"})

#         try:
#             hiring_plan = HiringPlan.objects.get(hiring_plan_id=planning_id)
#             print(hiring_plan.hiring_plan_id)
#         except HiringPlan.DoesNotExist:
#             raise serializers.ValidationError({"error": f"HiringPlan with ID {planning_id} not found"})


#         try:
#             # Step 1: Create JobRequisition
#             print(hiring_plan.hiring_plan_id)
#             validated_data['Planning_id'] = hiring_plan.hiring_plan_id
#             job_requisition = JobRequisition.objects.create(**validated_data)
#             logger.info("JobRequisition created with ID: %s", job_requisition.RequisitionID)

#             # job_requisition = JobRequisition.objects.create(**validated_data)

#             # Step 2: Assign requisition to related tables
#             if details_data and planning_id:
#                 try:
#                     for key, value in details_data.items():
#                         setattr(hiring_plan, key, value)  # Update fields dynamically
#                     hiring_plan.save()
#                     logger.info("HiringPlan updated for ID: %s", planning_id)
#                 except ObjectDoesNotExist:
#                     logger.warning("HiringPlan with ID %s not found", planning_id)


#             # if billing_data:
#             #     BillingDetails.objects.create(requisition=job_requisition, **billing_data)
#             #     logger.info("BillingDetails created for JobRequisition ID: %s", job_requisition.RequisitionID)
#             # if posting_data:
#             #     PostingDetails.objects.create(requisition=job_requisition, **posting_data)
#             #     logger.info("PostingDetails created for JobRequisition ID: %s", job_requisition.RequisitionID)
#             # for interviewer in interview_data:
#             #     InterviewTeam.objects.create(requisition=job_requisition, **interviewer)
#             #     logger.info("InterviewTeam added for JobRequisition ID: %s", job_requisition.RequisitionID)
#             # for team in teams_data:
#             #     Teams.objects.create(requisition=job_requisition, **team)
#                 # logger.info("Teams added for JobRequisition ID: %s", job_requisition.RequisitionID)

#             return job_requisition
#         except Exception as e:
#             logger.error("Error while creating JobRequisition: %s", str(e))
#             raise serializers.ValidationError({"error": str(e)})

class JobTemplateSerializer(serializers.Serializer):
    requisition_details = RequisitionDetailsSerializer()
    billing = BillingDetailsSerializer()
    posting = PostingDetailsSerializer()
    interviewers = InterviewTeamSerializer(many=True)
    functional_teams = TeamsSerializer(many=True)

class JobRequisitionCompactSerializer(serializers.ModelSerializer):
    job_template = serializers.SerializerMethodField()

    class Meta:
        model = JobRequisition
        fields = [ 'job_template']  # Removed 'RequisitionID'


    def get_job_template(self, obj):
        return JobTemplateSerializer({
            "requisition_details": getattr(obj, "position_information", None),
            "billing": getattr(obj, "billing_details", None),
            "posting": getattr(obj, "posting_details", None),
            "interviewers": obj.interview_team.all() if hasattr(obj, "interview_team") else [],
            "functional_teams": obj.teams.all() if hasattr(obj, "teams") else [],
        }).data

class JobRequisitionSerializer(serializers.ModelSerializer):
    RequisitionID = serializers.CharField(read_only=False, required=False)
    Planning_id = serializers.SlugRelatedField(
        slug_field='hiring_plan_id',
        queryset=HiringPlan.objects.all(),
        required=False,
        allow_null=True

    )

    position_information = RequisitionDetailsSerializer(required=False)
    billing_details = BillingDetailsSerializer(required=False)
    posting_details = PostingDetailsSerializer(required=False)
    asset_details = AssetDetailsSerializer(required=False)
    requisition_questions = RequisitionQuestionSerializer(many=True, read_only=True)
    requisition_competencies = RequisitionCompetencySerializer(many=True, read_only=True)


    class Meta:
        model = JobRequisition
        fields = '__all__'

    def create(self, validated_data):
        # Generate new RequisitionID
        last_requisition = JobRequisition.objects.order_by('-id').first()
        new_requisition_id = (
            f"RQ{int(last_requisition.RequisitionID.replace('RQ', '')) + 1:04d}"
            if last_requisition and last_requisition.RequisitionID.startswith("RQ")
            else "RQ0001"
        )
        validated_data["RequisitionID"] = new_requisition_id

        # Extract nested blocks
        details_data = validated_data.pop("position_information", None)
        billing_data = validated_data.pop("billing_details", None)
        asset_data = self.initial_data.get("asset_details") or self.initial_data.get("asset_deatils", {})
        validated_data.pop("posting_details", None)

        # ✅ Get posting_details block
        posting_block = dict(self.initial_data.get("posting_details", {}))

        # Extract question & competency lists
        questions_data = posting_block.get("questions", [])
        competencies_data = posting_block.get("competencies") or posting_block.get("Competencies", [])

        # Normalize competency fields
        def normalize_competency_keys(raw):
            return {
                "competency": raw.get("Competency") or raw.get("competency"),
                "library": raw.get("Library") or raw.get("library"),
                "category": raw.get("Category") or raw.get("category"),
                "expected_rating": raw.get("ExpectedRating") or raw.get("expected_rating"),
                "weight": raw.get("Weight") or raw.get("weight")
            }

        job_requisition = JobRequisition.objects.create(**validated_data)

        if details_data:
            skills_block = self.initial_data.get("skills_required", {})
            primary = skills_block.get("primary_skills", [])
            secondary = skills_block.get("secondary_skills", [])

            details_data["primary_skills"] = ", ".join(primary) if isinstance(primary, list) else str(primary)
            details_data["secondary_skills"] = ", ".join(secondary) if isinstance(secondary, list) else str(secondary)
            last_client = RequisitionDetails.objects.order_by('-id').first()
            if details_data.get("company_client_name"):
                last_client = RequisitionDetails.objects.exclude(client_id__isnull=True).order_by('-id').first()
                new_client_id = (
                    f"CL{int(str(last_client.client_id).replace('CL', '')) + 1:04d}"
                    if last_client and str(last_client.client_id).startswith("CL") and str(last_client.client_id).replace("CL", "").isdigit()
                    else "CL0001"
                )
                details_data["client_id"] = new_client_id
            else:
                details_data["client_id"] = None 


            RequisitionDetails.objects.create(requisition=job_requisition, **details_data)
        if billing_data:
            BillingDetails.objects.create(requisition=job_requisition, **billing_data)
        if posting_block:

            PostingDetails.objects.create(
                requisition=job_requisition,
                experience=posting_block.get("experience"),
                designation=posting_block.get("designation"),
                job_category=posting_block.get("job_category"),
                job_region=posting_block.get("job_region"),
                qualification=posting_block.get("qualification"),
                internal_job_description=posting_block.get("internalDesc", ""),
                external_job_description=posting_block.get("externalDesc", "")
            )


        if asset_data:
            AssetDetails.objects.create(requisition=job_requisition, **asset_data)

        # ✅ Insert each question
        for q in questions_data:
            question_obj = {
                "question": q.get("Question") or q.get("question"),
                "required": q.get("Required") or q.get("required"),
                "disqualifier": q.get("Disqualifier") or q.get("disqualifier"),
                "score": q.get("Score") or q.get("score"),
                "weight": q.get("Weight") or q.get("weight")
            }
            RequisitionQuestion.objects.create(requisition=job_requisition, **question_obj)

        # ✅ Insert each competency
        for c in competencies_data:
            RequisitionCompetency.objects.create(requisition=job_requisition, **normalize_competency_keys(c))

        return job_requisition



    def update(self, instance, validated_data):
        # 🔧 Extract nested blocks
        details_data = validated_data.pop("position_information", None)
        billing_data = validated_data.pop("billing_details", None)
        asset_data = validated_data.pop("asset_details", None)
        validated_data.pop("posting_details", None)

        posting_block = dict(self.initial_data.get("posting_details", {}))

        # 🧠 Normalize lists → strings
        def to_string(value):
            return ", ".join(value) if isinstance(value, list) else value

        posting_fields = {
            "experience": to_string(posting_block.get("experience")),
            "designation": to_string(posting_block.get("designation")),
            "job_category": posting_block.get("job_category"),
            "job_region": to_string(posting_block.get("job_region")),
            "qualification": to_string(posting_block.get("qualification")),
            "internal_job_description": posting_block.get("internalDesc", ""),
            "external_job_description": posting_block.get("externalDesc", "")
        }

        # 🧩 Normalize skills
        skills_block = self.initial_data.get("skills_required", {})
        if details_data:
            details_data["primary_skills"] = to_string(skills_block.get("primary_skills"))
            details_data["secondary_skills"] = to_string(skills_block.get("secondary_skills"))

        # 🧩 Normalize questions & competencies
        def normalize_list(raw, lowercase_keys=True):
            if isinstance(raw, dict): raw = [raw]
            items = []
            for entry in raw or []:
                entry = {k.lower(): v for k, v in entry.items()} if lowercase_keys else entry
                entry.pop("actions", None)
                entry.pop("isnew", None)
                entry.pop("id", None)
                items.append(entry)
            return items

        def normalize_competency_keys(raw):
            return {
                "competency": raw.get("Competency") or raw.get("competency"),
                "library": raw.get("Library") or raw.get("library"),
                "category": raw.get("Category") or raw.get("category"),
                "expected_rating": raw.get("ExpectedRating") or raw.get("expected_rating") or "Not Rated",
                "weight": raw.get("Weight") or raw.get("weight"),
            }

        questions_data = normalize_list(posting_block.get("questions", []))
        competencies_raw = normalize_list(posting_block.get("competencies", []) or posting_block.get("Competencies", []))
        competencies_data = [normalize_competency_keys(c) for c in competencies_raw]

        interview_data = posting_block.get("interview_teammate") or posting_block.get("interview_team", [])
        teams_data = posting_block.get("teams", [])

        # 🧱 Update main model fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        # 👤 Update one-to-one blocks
        if details_data:
            if hasattr(instance, "position_information"):
                for attr, value in details_data.items():
                    setattr(instance.position_information, attr, value)
                instance.position_information.save()
            else:
                RequisitionDetails.objects.create(requisition=instance, **details_data)

        if billing_data:
            if hasattr(instance, "billing_details"):
                for attr, value in billing_data.items():
                    setattr(instance.billing_details, attr, value)
                instance.billing_details.save()
            else:
                BillingDetails.objects.create(requisition=instance, **billing_data)

        if posting_fields:
            if hasattr(instance, "posting_details"):
                for attr, value in posting_fields.items():
                    setattr(instance.posting_details, attr, value)
                instance.posting_details.save()
            else:
                PostingDetails.objects.create(requisition=instance, **posting_fields)

        if asset_data:
            if hasattr(instance, "asset_details"):
                for attr, value in asset_data.items():
                    setattr(instance.asset_details, attr, value)
                instance.asset_details.save()
            else:
                AssetDetails.objects.create(requisition=instance, **asset_data)

        # 🔄 Refresh related tables
        instance.requisition_questions.all().delete()
        for q in questions_data:
            RequisitionQuestion.objects.create(requisition=instance, **q)

        instance.requisition_competencies.all().delete()
        for c in competencies_data:
            RequisitionCompetency.objects.create(requisition=instance, **c)

        instance.interview_team.all().delete()
        for i in interview_data:
            InterviewTeam.objects.create(requisition=instance, **i)

        instance.teams.all().delete()
        for t in teams_data:
            Teams.objects.create(requisition=instance, **t)

        return instance

    # def to_representation(self, instance):
    #     representation = super().to_representation(instance)
    #     representation['Planning_id'] = instance.Planning_id.hiring_plan_id  # ✅ Convert to integer
    #     return representation

class CandidateReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = CandidateReview
        fields = [
            "ParameterDefined",
            "Guidelines",
            "MinimumQuestions",
            "ActualRating",
            "Feedback"
        ]

class InterviewSlotSerializer(serializers.ModelSerializer):
    class Meta:
        model = InterviewSlot
        fields = ['id', 'date', 'start_time', 'end_time']

class InterviewerSerializer(serializers.ModelSerializer):
    slots = InterviewSlotSerializer(many=True)

    class Meta:
        model = Interviewer
        fields = '__all__'

    def create(self, validated_data):
        slot_data = validated_data.pop('slots', [])
        interviewer = Interviewer.objects.create(**validated_data)
        for slot in slot_data:
            InterviewSlot.objects.create(interviewer=interviewer, **slot)
        return interviewer

class CandidateInterviewStagesSerializer(serializers.ModelSerializer):
    class Meta:
        model = CandidateInterviewStages
        fields = '__all__'

class CandidateDetailWithInterviewSerializer(serializers.ModelSerializer):
    # interview_stages = serializers.SerializerMethodField()
    Req_ID = serializers.SerializerMethodField()
    Candidate_Id = serializers.SerializerMethodField()
    Candidate_First_Name = serializers.SerializerMethodField()
    Candidate_Last_Name = serializers.SerializerMethodField()
    Applied_Position = serializers.SerializerMethodField()
    Time_in_Stage = serializers.SerializerMethodField()
    JD_From_applied_Position = serializers.SerializerMethodField()
    CV_Resume = serializers.SerializerMethodField()
    Cover_Letter = serializers.SerializerMethodField()
    Candidate_current_stage = serializers.SerializerMethodField()
    Candidate_Next_Stage = serializers.SerializerMethodField()
    Overall_Stage = serializers.SerializerMethodField()
    Final_stage = serializers.SerializerMethodField()
    Source = serializers.SerializerMethodField()
    Score = serializers.SerializerMethodField()
    Phone_no = serializers.SerializerMethodField()
    Status = serializers.SerializerMethodField()


    class Meta:
        model = Candidate
        fields = [
            "Req_ID", "Candidate_Id", "Candidate_First_Name","Candidate_Last_Name", "Applied_Position", "Time_in_Stage",
            "JD_From_applied_Position", "CV_Resume", "Cover_Letter", "Candidate_current_stage",
            "Candidate_Next_Stage", "Overall_Stage", "Final_stage", "Source","Score","Phone_no","Status"
        ]

    # def get_interview_stages(self, obj):
    #     stages = CandidateInterviewStages.objects.filter(candidate_id=obj.CandidateID)
    #     return CandidateInterviewStagesSerializer(stages, many=True).data
    def get_Status(self, obj):
        """
        Return the `status` of the most recent interview stage,
        or "N/A" if none exists.
        """
        last_stage = (
            CandidateInterviewStages.objects
            .filter(candidate_id=obj.CandidateID)
            .order_by('-interview_date')
            .first()
        )
        return last_stage.status if last_stage and last_stage.status else "N/A"

    def get_Req_ID(self, obj):
        return obj.Req_id_fk.RequisitionID if obj.Req_id_fk else "N/A"

    def get_Candidate_Id(self, obj):
        return obj.CandidateID or "N/A"

    def get_Candidate_First_Name(self, obj):
        return obj.candidate_first_name or "N/A"
    
    def get_Candidate_Last_Name(self, obj):
        return obj.candidate_last_name or "N/A"


    def get_Applied_Position(self, obj):
        details = getattr(obj.Req_id_fk, "position_information", None)
        return details.job_position if details and details.job_position else "N/A"

    def get_JD_From_applied_Position(self, obj):
        posting = getattr(obj.Req_id_fk, "posting_details", None)
        return posting.internal_job_description if posting and posting.internal_job_description else "N/A"

    def get_CV_Resume(self, obj):
        return obj.Resume or "N/A"

    def get_Candidate_current_stage(self, obj):
        stage = CandidateInterviewStages.objects.filter(candidate_id=obj.CandidateID).order_by('-interview_date').first()
        return stage.interview_stage if stage and stage.interview_stage else "N/A"

    def get_Candidate_Next_Stage(self, obj):
        # Business logic placeholder: adjust how you determine next stage
        return "N/A"

    def get_Time_in_Stage(self, obj):
        stage = CandidateInterviewStages.objects.filter(candidate_id=obj.CandidateID).order_by('-interview_date').first()
        if stage and stage.interview_date:
            delta = datetime.now().date() - stage.interview_date
            return f"{delta.days} days"
        return "N/A"

    def get_Overall_Stage(self, obj):
        return obj.Result or "N/A"

    def get_Final_stage(self, obj):
        return obj.Final_rating if obj.Final_rating is not None else "N/A"

    def get_Cover_Letter(self, obj):
        return obj.CoverLetter or "N/A"

    def get_Source(self, obj):
        return obj.Source or "N/A"
    
    def get_Score(self, obj):
        return obj.Score or "N/A"
    
    def get_Phone_no(self, obj):
        return obj.Phone_no or "N/A"


    
class CandidateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Candidates
        fields = ['CandidateID', 'Name', 'Email']

class JobRequisitionDetailSerializer(serializers.ModelSerializer):
    candidates = CandidateSerializer(many=True)
    interviewer = InterviewerSerializer(many=True)

    class Meta:
        model = JobRequisition
        fields = ['RequisitionID', 'PositionTitle', 'candidates', 'interviewer']

class InterviewDesignScreenSerializer(serializers.ModelSerializer):
    class Meta:
        model = InterviewDesignScreen
        fields = '__all__'

class InterviewDesignParametersSerializer(serializers.ModelSerializer):
    class Meta:
        model = InterviewDesignParameters
        fields = '__all__'

class StageAlertResponsibilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = StageAlertResponsibility
        fields = '__all__'




class OfferNegotiationBenefitSerializer(serializers.ModelSerializer):
    benefit_name = serializers.CharField(source='benefit.name', read_only=True)

    class Meta:
        model = OfferNegotiationBenefit
        fields = ['id', 'benefit', 'benefit_name']


class OfferNegotiationSerializer(serializers.ModelSerializer):
    requisition = serializers.SlugRelatedField(
        slug_field='RequisitionID',  # refers to the unique string like "RQ0001"
        queryset=JobRequisition.objects.all()
    )

    benefits = serializers.ListField(child=serializers.CharField(), write_only=True, required=False)
    benefit_details = OfferNegotiationBenefitSerializer(source='offer_benefits', many=True, read_only=True)

    class Meta:
        model = OfferNegotiation
        fields = '__all__'

    def create(self, validated_data):
        benefits = validated_data.pop('benefits', [])
        offer = OfferNegotiation.objects.create(**validated_data)
        for name in benefits:
            benefit_obj, _ = Benefit.objects.get_or_create(name=name)
            OfferNegotiationBenefit.objects.create(offer_negotiation=offer, benefit=benefit_obj)
        return offer

    def update(self, instance, validated_data):
        benefits = validated_data.pop('benefits', None)

        # Update basic fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        # Optional: update benefits if included in payload
        if benefits is not None:
            instance.benefits.clear()
            for name in benefits:
                benefit_obj, _ = Benefit.objects.get_or_create(name=name)
                OfferNegotiationBenefit.objects.create(offer_negotiation=instance, benefit=benefit_obj)

        return instance
    
class ApproverSerializer(serializers.ModelSerializer):
    class Meta:
        model = Approver
        fields = '__all__'

class CandidateApprovalStatusSerializer(serializers.Serializer):
    req_id = serializers.CharField()
    client_id = serializers.CharField()
    client_name = serializers.CharField()
    candidate_id = serializers.CharField()
    candidate_first_name = serializers.CharField()
    candidate_last_name = serializers.CharField()
    hm_approver_status = serializers.CharField()
    fpna_approver_status = serializers.CharField()
    overall_status = serializers.CharField()


class CandidateReferenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = CandidateReference
        exclude = ['candidate_submission']


class CandidateSubmissionSerializer(serializers.ModelSerializer):
    references = CandidateReferenceSerializer(many=True)
    
    class Meta:
        model = CandidateSubmission
        fields = '__all__'

    def create(self, validated_data):
        references_data = validated_data.pop('references', [])
        candidate_submission = CandidateSubmission.objects.create(**validated_data)
        for ref in references_data:
            CandidateReference.objects.create(candidate_submission=candidate_submission, **ref)
        return candidate_submission
    

class ConfigPositionRoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfigPositionRole
        fields = '__all__'

class ConfigScreeningTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfigScreeningType
        fields = '__all__'

class ConfigScoreCardSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfigScoreCard
        fields = '__all__'


class InterviewPlannerSerializer(serializers.ModelSerializer):
    class Meta:
        model = InterviewPlanner
        fields = '__all__'
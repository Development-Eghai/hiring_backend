from datetime import datetime
from rest_framework import serializers
from .models import Approver, AssetDetails, Benefit, BgCheckRequest, BgPackage, BgVendor, Candidate, CandidateInterviewStages, CandidateReference, CandidateReview, CandidateSubmission, Candidates, ConfigHiringData, ConfigPositionRole, ConfigScoreCard, ConfigScreeningType, InterviewDesignParameters, InterviewDesignScreen, InterviewPlanner, InterviewReview, OfferNegotiation, OfferNegotiationBenefit, RequisitionCompetency, RequisitionQuestion, StageAlertResponsibility,UserDetails
from .models import JobRequisition, RequisitionDetails, BillingDetails, PostingDetails, InterviewTeam, Teams
import logging
from .models import CommunicationSkills,InterviewRounds,HiringPlan
from django.core.exceptions import ObjectDoesNotExist
from .models import Interviewer, InterviewSlot
from django.db.models.functions import Substr, Cast
from django.db.models import Max, IntegerField
from django.core.mail import send_mail

logger = logging.getLogger(__name__)


class HiringPlanSerializer(serializers.ModelSerializer):
    # Explicitly declare sensitive or edge-prone fields
    compensation_range = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    designation = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    experience_range = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    target_companies = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    location = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    job_type = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    role_type = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    shift_timings = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    education_qualification = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    tech_stacks = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    bg_verification_type = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    jd_details = serializers.CharField(
    allow_blank=True, allow_null=True, required=False
    )
    visa_requirements = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    background_verification = serializers.CharField(allow_blank=True, allow_null=True, required=False)
    social_media_data = serializers.JSONField(required=False)


    class Meta:
        model = HiringPlan
        fields = '__all__'

    def to_internal_value(self, data):
        remap_fields = {
            "visa_required": "visa_requirements",
            "background_verfication": "background_verification",
            "has_domain": "domain_yn",
            "social_media_links":"social_media_data"
        }

        for source_key, target_key in remap_fields.items():
            if source_key in data and isinstance(data[source_key], str):
                data[target_key] = data[source_key]

        def flatten_list(key):
            raw = data.get(key, [])
            return ", ".join([
                item.get("value") for item in raw
                if isinstance(item, dict) and item.get("value")
            ]) if isinstance(raw, list) else ""

        def flatten_single(key, fallback=None):
            val = data.get(key)
            return val[0].get("value", fallback) if isinstance(val, list) and val else fallback

        data = data.copy()

        # Multi-select fields (comma-separated strings)
        for field in ["tech_stacks", "target_companies", "bg_verification_type"]:
            val = flatten_list(field)
            if val:
                data[field] = val

        # Single-select flattening (label-value)
        flatten_map = {
            "designation": "designation",
            "education_qualification": "education_qualification",
            "shift_timings": "shift_timings",
            "location": "location",
            "job_type": "job_type",
            "role_type": "role_type",
            "experience_range": "experience_range",
            "compensation_range": "compensation_range"
        }
        for source, target in flatten_map.items():
            val = flatten_single(source)
            if val is not None:
                data[target] = val

        # Working model remap
        data["working_model"] = flatten_single("working_modal")

        # Communication language + proficiency
        cl = data.get("communication_language")
        if isinstance(cl, list) and cl and isinstance(cl[0], dict):
            data["communication_language"] = cl[0].get("language", "")
            data["language_proficiency"] = cl[0].get("proficiency", "")
        elif isinstance(cl, str):
            data["communication_language"] = cl

        # Social media data
        sm = data.get("social_media_data")
        if isinstance(sm, list) and sm and isinstance(sm[0], dict):
            media = sm[0]
            data["social_media_links"] = f"{media.get('media_type', '')}: {media.get('media_link', '')}"

        # Auto-generate job_position if missing
        if not data.get("job_position"):
            role = flatten_single("job_role", "")
            designation = flatten_single("designation", "")
            data["job_position"] = f"{designation} - {role}".strip(" -")

        # Passthrough for raw fields
        passthrough_fields = [
            "jd_details", "compensation", "interview_status", "mode_of_working",
            "education_decision", "domain_knowledge", "domain_yn", "domain_name",
            "visa_requirements", "visa_country", "visa_type", "background_verification",
            "social_media_link", "github_link", "notice_period", "additional_comp",
            "requisition_template", "screening_questions"
        ]
        

        for key in passthrough_fields:
            val = data.get(key)
            if isinstance(val, dict) and "value" in val:
                data[key] = str(val["value"])
            elif isinstance(val, (str, int, float)):
                data[key] = str(val)

        print("🧪 visa_requirements:", data.get("visa_requirements"))
        print("🧪 background_verification:", data.get("background_verification"))


        return super().to_internal_value(data)

    def validate(self, attrs):
        errors = {}

        # Multi-select validations
        for field in ["tech_stacks", "target_companies", "bg_verification_type"]:
            if field in attrs and not isinstance(attrs[field], str):
                errors[field] = "Must be a comma-separated string."

        # Numeric validation
        try:
            if attrs.get("relocation_amount"):
                float(attrs["relocation_amount"])
        except ValueError:
            errors["relocation_amount"] = "Relocation amount must be a number."

        # Optional: Compensation type enforcement
        if "compensation_range" in attrs and not isinstance(attrs["compensation_range"], str):
            errors["compensation_range"] = "Must be a string."

        if errors:
            raise serializers.ValidationError(errors)

        return attrs




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
        return obj.requisition_date.isoformat() if obj.requisition_date else None

    def get_due_requisition_date(self, obj):
        return obj.due_requisition_date.isoformat() if obj.due_requisition_date else None

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
    requisition_type = serializers.CharField(required=False, allow_blank=True)
    date_of_requisition = serializers.DateField(required=False, allow_null=True)
    due_date_of_requisition = serializers.DateField(required=False, allow_null=True)

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
    class CustomSlugField(serializers.SlugRelatedField):
        def to_internal_value(self, data):
            if data == "Not Provided":
                return None
            return super().to_internal_value(data)

    # Use it in your serializer
    Planning_id = CustomSlugField(
        slug_field='hiring_plan_id',
        queryset=HiringPlan.objects.all(),
        required=False,
        allow_null=True
    )


    client_id = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    requisition_date = serializers.DateField(required=False)
    due_requisition_date = serializers.DateField(required=False)

    position_information = RequisitionDetailsSerializer(required=False)
    billing_details = BillingDetailsSerializer(required=False)
    # posting_details = PostingDetailsSerializer(required=False)
    asset_details = AssetDetailsSerializer(required=False)

    class Meta:
        model = JobRequisition
        fields = '__all__'

    def create(self, validated_data):
        # 🔢 Generate RequisitionID
        max_id = JobRequisition.objects.annotate(
            num=Cast(Substr("RequisitionID", 3), IntegerField())
        ).aggregate(max_id=Max("num"))["max_id"]
        validated_data["RequisitionID"] = f"RQ{(max_id or 0) + 1:04d}"

        # 🔐 Assign Planning_id if missing
        user_role = self.initial_data.get("user_role")
        if not validated_data.get("Planning_id") and str(user_role) == "1":
            validated_data["Planning_id"] = HiringPlan.objects.filter(hiring_plan_id="PL0001").first()

        # ✅ Optional: Handle start/end dates & template if your model has those fields
        validated_data["company_client_name"] = self.initial_data.get("client_name", "")
        validated_data["requisition_date"] = self.initial_data.get("requisition_date")
        validated_data["due_requisition_date"] = self.initial_data.get("due_requisition_date")
        validated_data["template"] = self.initial_data.get("template", "")
        validated_data["No_of_positions"] = self.initial_data.get("no_of_openings", 1)

        # 🔧 Optional: If company_client_name is present and you want to generate a client_id
        company_client_name = validated_data.get("company_client_name")
        if company_client_name:
            last = JobRequisition.objects.exclude(client_id__isnull=True).order_by("-id").first()
            if last and str(last.client_id).startswith("CL") and str(last.client_id).replace("CL", "").isdigit():
                next_client_id = f"CL{int(str(last.client_id).replace('CL', '')) + 1:04d}"
            else:
                next_client_id = "CL0001"
            validated_data["client_id"] = next_client_id
        else:
            validated_data["client_id"] = None
        
        validated_data.pop("template", None)

        # ✅ Create JobRequisition with cleaned data
        job_req = JobRequisition.objects.create(**validated_data)
        return job_req


    def update(self, instance, validated_data):
        planning_raw = self.initial_data.get("Planning_id")
        if planning_raw == "Not Provided":
            validated_data["Planning_id"] = None  # or you can do validated_data.pop("Planning_id", None)

        details_data = validated_data.pop("position_information", {})
        billing_data = validated_data.pop("billing_details", {})
        asset_data = validated_data.pop("asset_details", {})
        posting_data = self.initial_data.get("posting_details", {})
        skills_data = self.initial_data.get("skills_required", {})

        # 🌐 Update top-level fields safely
        instance.company_client_name = details_data.get("company_client_name") or instance.company_client_name
        instance.PositionTitle = validated_data.get("PositionTitle", instance.PositionTitle)
        instance.requisition_date = details_data.get("date_of_requisition") 
        instance.due_requisition_date = details_data.get("due_date_of_requisition")
        if instance.Status == "Incomplete form":
            instance.Status = "Pending Approval"
            login_url = "https://hiring.pixeladvant.com/"
            # requisition_url = f"https://yourdomain.com/requisitions/{instance.RequisitionID}/details/"  # Adjust URL pattern to match your routing

            # Email content with login and requisition details
            email_body = f"""
            Hi Team,

            Your Job Requisition '{instance.RequisitionID}' has been submitted for approval.

            📅 Date of Requisition: {instance.requisition_date}
            📌 Position Title: {instance.PositionTitle}
            👥 No. of Positions: {instance.No_of_positions}

            To view or manage your requisition:
            🔗 Login here: {login_url}

            Regards,
            Hiring Team
            """

            send_mail(
                subject=f"Requisition '{instance.RequisitionID}' - Pending Approval",
                message=email_body,
                from_email='hiring@pixeladvant.com',
                recipient_list=['anand040593@gmail.com'],
                fail_silently=False,
            )


        for attr, val in validated_data.items():
            setattr(instance, attr, val)
        instance.save()

        # 💾 RequisitionDetails
        if details_data:
            details_data.pop("date_of_requisition", None)
            details_data.pop("due_date_of_requisition", None)
            details_data["primary_skills"] = ", ".join(skills_data.get("primary_skills", []))
            details_data["secondary_skills"] = ", ".join(skills_data.get("secondary_skills", []))
            if getattr(instance, "position_information", None):
                for attr, val in details_data.items():
                    setattr(instance.position_information, attr, val)
                instance.position_information.save()
            else:
                RequisitionDetails.objects.create(requisition=instance, **details_data)

        # 💾 BillingDetails
        if billing_data:
            if getattr(instance, "billing_details", None):
                for attr, val in billing_data.items():
                    setattr(instance.billing_details, attr, val)
                instance.billing_details.save()
            else:
                BillingDetails.objects.create(requisition=instance, **billing_data)

        # 💾 PostingDetails
        def to_string(val): return ", ".join(val) if isinstance(val, list) else val or ""
        posting_payload = {
            "experience": to_string(posting_data.get("experience")),
            "designation": to_string(posting_data.get("designation")),
            "job_category": posting_data.get("job_category", ""),
            "job_region": to_string(posting_data.get("job_region")),
            "qualification": to_string(posting_data.get("qualification")),
            "internal_job_description": posting_data.get("internalDesc", ""),
            "external_job_description": posting_data.get("externalDesc", "")
        }
        if posting_payload:
            if getattr(instance, "posting_details", None):
                for attr, val in posting_payload.items():
                    setattr(instance.posting_details, attr, val)
                instance.posting_details.save()
            else:
                PostingDetails.objects.create(requisition=instance, **posting_payload)



        # 💾 AssetDetails
        if asset_data:
            if getattr(instance, "asset_details", None):
                for attr, val in asset_data.items():
                    setattr(instance.asset_details, attr, val)
                instance.asset_details.save()
            else:
                AssetDetails.objects.create(requisition=instance, **asset_data)

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
    client_id = serializers.SerializerMethodField()
    client_name = serializers.SerializerMethodField()
    # contact_number = serializers.CharField(allow_blank=True, allow_null=True)



    class Meta:
        model = Interviewer
        fields = '__all__'

    def get_client_id(self, obj):
        job_req = JobRequisition.objects.filter(interviewer=obj).first()
        return job_req.client_id if job_req else None

    def get_client_name(self, obj):
        job_req = JobRequisition.objects.filter(interviewer=obj).first()
        return job_req.company_client_name if job_req else None

    def create(self, validated_data):
        slot_data = validated_data.pop('slots', [])
        interviewer = Interviewer.objects.create(**validated_data)
        for slot in slot_data:
            InterviewSlot.objects.create(interviewer=interviewer, **slot)
        return interviewer
    
    def update(self, instance, validated_data):
        slots_data = validated_data.pop("slots", None)

        # Update interviewer fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        if slots_data is not None:
            # Clear existing slots and re-create new ones (optional strategy)
            instance.slots.all().delete()
            for slot in slots_data:
                InterviewSlot.objects.create(interviewer=instance, **slot)

        return instance


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
        latest_stage = (
            CandidateInterviewStages.objects
            .filter(candidate_id=obj.CandidateID)
            .order_by('-interview_date')
            .first()
        )

        # Show current stage as final stage if status is Completed
        if latest_stage and latest_stage.status.lower() == "completed":
            return latest_stage.interview_stage

        return latest_stage.interview_stage if latest_stage else "N/A"


    def get_Candidate_Next_Stage(self, obj):
        latest_stage = (
            CandidateInterviewStages.objects
            .filter(candidate_id=obj.CandidateID)
            .order_by('-interview_date')
            .first()
        )

        # If status is Completed, candidate journey is finished
        if latest_stage and latest_stage.status.lower() == "completed":
            return "N/A"

        # Find next stage if interview not yet completed
        today = datetime.now().date()
        next_stage = (
            CandidateInterviewStages.objects
            .filter(candidate_id=obj.CandidateID, interview_date__gt=today)
            .order_by('interview_date')
            .first()
        )

        return next_stage.interview_stage if next_stage else "N/A"



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
        model = Candidate
        fields = '__all__'

class JobRequisitionDetailSerializer(serializers.ModelSerializer):
    candidates = CandidateSerializer(many=True)
    interviewer = InterviewerSerializer(many=True)

    class Meta:
        model = JobRequisition
        fields = ['RequisitionID', 'PositionTitle', 'candidates', 'interviewer']

# class InterviewDesignScreenSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = InterviewDesignScreen
#         fields = '__all__'

# class InterviewDesignParametersSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = InterviewDesignParameters
#         fields = '__all__'

class InterviewDesignParametersSerializer(serializers.ModelSerializer):
    score_card_name = serializers.CharField(source='score_card')
    
    class Meta:
        model = InterviewDesignParameters
        fields = [
            'score_card_name','interview_design_id', 'options', 'guideline', 'min_questions',
            'screen_type', 'duration', 'Weightage', 'mode',
            'feedback'
        ]

class InterviewDesignScreenSerializer(serializers.ModelSerializer):
    plan_id = serializers.CharField(source='hiring_plan_id', allow_blank=True, required=False)
    params = serializers.SerializerMethodField()


    class Meta:
        model = InterviewDesignScreen
        fields = [
            'plan_id', 'req_id','interview_design_id', 'tech_stacks', 'screening_type',
            'no_of_interview_round', 'final_rating', 'status',
            'feedback', 'params'
        ]

    def get_params(self, obj):
        param_qs = InterviewDesignParameters.objects.filter(interview_design_id=obj.interview_design_id)
        return InterviewDesignParametersSerializer(param_qs, many=True).data


class StageAlertResponsibilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = StageAlertResponsibility
        fields = '__all__'

class InterviewReviewSerializer(serializers.ModelSerializer):
    feedback = serializers.SerializerMethodField()
    result = serializers.SerializerMethodField()

    class Meta:
        model = InterviewReview
        fields = '__all__'  # Keeps your structure intact

    def get_feedback(self, obj):
        print(f"Looking for stage: CandidateID={obj.candidate_id}, Stage={obj.ParameterDefined.strip()}")
        stage = CandidateInterviewStages.objects.filter(
            candidate_id=obj.candidate_id,
            interview_stage__iexact=obj.ParameterDefined.strip()
        ).first()
        return stage.feedback if stage else ""

    def get_result(self, obj):
        stage = CandidateInterviewStages.objects.filter(
            candidate_id=obj.candidate_id,
            interview_stage__iexact=obj.ParameterDefined.strip()
        ).first()
        return stage.result if stage else ""




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
        instance.negotiation_status = "Successful"
        instance.save()

        # Optional: update benefits if included in payload
        if benefits is not None:
            instance.benefits.clear()
            for name in benefits:
                benefit_obj, _ = Benefit.objects.get_or_create(name=name)
                OfferNegotiationBenefit.objects.create(offer_negotiation=instance, benefit=benefit_obj)

        return instance
    
class ApproverSerializer(serializers.ModelSerializer):
    def to_internal_value(self, data):
        if 'role' in data:
            role_map = {v: k for k, v in Approver.ROLE_CHOICES}
            data['role'] = role_map.get(data['role'], data['role'])
        return super().to_internal_value(data)
    class Meta:
        model = Approver
        fields = '__all__'


class ApproverDetailSerializer(serializers.Serializer):
    req_id = serializers.CharField()
    client_id = serializers.CharField(allow_blank=True)
    client_name = serializers.CharField()
    role = serializers.CharField()
    name = serializers.CharField()
    email = serializers.EmailField()
    contact_number = serializers.CharField()
    job_title = serializers.CharField()
    status = serializers.CharField()
    decision = serializers.CharField()
    comment = serializers.CharField()
    # reviewed_at = serializers.CharField()
    candidate_id = serializers.CharField()
    candidate_first_name = serializers.CharField()
    candidate_last_name = serializers.CharField()
    screening_status = serializers.CharField()
    # recruiter_name = serializers.CharField()



class CandidateApprovalStatusSerializer(serializers.Serializer):
    req_id = serializers.CharField()
    client_id = serializers.CharField()
    client_name = serializers.CharField()
    approvers = ApproverDetailSerializer(many=True)
    # req_id = serializers.CharField()
    # client_id = serializers.CharField(allow_blank=True)
    # client_name = serializers.CharField()
    # candidate_id = serializers.CharField()
    # candidate_first_name = serializers.CharField()
    # candidate_last_name = serializers.CharField()
    # overall_status = serializers.CharField()
    # approval_statuses = serializers.DictField(child=serializers.CharField(), required=False)
    # no_of_approvers = serializers.IntegerField()
    # approvers = serializers.ListField(child=serializers.DictField(), required=False)



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

class ConfigHiringDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfigHiringData
        fields = '__all__'


class InterviewPlannerSerializer(serializers.ModelSerializer):
    hiring_plan_id = serializers.CharField(required=False, allow_null=True, allow_blank=True)
    class Meta:
        model = InterviewPlanner
        fields = '__all__'

class BgVendorSerializer(serializers.ModelSerializer):
    class Meta:
        model = BgVendor
        fields = ["id", "name", "contact_email", "created_at"]


class BgPackageSerializer(serializers.ModelSerializer):
    vendor = BgVendorSerializer(read_only=True)

    class Meta:
        model = BgPackage
        fields = ["id", "name", "rate", "included_checks", "vendor", "created_at"]


class BgCheckRequestSerializer(serializers.ModelSerializer):
    candidate = serializers.StringRelatedField()
    requisition = serializers.StringRelatedField()
    vendor = BgVendorSerializer(read_only=True)
    selected_package = BgPackageSerializer(read_only=True)

    def create(self, validated_data):
        requisition_value = self.initial_data.get("requisition")
        if requisition_value:
            validated_data["requisition"] = JobRequisition.objects.get(RequisitionID=requisition_value)
        return super().create(validated_data)


    class Meta:
        model = BgCheckRequest
        fields = [
            "id", "requisition", "candidate", "vendor",
            "selected_package", "custom_checks", "status", "created_at"
        ]

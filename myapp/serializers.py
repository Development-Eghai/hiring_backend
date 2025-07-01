from rest_framework import serializers
from .models import Approver, Benefit, CandidateInterviewStages, CandidateReview, Candidates, InterviewDesignParameters, InterviewDesignScreen, OfferNegotiation, OfferNegotiationBenefit, StageAlertResponsibility,UserDetails
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
            "visa_requirements", "notice_period"
        ]

    # RequisitionDetails methods
    def get_division(self, obj): return getattr(obj.details, "division", None)
    def get_department(self, obj): return getattr(obj.details, "department", None)
    def get_location(self, obj): return getattr(obj.details, "location", None)
    def get_internal_title(self, obj): return getattr(obj.details, "internal_title", None)
    def get_external_title(self, obj): return getattr(obj.details, "external_title", None)
    def get_job_position(self, obj): return getattr(obj.details, "job_position", None)
    def get_business_line(self, obj): return getattr(obj.details, "business_line", None)
    def get_geo_zone(self, obj): return getattr(obj.details, "geo_zone", None)
    def get_primary_skills(self, obj): return getattr(obj.details, "primary_skills", None)
    def get_secondary_skills(self, obj): return getattr(obj.details, "secondary_skills", None)
    def get_contract_start_date(self, obj):
        return obj.details.contract_start_date.isoformat() if getattr(obj, "details", None) and obj.details.contract_start_date else None
    def get_contract_end_date(self, obj):
        return obj.details.contract_end_date.isoformat() if getattr(obj, "details", None) and obj.details.contract_end_date else None
    def get_band(self, obj): return getattr(obj.details, "band", None)
    def get_sub_band(self, obj): return getattr(obj.details, "sub_band", None)
    def get_career_level(self, obj): return getattr(obj.details, "career_level", None)
    def get_client_interview(self, obj): return getattr(obj.details, "client_interview", None)

    # HiringPlan methods
    def get_tech_stacks(self, obj): return getattr(obj.Planning_id, "tech_stacks", None)
    def get_designation(self, obj): return getattr(obj.Planning_id, "designation", None)
    def get_experience_range(self, obj): return getattr(obj.Planning_id, "experience_range", None)
    def get_target_companies(self, obj): return getattr(obj.Planning_id, "target_companies", None)
    def get_compensation(self, obj): return getattr(obj.Planning_id, "compensation", None)
    def get_working_model(self, obj): return getattr(obj.Planning_id, "working_model", None)
    def get_visa_requirements(self, obj): return getattr(obj.Planning_id, "visa_requirements", None)
    def get_notice_period(self, obj): return getattr(obj.Planning_id, "notice_period", None)

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
            "requisition_details": getattr(obj, "details", None),
            "billing": getattr(obj, "billing_details", None),
            "posting": getattr(obj, "posting_details", None),
            "interviewers": obj.interview_team.all() if hasattr(obj, "interview_team") else [],
            "functional_teams": obj.teams.all() if hasattr(obj, "teams") else [],
        }).data

class JobRequisitionSerializer(serializers.ModelSerializer):
    # Planning_id = serializers.PrimaryKeyRelatedField(queryset=HiringPlan.objects.all())  # ✅ Ensure it's treated as a ForeignKey
    # details = HiringPlanSerializer(required=False)
    details = RequisitionDetailsSerializer(required=False)
    billing_details = BillingDetailsSerializer(required=False)
    posting_details = PostingDetailsSerializer(required=False)
    interview_team = InterviewTeamSerializer(many=True, required=False)
    teams = TeamsSerializer(many=True, required=False)
    class Meta:
        model = JobRequisition
        fields = '__all__'

    def create(self, validated_data):
        """Insert JobRequisition and update related HiringPlan details."""
        logger.info("Creating JobRequisition with data: %s", validated_data)

        # details_data = validated_data.pop('details', None)
        # planning_id1 = validated_data.pop('Planning_id', None)  # Extract as integer
        # planning_id = planning_id1.pk
        # if not isinstance(planning_id, int):  # Ensure Planning_id remains an integer
        #     raise serializers.ValidationError({"error": "Planning_id must be an integer."})
        details_data = validated_data.pop('details', None)
        billing_data = validated_data.pop('billing_details', None)
        posting_data = validated_data.pop('posting_details', None)
        interview_data = validated_data.pop('interview_team', [])
        teams_data = validated_data.pop('teams', [])

        

        # try:
        #     hiring_plan = HiringPlan.objects.get(hiring_plan_id=planning_id)
        # except HiringPlan.DoesNotExist:
        #     raise serializers.ValidationError({"error": f"HiringPlan with ID {planning_id} not found"})

        try:
            # ✅ Assign the HiringPlan instance for database storage
            # validated_data['Planning_id'] = hiring_plan  
            # job_requisition = JobRequisition.objects.create(**validated_data)
            # logger.info("JobRequisition created with ID: %s", job_requisition.RequisitionID)
            # Step 1: Create JobRequisition
            job_requisition = JobRequisition.objects.create(**validated_data)
            logger.info("JobRequisition created with ID: %s", job_requisition.RequisitionID)

            # Step 2: Assign requisition to related tables
            if details_data:
                RequisitionDetails.objects.create(requisition=job_requisition, **details_data)
                logger.info("RequisitionDetails created for JobRequisition ID: %s", job_requisition.RequisitionID)

            # Update HiringPlan details if provided
            # if details_data:
            #     for key, value in details_data.items():
            #         setattr(hiring_plan, key, value)  # Dynamically update fields
            #     hiring_plan.save()
            #     logger.info("HiringPlan updated for ID: %s", planning_id)
            if billing_data:
                BillingDetails.objects.create(requisition=job_requisition, **billing_data)
                logger.info("BillingDetails created for JobRequisition ID: %s", job_requisition.RequisitionID)
            if posting_data:
                PostingDetails.objects.create(requisition=job_requisition, **posting_data)
                logger.info("PostingDetails created for JobRequisition ID: %s", job_requisition.RequisitionID)
            for interviewer in interview_data:
                InterviewTeam.objects.create(requisition=job_requisition, **interviewer)
                logger.info("InterviewTeam added for JobRequisition ID: %s", job_requisition.RequisitionID)
            for team in teams_data:
                Teams.objects.create(requisition=job_requisition, **team)
                logger.info("Teams added for JobRequisition ID: %s", job_requisition.RequisitionID)

            return job_requisition
        except Exception as e:
            logger.error("Error while creating JobRequisition: %s", str(e))
            raise serializers.ValidationError({"error": str(e)})
    def update(self, instance, validated_data):
        logger.info("Updating JobRequisition ID %s with data: %s", instance.RequisitionID, validated_data)

        # Extract nested data
        details_data = validated_data.pop('details', None)
        billing_data = validated_data.pop('billing_details', None)
        posting_data = validated_data.pop('posting_details', None)
        interview_data = validated_data.pop('interview_team', [])
        teams_data = validated_data.pop('teams', [])

        # Update top-level fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        # Update or create related one-to-one fields
        if details_data:
            if hasattr(instance, 'details'):
                for attr, value in details_data.items():
                    setattr(instance.details, attr, value)
                instance.details.save()
            else:
                RequisitionDetails.objects.create(requisition=instance, **details_data)

        if billing_data:
            if hasattr(instance, 'billing_details'):
                for attr, value in billing_data.items():
                    setattr(instance.billing_details, attr, value)
                instance.billing_details.save()
            else:
                BillingDetails.objects.create(requisition=instance, **billing_data)

        if posting_data:
            if hasattr(instance, 'posting_details'):
                for attr, value in posting_data.items():
                    setattr(instance.posting_details, attr, value)
                instance.posting_details.save()
            else:
                PostingDetails.objects.create(requisition=instance, **posting_data)

        # Refresh many-to-many-like data by clearing and recreating
        if interview_data is not None:
            instance.interview_team.all().delete()
            for interviewer in interview_data:
                InterviewTeam.objects.create(requisition=instance, **interviewer)

        if teams_data is not None:
            instance.teams.all().delete()
            for team in teams_data:
                Teams.objects.create(requisition=instance, **team)

        logger.info("JobRequisition ID %s updated successfully", instance.RequisitionID)
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


class CandidateInterviewStagesSerializer(serializers.ModelSerializer):
    class Meta:
        model = CandidateInterviewStages
        fields = '__all__'


class OfferNegotiationBenefitSerializer(serializers.ModelSerializer):
    benefit_name = serializers.CharField(source='benefit.name', read_only=True)

    class Meta:
        model = OfferNegotiationBenefit
        fields = ['id', 'benefit', 'benefit_name']


class OfferNegotiationSerializer(serializers.ModelSerializer):
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
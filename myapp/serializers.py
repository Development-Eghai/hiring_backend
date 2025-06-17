from rest_framework import serializers
from .models import Candidates,UserDetails
from .models import JobRequisition, RequisitionDetails, BillingDetails, PostingDetails, InterviewTeam, Teams
import logging
from .models import CommunicationSkills,InterviewRounds,HiringPlan
from django.core.exceptions import ObjectDoesNotExist

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
class RequisitionDetailsSerializerget(serializers.ModelSerializer):
    class Meta:
        model = RequisitionDetails
        fields = ['division', 'department', 'location']


class JobRequisitionSerializerget(serializers.ModelSerializer):
    details = RequisitionDetailsSerializerget(read_only=True)

    class Meta:
        model = JobRequisition 
        fields = ['RequisitionID' ,'PositionTitle', 'Recruiter', 'details' ,'Status']



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

class JobRequisitionSerializer(serializers.ModelSerializer):
    Planning_id = serializers.PrimaryKeyRelatedField(queryset=HiringPlan.objects.all())  # ✅ Ensure it's treated as a ForeignKey
    details = HiringPlanSerializer(required=False)
    class Meta:
        model = JobRequisition
        fields = '__all__'

    def create(self, validated_data):
        """Insert JobRequisition and update related HiringPlan details."""
        logger.info("Creating JobRequisition with data: %s", validated_data)

        details_data = validated_data.pop('details', None)
        planning_id1 = validated_data.pop('Planning_id', None)  # Extract as integer
        print(planning_id1.pk)
        planning_id = planning_id1.pk
        if not isinstance(planning_id, int):  # Ensure Planning_id remains an integer
            raise serializers.ValidationError({"error": "Planning_id must be an integer."})

        try:
            hiring_plan = HiringPlan.objects.get(hiring_plan_id=planning_id)
        except HiringPlan.DoesNotExist:
            raise serializers.ValidationError({"error": f"HiringPlan with ID {planning_id} not found"})

        try:
            # ✅ Assign the HiringPlan instance for database storage
            validated_data['Planning_id'] = hiring_plan  
            job_requisition = JobRequisition.objects.create(**validated_data)
            logger.info("JobRequisition created with ID: %s", job_requisition.RequisitionID)

            # Update HiringPlan details if provided
            if details_data:
                for key, value in details_data.items():
                    setattr(hiring_plan, key, value)  # Dynamically update fields
                hiring_plan.save()
                logger.info("HiringPlan updated for ID: %s", planning_id)

            return job_requisition
        except Exception as e:
            logger.error("Error while creating JobRequisition: %s", str(e))
            raise serializers.ValidationError({"error": str(e)})

    # def to_representation(self, instance):
    #     representation = super().to_representation(instance)
    #     representation['Planning_id'] = instance.Planning_id.hiring_plan_id  # ✅ Convert to integer
    #     return representation
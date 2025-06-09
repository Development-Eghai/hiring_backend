from rest_framework import serializers
from .models import Candidates,UserDetails
from .models import JobRequisition, RequisitionDetails, BillingDetails, PostingDetails, InterviewTeam, Teams
import logging

logger = logging.getLogger(__name__)


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
class JobRequisitionSerializer(serializers.ModelSerializer):
    details = RequisitionDetailsSerializer(required=False)
    billing_details = BillingDetailsSerializer(required=False)
    posting_details = PostingDetailsSerializer(required=False)
    interview_team = InterviewTeamSerializer(many=True, required=False)
    teams = TeamsSerializer(many=True, required=False)

    class Meta:
        model = JobRequisition
        fields = '__all__'

    def create(self, validated_data):
        """Insert JobRequisition first, then add related details"""
        logger.info("Creating JobRequisition with data: %s", validated_data)
        details_data = validated_data.pop('details', None)
        billing_data = validated_data.pop('billing_details', None)
        posting_data = validated_data.pop('posting_details', None)
        interview_data = validated_data.pop('interview_team', [])
        teams_data = validated_data.pop('teams', [])

        try:
            # Step 1: Create JobRequisition
            job_requisition = JobRequisition.objects.create(**validated_data)
            logger.info("JobRequisition created with ID: %s", job_requisition.RequisitionID)

            # Step 2: Assign requisition to related tables
            if details_data:
                RequisitionDetails.objects.create(requisition=job_requisition, **details_data)
                logger.info("RequisitionDetails created for JobRequisition ID: %s", job_requisition.RequisitionID)
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

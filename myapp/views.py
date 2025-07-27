# Import necessary modules and models
import base64
import datetime
from io import BytesIO
import openpyxl
from openpyxl.styles import Font
from urllib.parse import quote
import os
import random

import PyPDF2 as pdf
import jwt
from django.conf import settings
# from django.contrib import messages
from django.contrib.auth import get_user_model
# from django.contrib.auth.models import Us
from django.contrib.auth.hashers import check_password
from django.contrib.auth.hashers import make_password
from django.core.mail import send_mail
from django.db import transaction
from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.utils.crypto import get_random_string
from django.views.decorators.csrf import csrf_exempt
from langchain_ollama import OllamaLLM
import requests
from rest_framework import generics
from rest_framework import status
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.parsers import MultiPartParser, FormParser
# from .utils import extract_info_from_resume  # Import the parsing function
from rest_framework.permissions import IsAuthenticated

from myapp.zoom_utils import schedule_zoom_meet
from datetime import timedelta, timezone as dt_timezone



from .models import ApprovalStatus, Approver, BgCheckRequest, BgPackage, BgVendor, CandidateApproval, CandidateInterviewStages, CandidateReview, CandidateSubmission, ConfigHiringData, \
    ConfigPositionRole, ConfigScoreCard, ConfigScreeningType, InterviewDesignParameters, InterviewDesignScreen, InterviewPlanner, \
    InterviewReview, InterviewSchedule, InterviewSlot, Interviewer, OfferNegotiation, RequisitionDetails, StageAlertResponsibility, \
    UserDetails, UserroleDetails
from .models import Candidate
from .models import InterviewRounds, HiringPlan
from .models import JobRequisition
from .serializers import ApproverDetailSerializer, ApproverSerializer, BgCheckRequestSerializer, BgPackageSerializer, CandidateApprovalStatusSerializer, CandidateDetailWithInterviewSerializer, CandidateInterviewStagesSerializer, CandidateSerializer, \
    CandidateSubmissionSerializer, ConfigHiringDataSerializer, ConfigPositionRoleSerializer, ConfigScoreCardSerializer, \
    ConfigScreeningTypeSerializer, InterviewDesignParametersSerializer, InterviewDesignScreenSerializer, InterviewPlannerSerializer, \
    InterviewerSerializer, JobRequisitionSerializer, JobTemplateSerializer, OfferNegotiationSerializer, \
    StageAlertResponsibilitySerializer
from .serializers import HiringInterviewRoundsSerializer, HiringSkillsSerializer, HiringPlanSerializer

SECRET_KEY = settings.SECRET_KEY
from rest_framework.decorators import api_view,permission_classes
from rest_framework_simplejwt.tokens import RefreshToken
from .jwt_token import api_json_response_format
from rest_framework.views import APIView
from rest_framework.response import Response
from django.utils import timezone


from datetime import datetime
import pytz
# from sentence_transformers import SentenceTransformer, util
# import torch
import re
from .serializers import JobRequisitionDetailSerializer

# ollama.base_url = "http://ollama:11434"


# required for JWT
User = get_user_model()

class ApproverCreateListView(generics.ListCreateAPIView):
    queryset = Approver.objects.all()
    serializer_class = ApproverSerializer

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            if not queryset:
                return Response(api_json_response_format(
                    False,
                    "No approvers found.",
                    404,
                    {}
                ), status=200)

            no_of_approvers = len(queryset)

            # Assuming all approvers share the same requisition and plan metadata
            first_approver = queryset[0]
            requisition = first_approver.requisition
            hiring_plan = first_approver.hiring_plan

            approvers_data = []
            for approver in queryset:
                approvers_data.append({
                    "approver_id": approver.id,
                    "role": approver.role,
                    "job_title": approver.job_title,
                    "first_name": approver.first_name,
                    "last_name": approver.last_name,
                    "email": approver.email,
                    "contact_number": approver.contact_number,
                    "set_as_approver": approver.set_as_approver
                })

            response_payload = {
                "req_id": requisition.RequisitionID if requisition else "Unknown",
                "planning_id": hiring_plan.hiring_plan_id if hiring_plan else "",
                "client_name": requisition.company_client_name if requisition else "",
                "client_id": requisition.client_id if requisition else "",
                "no_of_approvers": no_of_approvers,
                "approvers": approvers_data
            }

            return Response(api_json_response_format(
                True,
                "Approvers retrieved successfully!",
                200,
                response_payload
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error retrieving approvers. {str(e)}",
                500,
                {}
            ), status=200)



    def create(self, request, *args, **kwargs):
        try:
            payload = request.data
            approver_list = payload.get("approvers", [])

            if not approver_list or not isinstance(approver_list, list):
                return Response(api_json_response_format(
                    False,
                    "Missing or invalid 'approvers' list in payload.",
                    400,
                    {}
                ), status=200)

            # Shared metadata
            shared_fields = {
                "requisition_id": payload.get("req_id"),
                "hiring_plan": payload.get("planning_id"),  # ✅ Correct key
                "client_name": payload.get("client_name"),
                "client_id": payload.get("client_id"),
                "no_of_approvers": payload.get("no_of_approvers")
            }


            # Enrich each approver with shared metadata
            
            enriched_approvers = []
            for approver in approver_list:
                enriched = {
                    **approver,
                    "requisition": shared_fields["requisition_id"],  # 👈 use correct key name
                    "hiring_plan": shared_fields["hiring_plan"],
                    "client_name": shared_fields["client_name"],
                    "client_id": shared_fields["client_id"],
                    "no_of_approvers": shared_fields["no_of_approvers"]
                }
                enriched_approvers.append(enriched)

            serializer = self.get_serializer(data=enriched_approvers, many=True)
            serializer.is_valid(raise_exception=True)
            Approver.objects.bulk_create([Approver(**data) for data in serializer.validated_data])

            return Response(api_json_response_format(
                True,
                "Approvers created successfully!",
                200,
                serializer.data
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error creating approvers. {str(e)}",
                500,
                {}
            ), status=200)



    def put(self, request, *args, **kwargs):
        try:
            payload = request.data
            approver_list = payload.get("approvers", [])

            if not approver_list or not isinstance(approver_list, list):
                return Response(api_json_response_format(
                    False,
                    "Missing or invalid 'approvers' list in payload.",
                    400,
                    {}
                ), status=200)

            # Shared metadata remap
            shared_fields = {
                "requisition_id": payload.get("req_id"),
                "hiring_plan": payload.get("planning_id"),
                "client_name": payload.get("client_name"),
                "client_id": payload.get("client_id"),
                "no_of_approvers": payload.get("no_of_approvers")
            }

            updated_data = []
            errors = []

            for approver in approver_list:
                approver_id = approver.get("approver_id")

                if not approver_id:
                    errors.append(f"Missing 'approver_id' in one of the approver entries.")
                    continue

                try:
                    instance = Approver.objects.get(id=approver_id)

                    # Merge individual fields with shared ones
                    update_fields = {
                        **approver,
                        "requisition_id": shared_fields["requisition_id"],
                        "hiring_plan": shared_fields["hiring_plan"],
                    }

                    serializer = self.get_serializer(instance, data=update_fields, partial=True)
                    serializer.is_valid(raise_exception=True)
                    serializer.save()
                    updated_data.append(serializer.data)

                except Approver.DoesNotExist:
                    errors.append(f"Approver ID {approver_id} not found.")
                except Exception as e:
                    errors.append(f"Error updating approver ID {approver_id}: {str(e)}")

            success = bool(updated_data)
            message = "Approvers updated successfully!" if success else "No approvers updated."

            return Response(api_json_response_format(
                success,
                message,
                200 if success else 400,
                {
                    "updated_approvers": updated_data,
                    "errors": errors
                }
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error processing update request. {str(e)}",
                500,
                {}
            ), status=200)



    def delete(self, request, *args, **kwargs):
        try:
            approver_id = request.data.get('id')
            approver = Approver.objects.get(id=approver_id)
            approver.delete()
            return Response(api_json_response_format(
                True,
                "Approver deleted successfully!",
                200,
                {}
            ), status=200)
        except Approver.DoesNotExist:
            return Response(api_json_response_format(
                False,
                "Approver not found.",
                404,
                {}
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error deleting approver. {str(e)}",
                500,
                {}
            ), status=200)
        

@csrf_exempt
@api_view(['POST'])
def get_approvers_by_requisition(request):
    try:
        req_id = request.data.get("req_id")

        if not req_id:
            return Response(api_json_response_format(
                False,
                "Missing 'req_id' in payload.",
                400,
                {}
            ), status=200)

        # Fetch approvers for given requisition
        approvers_qs = Approver.objects.filter(requisition__RequisitionID=req_id)

        if not approvers_qs.exists():
            return Response(api_json_response_format(
                False,
                f"No approvers found for requisition {req_id}.",
                404,
                {}
            ), status=200)

        # Pull metadata from first approver’s related requisition/hiring plan
        first_approver = approvers_qs.first()
        requisition = first_approver.requisition
        hiring_plan = getattr(first_approver, "hiring_plan", None)

        response_data = {
            "req_id": requisition.RequisitionID if requisition else "Unknown",
            "planning_id": hiring_plan.hiring_plan_id if hiring_plan else "",
            "client_name": requisition.company_client_name if requisition else "",
            "client_id": requisition.client_id if requisition else "",
            "no_of_approvers": approvers_qs.count(),
            "approvers": [
                {
                    "approver_id": approver.id,
                    "role": approver.role,
                    "job_title": approver.job_title,
                    "first_name": approver.first_name,
                    "last_name": approver.last_name,
                    "email": approver.email,
                    "contact_number": approver.contact_number,
                    "set_as_approver": approver.set_as_approver
                }
                for approver in approvers_qs
            ]
        }

        return Response(api_json_response_format(
            True,
            "Approvers fetched successfully!",
            200,
            response_data
        ), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False,
            f"Error fetching approvers. {str(e)}",
            500,
            {}
        ), status=200)


class BgPackageSetupView(APIView):
    def post(self, request):
        try:
            vendor_name = request.data.get("vendor_name")
            package_name = request.data.get("package_name")
            rate = request.data.get("rate")
            checks = request.data.get("checks")  # expects list

            if not vendor_name or not package_name or rate is None:
                return Response(api_json_response_format(
                    False,
                    "Missing required fields.",
                    400,
                    {}
                ), status=200)

            # Get or create vendor
            vendor, _ = BgVendor.objects.get_or_create(name=vendor_name)

            # Create package
            bg_package = BgPackage.objects.create(
                vendor=vendor,
                name=package_name,
                rate=rate,
                included_checks=checks
            )

            serializer = BgPackageSerializer(bg_package)
            return Response(api_json_response_format(
                True,
                "Package configured successfully.",
                201,
                serializer.data
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error while configuring package: {str(e)}",
                500,
                {}
            ), status=200)

class InitiateBgCheckView(APIView):
    def post(self, request):
        try:
            requisition_id = request.data.get("requisition_id")
            candidate_id = request.data.get("candidate_id")
            vendor_id = request.data.get("vendor_id")
            package_id = request.data.get("package_id")
            custom_checks = request.data.get("custom_checks", [])  # optional list

            if not (requisition_id and candidate_id and vendor_id):
                return Response(api_json_response_format(
                    False,
                    "Missing required fields: requisition_id, candidate_id, vendor_id.",
                    400,
                    {}
                ), status=200)

            requisition = JobRequisition.objects.get(RequisitionID=requisition_id)
            candidate = Candidate.objects.get(pk=candidate_id)
            vendor = BgVendor.objects.get(pk=vendor_id)

            selected_package = BgPackage.objects.get(pk=package_id) if package_id else None

            bg_request = BgCheckRequest.objects.create(
                requisition=requisition,
                candidate=candidate,
                vendor=vendor,
                selected_package=selected_package,
                custom_checks=custom_checks,
                status="Initiated"
            )

            serializer = BgCheckRequestSerializer(bg_request)
            return Response(api_json_response_format(
                True,
                "BG Check initiated.",
                201,
                serializer.data
            ), status=200)

        except JobRequisition.DoesNotExist:
            return Response(api_json_response_format(False, "Requisition not found", 404, {}), status=200)
        except Candidate.DoesNotExist:
            return Response(api_json_response_format(False, "Candidate not found", 404, {}), status=200)
        except BgVendor.DoesNotExist:
            return Response(api_json_response_format(False, "Vendor not found", 404, {}), status=200)
        except BgPackage.DoesNotExist:
            return Response(api_json_response_format(False, "Package not found", 404, {}), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, f"Error initiating BG check: {str(e)}", 500, {}), status=200)

class BgCheckRequestView(APIView):
    def post(self, request):
        try:
            data = request.data.copy()

            # Resolve requisition, candidate, vendor, package
            requisition = JobRequisition.objects.get(RequisitionID=data.get("requisition"))
            candidate = Candidate.objects.get(pk=data.get("candidate"))
            vendor = BgVendor.objects.get(pk=data.get("vendor"))
            selected_package = BgPackage.objects.get(pk=data.get("selected_package")) if data.get("selected_package") else None

            bg_request = BgCheckRequest.objects.create(
                requisition=requisition,
                candidate=candidate,
                vendor=vendor,
                selected_package=selected_package,
                custom_checks=data.get("custom_checks", []),
                status=data.get("status", "Initiated")
            )

            serializer = BgCheckRequestSerializer(bg_request)
            return Response(api_json_response_format(True, "BG Check created.", 201, serializer.data), status=200)

        except JobRequisition.DoesNotExist:
            return Response(api_json_response_format(False, "Requisition not found", 404, {}), status=200)
        except Candidate.DoesNotExist:
            return Response(api_json_response_format(False, "Candidate not found", 404, {}), status=200)
        except BgVendor.DoesNotExist:
            return Response(api_json_response_format(False, "Vendor not found", 404, {}), status=200)
        except BgPackage.DoesNotExist:
            return Response(api_json_response_format(False, "Package not found", 404, {}), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, str(e), 500, {}), status=200)


    def get(self, request):
        try:
            req_id = request.query_params.get("requisition_id")
            candidate_id = request.query_params.get("candidate_id")
            queryset = BgCheckRequest.objects.all()

            if req_id:
                queryset = queryset.filter(requisition__RequisitionID=req_id)
            if candidate_id:
                queryset = queryset.filter(candidate__CandidateID=candidate_id)

            serializer = BgCheckRequestSerializer(queryset, many=True)
            return Response(api_json_response_format(True, "BG Requests fetched", 200, serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, str(e), 500, {}), status=200)



def compute_overall_status(approvals, expected_roles):
    decision_map = {a.role: a.decision for a in approvals}
    decisions = [decision_map.get(role, "Awaiting") for role in expected_roles]

    if any(d == "Awaiting" for d in decisions):
        return "Awaiting Approval"
    if all(d == "Approved" for d in decisions):
        return "Approved"
    return "Partially Approved"



class CandidateApprovalStatusView(APIView):

    def post(self, request):
        try:
            candidates = Candidate.objects.select_related('Req_id_fk').all()
            results = []

            for candidate in candidates:
                requisition = candidate.Req_id_fk
                if not requisition:
                    continue

                details = getattr(requisition, 'position_information', None)
                approvals = CandidateApproval.objects.filter(candidate=candidate)
                approvers = Approver.objects.filter(requisition=requisition, set_as_approver="Yes")

                approver_details = []
                for approver in approvers:
                    approval = approvals.filter(approver=approver).first()

                    approver_detail = {
                        "role": approver.role,
                        "name": f"{approver.first_name} {approver.last_name}",
                        "email": approver.email,
                        "contact_number": approver.contact_number,
                        "job_title": approver.job_title,
                        "status": approver.set_as_approver,
                        "decision": approval.decision if approval else "Awaiting",
                        "comment": approval.comment if approval and approval.comment else "",
                        # "reviewed_at": approval.reviewed_at if approval else "Not Reviewed",
                        "req_id": requisition.RequisitionID,
                        "client_name": details.company_client_name if details else "",
                        "client_id": requisition.client_id if requisition and requisition.client_id else "",
                        "candidate_id": candidate.CandidateID,
                        "candidate_first_name": candidate.candidate_first_name,
                        "candidate_last_name": candidate.candidate_last_name,
                        "screening_status": candidate.Result, 
                    }

                    results.append(approver_detail)  # Append each approver individually



                expected_roles = [a.role for a in approvers]
                overall_status = compute_overall_status(approvals, expected_roles)

                # results.append({
                #     "req_id": requisition.RequisitionID,
                #     "client_name": details.company_client_name if details else "",
                #     "client_id": details.client_id if details else "",
                #     "candidate_id": candidate.CandidateID,
                #     "candidate_first_name": candidate.candidate_first_name,
                #     "candidate_last_name": candidate.candidate_last_name,
                #     "overall_status": overall_status,
                #     "no_of_approvers": len(approvers),
                #     "approvers": approver_details
                # })
            # results.append({
            #     "req_id": requisition.RequisitionID,
            #     "client_name": details.company_client_name if details else "",
            #     "client_id": details.client_id if details else "",
            #     "approvers": approver_details
            # })

            serializer = ApproverDetailSerializer(results, many=True)
            return Response(api_json_response_format(
                True,
                "approval status retrieved!",
                200,
                serializer.data
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error retrieving approval status. {str(e)}",
                500,
                []
            ), status=200)

    def put(self, request):
        try:
            candidate_id = request.data.get("candidate_id")
            role_id = request.data.get("role_id")
            decision = request.data.get("decision")
            comment = request.data.get("comment", "")

            if not candidate_id or not role_id or not decision:
                raise ValueError("Missing candidate_id, role_id, or decision")

            role_map = {
                1: "HM",
                3: "FPNA"
            }
            role = role_map.get(int(role_id))
            if not role:
                raise ValueError("Invalid role_id")

            candidate = Candidate.objects.get(pk=candidate_id)
            approval = CandidateApproval.objects.filter(candidate=candidate, role=role).first()

            if not approval:
                return Response(api_json_response_format(
                    False,
                    f"No approval record found for role '{role}' and candidate ID {candidate_id}",
                    404,
                    {}
                ), status=200)

            approval.decision = decision
            approval.comment = comment
            approval.reviewed_at = timezone.now()
            approval.save()

            all_approvals = CandidateApproval.objects.filter(candidate=candidate)
            approvers = Approver.objects.filter(requisition=candidate.Req_id_fk, set_as_approver="Yes")
            expected_roles = [a.role for a in approvers]
            overall_status = compute_overall_status(all_approvals, expected_roles)

            return Response(api_json_response_format(
                True,
                f"{role} decision updated successfully",
                200,
                {
                    "candidate_id": candidate.CandidateID,
                    "role": role,
                    "decision": approval.decision,
                    "comment": approval.comment,
                    "reviewed_at": approval.reviewed_at,
                    "overall_status": overall_status
                }
            ), status=200)

        except Candidate.DoesNotExist:
            return Response(api_json_response_format(
                False,
                "Candidate not found",
                404,
                {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error updating approval decision: {str(e)}",
                500,
                {}
            ), status=200)



class ApproverFilterView(APIView):
    def post(self, request, *args, **kwargs):
        try:
            hiring_plan_id = request.data.get("hiring_plan")
            if not hiring_plan_id:
                return Response(api_json_response_format(
                    False,
                    "hiring_plan is required in request body",
                    400,
                    []
                ), status=200)

            approvers = Approver.objects.filter(hiring_plan_id=hiring_plan_id)
            serializer = ApproverSerializer(approvers, many=True)
            return Response(api_json_response_format(
                True,
                "Approvers filtered by hiring plan retrieved successfully!",
                200,
                serializer.data
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error filtering approvers. {str(e)}",
                500,
                []
            ), status=200)

class OfferNegotiationViewSet(viewsets.ModelViewSet):
    queryset = OfferNegotiation.objects.prefetch_related('benefits').all()
    serializer_class = OfferNegotiationSerializer

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.filter_queryset(self.get_queryset())
            serializer = self.get_serializer(queryset, many=True)
            return Response(api_json_response_format(
                True, "Job requisitions retrieved successfully!", 200, serializer.data
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False, f"Error retrieving job requisitions. {str(e)}", 500, {}
            ), status=200)

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            return Response(api_json_response_format(
                True, "Offer negotiation created successfully!", 200, serializer.data
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False, f"Error creating offer negotiation. {str(e)}", 500, {}
            ), status=200)

    @action(detail=False, methods=['get'], url_path='pending-approvals')
    def pending_approvals(self, request):
        try:
            negotiations = OfferNegotiation.objects.filter(
                negotiation_status='Successful'
            ).select_related('requisition').prefetch_related('approvals__approver')

            data = []

            for i, offer in enumerate(negotiations, start=1):
                candidate = Candidate.objects.filter(
                    Req_id_fk=offer.requisition.RequisitionID
                ).first()

                # Build { role: status } dictionary
                role_map = {a.approver.role: a.status for a in offer.approvals.all()}

                def get_display_status(status):
                    return "Yes" if status == "Approved" else "Awaiting" if status == "Pending" else status or "N/A"

                # Core static data
                row = {
                    "SNo": i,
                    "ReqID": offer.requisition.RequisitionID,
                    "ClientID": f"{offer.requisition.id:04}",
                    "ClientName": offer.client_name,
                    "CandidateID": candidate.CandidateID if candidate else None,
                    "CandidateFirstName": offer.first_name,
                    "CandidateLastName": offer.last_name,
                    "Status": (
                        "Waiting for approval"
                        if any(status == "Pending" for status in role_map.values())
                        else offer.negotiation_status
                    ),

                }

                # Add dynamic approver columns
                for role, status in role_map.items():
                    column_name = f"{role} Status" if "Status" not in role else role
                    row[column_name] = get_display_status(status)

                data.append(row)

            return Response(api_json_response_format(
                True, "Pending approvals fetched successfully.", 200, data
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, f"Error fetching pending approvals. {str(e)}", 500, {}
            ), status=200)




def approve_offer(request, negotiation_id):
    email = request.GET.get('email')
    role = request.GET.get('role')

    if not email or not role:
        return HttpResponse("Invalid approval link. Missing parameters.", status=200)

    negotiation = get_object_or_404(OfferNegotiation, pk=negotiation_id)
    approver = get_object_or_404(Approver, email=email, role=role)
    approval_status = get_object_or_404(ApprovalStatus, offer_negotiation=negotiation, approver=approver)

    if approval_status.status != "Pending":
        return HttpResponse(f"You already responded: {approval_status.status}", status=200)

    approval_status.status = "Approved"
    approval_status.save()

    return HttpResponse(f"✅ Thank you! Your approval for {negotiation.first_name} {negotiation.last_name} has been recorded.", status=200)

def reject_offer(request, negotiation_id):
    email = request.GET.get('email')
    role = request.GET.get('role')

    if not email or not role:
        return HttpResponse("Invalid rejection link. Missing parameters.", status=200)

    negotiation = get_object_or_404(OfferNegotiation, pk=negotiation_id)
    approver = get_object_or_404(Approver, email=email, role=role)
    approval_status = get_object_or_404(ApprovalStatus, offer_negotiation=negotiation, approver=approver)

    if approval_status.status != "Pending":
        return HttpResponse(f"You already responded: {approval_status.status}", status=200)

    approval_status.status = "Rejected"
    approval_status.save()

    return HttpResponse(f"❌ Your rejection has been recorded for {negotiation.first_name} {negotiation.last_name}.", status=200)

class GetInterviewScheduleAPIView(APIView):
    def post(self, request):
        try:
            email = request.data.get("email")
            if not email:
                return Response(api_json_response_format(False, "Missing interviewer email", 400, {}), status=200)

            schedules = InterviewSchedule.objects.filter(
                interviewer__email=email
            ).select_related('candidate', 'candidate__Req_id_fk')

            data = []
            for schedule in schedules:
                candidate = schedule.candidate
                requisition = candidate.Req_id_fk

                data.append({
                    "Schedule ID": schedule.id,
                    "Candidate Name": candidate.Name,
                    "Requisition ID": requisition.RequisitionID,
                    "Position Title": requisition.PositionTitle,
                    "Interview Date": schedule.date.strftime("%Y-%m-%d"),
                    "Start Time": schedule.start_time.strftime("%H:%M"),
                    "End Time": schedule.end_time.strftime("%H:%M"),
                    "Round Name": schedule.round_name,
                    "Meet Link": schedule.meet_link
                })

            return Response(api_json_response_format(True, "Fetched scheduled interviews", 200, data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Failed to fetch interviews: {e}", 500, {}), status=200)
        
        
class InterviewReportAPIView(APIView):
    def post(self, request):
        req_id = request.data.get("requisition_id")
        if not req_id:
            return Response(api_json_response_format(False, "Missing requisition_id", 400, {}), status=200)

        interviewers = Interviewer.objects.filter(req_id=req_id)
        data = []

        for interviewer in interviewers:
            interviews = InterviewSchedule.objects.filter(
                interviewer=interviewer,
                candidate__Req_id_fk_id=req_id
            ).select_related('candidate')

            for interview in interviews:
                candidate = interview.candidate
                reviews = interview.reviews.all()
                latest_review = reviews.latest("reviewed_at") if reviews.exists() else None

                data.append({
                    "Schedule ID": interview.id,
                    "Req ID": req_id,
                    "Client ID": interviewer.client_id,
                    "First Name": interviewer.first_name,
                    "Last Name": interviewer.last_name,
                    "Job Title": interviewer.job_title,
                    "Interview Mode": interviewer.interview_mode,
                    "Interviewer Stage": interviewer.interviewer_stage,
                    "Email ID": interviewer.email,
                    "Candidate ID": candidate.CandidateID,
                    "Candidate First Name": candidate.Name.split()[0] if candidate.Name else "",
                    "Candidate Last Name": candidate.Name.split()[-1] if candidate.Name else "",
                    "Role": candidate.Req_id_fk.PositionTitle if candidate.Req_id_fk else "",
                    "Feedback": latest_review.feedback if latest_review else "",
                    "Interview Results": latest_review.result if latest_review else "",
                    "Contact Number": interviewer.contact_number,
                    "Round Name": interview.round_name,
                    "Interview Date": interview.date.strftime("%Y-%m-%d"),
                    "Start Time": interview.start_time.strftime("%H:%M"),
                    "End Time": interview.end_time.strftime("%H:%M"),
                    "Meet Link": interview.meet_link
                })

        return Response(api_json_response_format(
            True, "Fetched full interview report", 200, data
        ), status=200)
    

class SubmitInterviewReviewView(APIView):
    def post(self, request):
        try:
            schedule_id = request.data.get("schedule_id")
            feedback = request.data.get("feedback", "")
            result = request.data.get("result", "")

            if not schedule_id:
                return Response(api_json_response_format(False, "Missing schedule_id", 400, {}), status=200)

            schedule = InterviewSchedule.objects.get(id=schedule_id)

            InterviewReview.objects.create(
                schedule=schedule,
                feedback=feedback,
                result=result
            )

            return Response(api_json_response_format(True, "Feedback saved", 200, {}), status=200)

        except InterviewSchedule.DoesNotExist:
            return Response(api_json_response_format(False, "Schedule not found", 404, {}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Failed to save review: {e}", 500, {}), status=200)

class ScheduleContextAPIView(APIView):
    def post(self, request, *args, **kwargs):
        req_id = request.data.get("req_id")
        if not req_id:
            return Response(
                api_json_response_format(False, "Missing requisition_id", 400, {}),
                status=200
            )

        try:
            instance = JobRequisition.objects.prefetch_related(
                "candidates",
                "interviewer__slots", "interviewer"
            ).get(RequisitionID=req_id)
        except JobRequisition.DoesNotExist:
            return Response(
                api_json_response_format(False, "Requisition not found", 404, {}),
                status=200
            )

        serializer = JobRequisitionDetailSerializer(instance)

        # 🔍 Fetch design metadata
        design_screen = InterviewDesignScreen.objects.filter(req_id=req_id).first()
        interview_design_id = design_screen.interview_design_id if design_screen else None

        round_names = []
        if interview_design_id:
            design_params = InterviewDesignParameters.objects.filter(
                interview_design_id=interview_design_id
            ).order_by("interview_desing_params_id")
            round_names = [param.score_card for param in design_params]

        # 🧠 Compose candidate & interviewer names
        candidate = instance.candidates.first()
        candidate_name = f"{candidate.candidate_first_name} {candidate.candidate_last_name}" if candidate else "Not Available"

        interviewer = instance.interviewer.first()
        interviewer_name = f"{interviewer.first_name} {interviewer.last_name}" if interviewer else "Not Assigned"

        # 🔁 Fetch slots from InterviewSlot for the selected interviewer
        slots = []
        if interviewer:
            slot_qs = InterviewSlot.objects.filter(interviewer=interviewer).order_by("date", "start_time")[:5]
            slots = [
                {
                    "date": slot.date.strftime("%Y-%m-%d"),
                    "time": slot.start_time.strftime("%I:%M %p")
                } for slot in slot_qs
            ]

        # 🎯 Compose payload-style response
        response_payload = {
            "req_id": instance.RequisitionID,
            "job_postion": instance.PositionTitle,
            "planning_id": instance.Planning_id.hiring_plan_id if instance.Planning_id else "N/A",
            "candidate_name": candidate_name,
            "interviewer_name": interviewer_name,
            "location": "Zoom",
            "time_zone": "IST",
            "durations": "30 mins",
            "purpose": "Technical Screening",
            "no_of_rounds":len(slots),
            "mode": interviewer.interview_mode if interviewer and interviewer.interview_mode else "Not Specified",
            "round_name": round_names[0] if round_names else "Not Defined",
            "schedule_slots": slots
        }

        return Response(
            api_json_response_format(True, "Fetched scheduling context successfully", 200, {"data": response_payload}),
            status=200
        )


class InterviewerListCreateAPIView(generics.ListCreateAPIView):
    queryset = Interviewer.objects.prefetch_related('slots').all()
    serializer_class = InterviewerSerializer

    def list(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(self.get_queryset(), many=True)
            return Response(api_json_response_format(True, "Interviewer list retrieved successfully", 200, serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, str(e), 500, []), status=200)

    def create(self, request, *args, **kwargs):
        try:
            if 'file' in request.FILES:
                # ✅ Save manually to desired folder
                file = request.FILES['file']
                os.makedirs(RESUME_STORAGE_FOLDER, exist_ok=True)
                file_path = os.path.join(RESUME_STORAGE_FOLDER, file.name)
                
                with open(file_path, "wb") as f:
                    f.write(file.read())

                wb = openpyxl.load_workbook(file_path)
                sheet = wb.active

                created_count = 0
                skipped_rows = []

                for row_idx, row in enumerate(sheet.iter_rows(min_row=2), start=2):
                    data = {
                        "req_id": row[0].value,
                        "client_id": row[1].value,
                        "first_name": row[2].value,
                        "last_name": row[3].value,
                        "job_title": row[4].value,
                        "interview_mode": row[5].value,
                        "interviewer_stage": row[6].value,
                        "email": row[7].value,
                        "contact_number": row[8].value,
                        "slots": [{
                            "date": row[9].value,
                            "start_time": row[10].value,
                            "end_time": row[11].value
                        }]
                    }

                    exists = Interviewer.objects.filter(
                        req_id__RequisitionID=data["req_id"],
                        email=data["email"]
                    ).exists()

                    if exists:
                        skipped_rows.append(row_idx)
                        continue

                    serializer = self.get_serializer(data=data)
                    if serializer.is_valid():
                        serializer.save()
                        created_count += 1
                    else:
                        return Response(api_json_response_format(
                            False,
                            f"Error at row {row_idx}: {serializer.errors}",
                            400,
                            {}
                        ), status=200)

                return Response(api_json_response_format(
                    True,
                    f"{created_count} interviewers created. Skipped rows: {skipped_rows}",
                    200,
                    {}
                ), status=200)


            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(api_json_response_format(True, "Created successfully", 200, {}), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, str(e), 400, {}), status=200)

    def put(self, request, *args, **kwargs):
        try:
            interviewer_id = request.data.get("interviewer_id")
            if not interviewer_id:
                return Response(api_json_response_format(False, "Missing 'id' in request body", 400, {}), status=200)

            interviewer = Interviewer.objects.get(pk=interviewer_id)
            serializer = self.get_serializer(interviewer, data=request.data)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(api_json_response_format(True, "Updated successfully", 200, serializer.data), status=200)
        except Interviewer.DoesNotExist:
            return Response(api_json_response_format(False, "Interviewer not found", 404, {}), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, str(e), 500, {}), status=200)

    def delete(self, request, *args, **kwargs):
        try:
            interviewer_id = request.data.get("interviewer_id")
            if not interviewer_id:
                return Response(api_json_response_format(False, "Missing 'id' in request body", 400, {}), status=200)

            interviewer = Interviewer.objects.get(pk=interviewer_id)
            interviewer.delete()
            return Response(api_json_response_format(True, "Deleted successfully", 200, {}), status=200)
        except Interviewer.DoesNotExist:
            return Response(api_json_response_format(False, "Interviewer not found", 404, {}), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, str(e), 500, {}), status=200)


class ScheduleMeetView(APIView):
    def get(self, request):
        try:
            schedules = InterviewSchedule.objects.select_related("candidate", "interviewer").all().order_by("-date", "-start_time")
            result = []

            for schedule in schedules:
                candidate_full_name = f"{schedule.candidate.candidate_first_name} {schedule.candidate.candidate_last_name}"
                interviewer_full_name = f"{schedule.interviewer.first_name} {schedule.interviewer.last_name}"

                result.append({
                    "schedule_id": schedule.id,
                    "req_id": schedule.interviewer.req_id.RequisitionID if schedule.interviewer.req_id else "Not Linked",
                    "planning_id": (
                        schedule.candidate.Req_id_fk.Planning_id.hiring_plan_id
                        if schedule.candidate.Req_id_fk and schedule.candidate.Req_id_fk.Planning_id else "N/A"
                    ),
                    "candidate_name": candidate_full_name,
                    "interviewer_name": interviewer_full_name,
                    "job_position": schedule.candidate.Req_id_fk.PositionTitle if schedule.candidate.Req_id_fk else "Unknown",
                    "location": schedule.location,
                    "time_zone": schedule.time_zone,
                    "durations": schedule.durations,
                    "purpose": schedule.purpose,
                    "mode": schedule.mode,
                    "no_of_rounds": 1,  # Assuming 1 by default; adjust if stored differently
                    "meet_link": schedule.meet_link,
                    "guests": schedule.guests or [],
                    "schedule_slots": [
                        {
                            "date": str(schedule.date),
                            "time": schedule.start_time.strftime("%I:%M %p"),
                            "guests": [guest.get("email") for guest in schedule.guests] if schedule.guests else []
                        }
                    ]
                })

            return Response(api_json_response_format(True, "All schedules retrieved", 200, result), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error retrieving schedule list: {str(e)}", 500, {}), status=200)

    def post(self, request):
        try:
            payload = request.data
            req_id        = payload.get("req_id")
            planning_id   = payload.get("planning_id")
            candidate_name = payload.get("candidate_name", "")
            interviewer_name = payload.get("interviewer_name", "")
            round_name    = payload.get("purpose", "Interview")
            summary       = payload.get("purpose", f"{round_name} Interview")

            # Extract first schedule slot
            slot = payload.get("schedule_slots", [{}])[0]
            date = slot.get("date")
            time = slot.get("time")
            duration_raw = payload.get("durations", "30 mins")
            duration_mins = int(duration_raw.split()[0]) if duration_raw else 30

            if not all([req_id, candidate_name, interviewer_name, date, time]):
                return Response(api_json_response_format(False, "Missing required fields", 400, {}), status=200)

            tz    = pytz.timezone("Asia/Kolkata")
            start = tz.localize(datetime.strptime(f"{date} {time}", "%Y-%m-%d %I:%M %p"))
            end   = start + timedelta(minutes=duration_mins)

            # Resolve Candidate and Interviewer by name + requisition
            candidate = Candidate.objects.get(
                candidate_first_name__iexact=candidate_name.split()[0],
                candidate_last_name__iexact=candidate_name.split()[1],
                Req_id_fk__RequisitionID=req_id
            )

            interviewer = Interviewer.objects.get(
                first_name__iexact=interviewer_name.split()[0],
                last_name__iexact=interviewer_name.split()[1],
                req_id__RequisitionID=req_id
            )

            guest_emails = [g.get("email") for g in payload.get("guests", []) if g.get("email")]

            join_url = schedule_zoom_meet(
                topic=summary,
                start_time_iso=start.isoformat(),
                duration_minutes=duration_mins,
                timezone="Asia/Kolkata"
            )

            InterviewSchedule.objects.create(
                candidate=candidate,
                interviewer=interviewer,
                round_name=round_name,
                date=start.date(),
                start_time=start.time(),
                end_time=end.time(),
                meet_link=join_url,
                location=payload.get("location"),
                time_zone=payload.get("time_zone"),
                purpose=payload.get("purpose"),
                mode=payload.get("mode"),
                guests=payload.get("guests"),
                durations=payload.get("durations")
            )

            return Response(api_json_response_format(
                True,
                "Interview scheduled successfully",
                200,
                {"meet_link": join_url}
            ), status=200)

        except Candidate.DoesNotExist:
            return Response(api_json_response_format(False, "Candidate not found using given name and requisition.", 404, {}), status=200)
        except Interviewer.DoesNotExist:
            return Response(api_json_response_format(False, "Interviewer not found using given name and requisition.", 404, {}), status=200)
        except ValueError as e:
            return Response(api_json_response_format(False, f"Invalid datetime format: {e}", 400, {}), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, f"Failed to schedule: {str(e)}", 500, {}), status=200)

@api_view(["POST"])
def get_interview_schedule_by_id(request):
    try:
        schedule_id = request.data.get("schedule_id")
        if not schedule_id:
            return Response(api_json_response_format(False, "Missing 'schedule_id' in query params.", 400, {}), status=200)

        schedule = InterviewSchedule.objects.select_related(
            "interviewer__req_id", "candidate__Req_id_fk__Planning_id"
        ).get(id=schedule_id)

        candidate_full_name = f"{schedule.candidate.candidate_first_name} {schedule.candidate.candidate_last_name}" if schedule.candidate else "N/A"
        interviewer_full_name = f"{schedule.interviewer.first_name} {schedule.interviewer.last_name}" if schedule.interviewer else "N/A"

        result = {
            "schedule_id": schedule.id,
            "req_id": schedule.interviewer.req_id.RequisitionID if schedule.interviewer and schedule.interviewer.req_id else "Not Linked",
            "planning_id": (
                schedule.candidate.Req_id_fk.Planning_id.hiring_plan_id
                if schedule.candidate and schedule.candidate.Req_id_fk and schedule.candidate.Req_id_fk.Planning_id
                else "N/A"
            ),
            "candidate_name": candidate_full_name,
            "interviewer_name": interviewer_full_name,
            "job_position": schedule.candidate.Req_id_fk.PositionTitle if schedule.candidate and schedule.candidate.Req_id_fk else "Unknown",
            "location": schedule.location,
            "time_zone": schedule.time_zone,
            "durations": schedule.durations,
            "purpose": schedule.purpose,
            "mode": schedule.mode,
            "no_of_rounds": 1,  # Static for now; customize if needed
            "meet_link": schedule.meet_link,
            "guests": schedule.guests or [],
            "schedule_slots": [{
                "date": str(schedule.date),
                "time": schedule.start_time.strftime("%I:%M %p"),
                "guests": [guest.get("email") for guest in schedule.guests] if schedule.guests else []
            }]
        }

        return Response(api_json_response_format(True, "Schedule retrieved successfully!", 200, result), status=200)

    except InterviewSchedule.DoesNotExist:
        return Response(api_json_response_format(False, "Schedule not found.", 404, {}), status=200)
    except Exception as e:
        return Response(api_json_response_format(False, f"Error retrieving schedule: {str(e)}", 500, {}), status=200)



@api_view(["PUT"])
def update_interview_schedule(request):
    try:
        schedule_id = request.data.get("schedule_id")
        if not schedule_id:
            return Response(api_json_response_format(False, "Missing 'schedule_id' in request.", 400, {}), status=200)

        schedule = InterviewSchedule.objects.get(id=schedule_id)

        # Update fields (only if provided)
        updatable_fields = [
            "location", "time_zone", "purpose", "mode", "guests", "durations",
            "round_name", "meet_link"
        ]
        for field in updatable_fields:
            if field in request.data:
                setattr(schedule, field, request.data[field])

        # Update schedule slot timing
        slot = request.data.get("schedule_slots", [{}])[0]
        if slot.get("date") and slot.get("time"):
            tz = pytz.timezone("Asia/Kolkata")
            start = tz.localize(datetime.strptime(f"{slot['date']} {slot['time']}", "%Y-%m-%d %I:%M %p"))
            duration_mins = int(schedule.durations.split()[0]) if schedule.durations else 30
            end = start + timedelta(minutes=duration_mins)

            schedule.date = start.date()
            schedule.start_time = start.time()
            schedule.end_time = end.time()

        schedule.save()

        return Response(api_json_response_format(True, "Interview schedule updated successfully!", 200, {
            "schedule_id": schedule.id
        }), status=200)

    except InterviewSchedule.DoesNotExist:
        return Response(api_json_response_format(False, "Interview schedule not found.", 404, {}), status=200)
    except Exception as e:
        return Response(api_json_response_format(False, f"Error updating interview: {str(e)}", 500, {}), status=200)

@api_view(["DELETE"])
def delete_interview_schedule(request):
    try:
        schedule_id = request.data.get("schedule_id")
        if not schedule_id:
            return Response(api_json_response_format(False, "Missing 'schedule_id' in request.", 400, {}), status=200)

        schedule = InterviewSchedule.objects.get(id=schedule_id)
        schedule.delete()

        return Response(api_json_response_format(True, "Interview schedule deleted successfully!", 200, {}), status=200)

    except InterviewSchedule.DoesNotExist:
        return Response(api_json_response_format(False, "Schedule not found.", 404, {}), status=200)
    except Exception as e:
        return Response(api_json_response_format(False, f"Error deleting interview: {str(e)}", 500, {}), status=200)


RESUME_STORAGE_FOLDER = "media/resumes"
DISPLAY_TO_MODEL_FIELD1 = {
    "job_position": "job_position",
    "Tech": "tech_stacks",
    "JD": "jd_details",
    "Experience": "experience_range",
    "Designation": "designation",
    "Target": "target_companies",
    "Compensation/Benefits": "compensation",
    "Working": "working_model",
    "Interview Status": "interview_status",
    "Place": "location",
    "Educational": "education_decision",
    "Relocation": "relocation",
    "Travel": "travel_opportunities",
    "Visa": "visa_requirements",
    "Domain": "domain_knowledge",
    "Background": "background_verification",
    "Shift": "shift_timings",
    "Role Type": "role_type",
    "Job Type": "job_type",
    "Communication": "communication_language",
    "Notice Period": "notice_period",
    "Career Gap": "career_gap",
    "Sabbatical": "sabbatical",
    "Screening Questions": "screening_questions",
    "Job Health Requirements": "job_health_requirements",
    "Social Media": "social_media_links",
    "Language Proficiency": "language_proficiency",
    "Additional Compensation": "additional_comp",
    "Citizenship Requirement": "citizen_requirement"
}
DISPLAY_TO_MODEL_FIELD = {
    "id": "RequisitionID",
    "Planning_id": "Planning_id__hiring_plan_id",
    "job_position": "position_information__job_position",
    "Tech": "Planning_id__tech_stacks",
    "JD": "Planning_id__jd_details",
    "Experience": "Planning_id__experience_range",
    "Designation": "Planning_id__designation",
    "Target": "Planning_id__target_companies",
    "Interviewer": "position_information__interviewer_teammate_employee_id",
    "Interview": "position_information__client_interview",
    "Compensation/Benefits": "Planning_id__compensation",
    "Duration/Timeline": ["position_information__contract_start_date", "position_information__contract_end_date"],
    "Place": "position_information__location",
    "Working": "position_information__working_model",
    "Educational": "Planning_id__education_decision",
    "Relocation": "Planning_id__relocation",
    "Travel": "Planning_id__travel_opportunities",
    "Visa": "Planning_id__visa_requirements",
    "Domain": "Planning_id__domain_knowledge",
    "Background": "Planning_id__background_verification",
    "Shift": "Planning_id__shift_timings",
    "Role Type": "Planning_id__role_type",
    "Job Type": "Planning_id__job_type",
    "Communication": "Planning_id__communication_language",
    "Notice Period": "Planning_id__notice_period",
    "Career Gap": "Planning_id__career_gap",
    "Sabbatical": "Planning_id__sabbatical",
    "Screening Questions": "Planning_id__screening_questions",
    "Job Health Requirements": "Planning_id__job_health_requirements",
    "Social Media": "Planning_id__social_media_links",
    "Language Proficiency": "Planning_id__language_proficiency",
    "Recruiter": "Recruiter",
    "division": "position_information__division",
    "department": "position_information__department",
    "location": "position_information__location",
    "status": "Status",
    "Client_name": "company_client_name",
    "Client_id": "client_id",
    "Requisition_date": "requisition_date",
    "Due_requisition_date": "due_requisition_date"

}

# Initialize Ollama model
# ollama_model = OllamaLLM(base_url='http://localhost:11434', model='ats_model')
ollama_model = OllamaLLM(base_url='http://ollama:11434', model='ats_model')
# model = SentenceTransformer("models/paraphrase-MiniLM-L6-v2")

def extract_text_from_pdf(uploaded_file):
    reader = pdf.PdfReader(uploaded_file)
    text = ""
    for page in reader.pages:
        text += str(page.extract_text())
    return text


def extract_info_from_text(text):
    """Attempts AI-based name & email extraction, with fallback regex."""
    prompt = f"""
    Extract only the full name and email address from this resume.
    Return data in JSON format: 
    {{
        "name": "[Full Name]",
        "email": "[Email Address]"
    }}
    Resume Content: {text}"""

    try:
        ai_output = ollama_model.invoke(prompt)
    except Exception as e:
        print("Ollama Error:", e)
        ai_output = ""

    except Exception as e:
        print("Ollama Error:", e)
        ai_output = ""

    print("AI Response:\n", ai_output)

    # Try extracting using AI response JSON
    name_match = re.search(r'"name":\s*"([^"]+)"', ai_output)
    email_match = re.search(r'"email":\s*"([^"]+)"', ai_output)

    if name_match and email_match:
        return name_match.group(1), email_match.group(1)

    # Fallback regex extraction if AI fails
    name_fallback = re.search(r"Name:\s*(.*)", text)
    email_fallback = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", text)

    name = name_fallback.group(1) if name_fallback else "Unknown"
    email = email_fallback.group(1) if email_fallback else "Not found"

    return name, email

def process_resume(file_req_tuple):
    file, req_id = file_req_tuple

    # Ensure the resume directory exists
    os.makedirs(RESUME_STORAGE_FOLDER, exist_ok=True)

    # Save file locally
    file_path = os.path.join(RESUME_STORAGE_FOLDER, file.name)
    with open(file_path, "wb") as f:
        f.write(file.read())

    # Extract text and info
    resume_text = extract_text_from_pdf(file)
    name, email = extract_info_from_text(resume_text)

    # Build Candidate instance
    return Candidate(
        Name=name,
        Email=email,
        Resume=file_path,
        Req_id_fk=req_id
    )


import os
from django.core.files.base import ContentFile

class ResumeAccessView(APIView):
    def post(self, request):
        try:
            candidate_id = request.data.get("candidate_id")
            if not candidate_id:
                return Response(api_json_response_format(False, "candidate_id is required.", 400, {}), status=200)

            candidate = Candidate.objects.select_related("Req_id_fk").filter(CandidateID=candidate_id).first()
            if not candidate:
                return Response(api_json_response_format(False, "Candidate not found.", 404, {}), status=200)

            # Resume
            resume_path = candidate.Resume
            resume_url = request.build_absolute_uri(settings.MEDIA_URL + "resumes/" + str(resume_path)) if resume_path else "N/A"

            # Cover Letter
            cover_path = candidate.CoverLetter
            cover_url = request.build_absolute_uri(settings.MEDIA_URL + "resumes/" + str(cover_path)) if cover_path else "N/A"

            # JD as HTML file
            jd_url = "N/A"
            if candidate.Req_id_fk and hasattr(candidate.Req_id_fk, "posting_details"):
                jd_html = candidate.Req_id_fk.posting_details.internal_job_description
                if jd_html:
                    # Create JD file dynamically
                    jd_filename = f"jd_candidate_{candidate_id}.html"
                    jd_dir = os.path.join(settings.MEDIA_ROOT, "jd_descriptions")
                    os.makedirs(jd_dir, exist_ok=True)
                    jd_path = os.path.join(jd_dir, jd_filename)

                    with open(jd_path, "w", encoding="utf-8") as jd_file:
                        jd_file.write(jd_html)

                    jd_url = request.build_absolute_uri(settings.MEDIA_URL + "jd_descriptions/" + jd_filename)

            return Response(api_json_response_format(True, "Resume and related details fetched successfully.", 200, {
                "resume_url": resume_url,
                "cover_letter_url": cover_url,
                "JD_url": jd_url
            }), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error fetching resume details. {str(e)}", 500, {}), status=200)


class CandidateDeleteView(APIView):
    def delete(self, request):
        try:
            candidate_id = request.data.get("candidate_id")

            if not candidate_id:
                return Response(api_json_response_format(
                    False, "Missing candidate_id in request body", 400, {}
                ), status=200)

            candidate = Candidate.objects.filter(CandidateID=candidate_id).first()
            if not candidate:
                return Response(api_json_response_format(
                    False, "Candidate not found", 404, {}
                ), status=200)

            candidate.delete()
            return Response(api_json_response_format(
                True, "Candidate deleted successfully", 200, {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, f"Error deleting candidate: {str(e)}", 500, {}
            ), status=200)


class CandidateUpdateView(APIView):
    parser_classes = [MultiPartParser, FormParser]

    def put(self, request):
        try:
            candidate_id = request.data.get("candidate_id")
            if not candidate_id:
                return Response(api_json_response_format(False, "candidate_id is required.", 400, {}), status=200)

            candidate = Candidate.objects.filter(CandidateID=candidate_id).first()
            if not candidate:
                return Response(api_json_response_format(False, "Candidate not found.", 404, {}), status=200)

            # 🔁 Update basic fields
            updatable_fields = ["Name", "Email", "Feedback", "Final_rating", "Result", "Source", "Score", "Phone_no"]
            for field in updatable_fields:
                if field in request.data:
                    setattr(candidate, field, request.data[field] or None)

            # 📎 File uploads
            resume = request.FILES.get("Resume")
            cover_letter = request.FILES.get("CoverLetter")

            if resume:
                candidate.Resume = resume

            if cover_letter:
                candidate.CoverLetter = cover_letter

            candidate.save()

            return Response(api_json_response_format(True, "Candidate updated successfully with files.", 200, {}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error during candidate update. {str(e)}", 500, {}), status=200)

class CandidateExcelExportView(APIView):
    def get(self, request):
        try:
            candidates = Candidate.objects.select_related("Req_id_fk").all()

            if not candidates.exists():
                return Response(api_json_response_format(
                    False,
                    "No candidates to export.",
                    404,
                    {}
                ), status=200)

            # Create Excel workbook
            wb = openpyxl.Workbook()
            ws = wb.active
            ws.title = "Candidate Details"

            headers = [
                "Candidate ID", "Candidate First Name", "Candidate Last Name", "Requisition ID", "Applied Position",
                "Job Description URL", "Resume URL", "Cover Letter URL", "Current Stage",
                "Next Stage", "Time in Stage", "Overall Stage", "Final Stage",
                "Source", "Score", "Phone Number"
            ]
            ws.append(headers)

            for cell in ws[1]:
                cell.font = Font(bold=True)

            for candidate in candidates:
                jd = candidate.Req_id_fk.posting_details.internal_job_description if getattr(candidate.Req_id_fk, "posting_details", None) else None
                jd_url = request.build_absolute_uri(f"/api/candidates/{candidate.CandidateID}/jd/") if jd else "N/A"

                resume_url = request.build_absolute_uri(settings.MEDIA_URL + "resumes/" + quote(str(candidate.Resume))) if candidate.Resume else "N/A"
                cover_url = request.build_absolute_uri(settings.MEDIA_URL + "resumes/" + quote(str(candidate.CoverLetter))) if candidate.CoverLetter else "N/A"

                stage = CandidateInterviewStages.objects.filter(candidate_id=candidate.CandidateID).order_by('-interview_date').first()
                time_in_stage = f"{(datetime.now().date() - stage.interview_date).days} days" if stage and stage.interview_date else "N/A"
                current_stage = stage.interview_stage if stage else "N/A"

                applied_position = candidate.Req_id_fk.position_information.job_position if candidate.Req_id_fk and hasattr(candidate.Req_id_fk, "position_information") else "N/A"

                ws.append([
                    candidate.CandidateID,
                    candidate.candidate_first_name or "N/A",
                    candidate.candidate_last_name or "N/A",
                    candidate.Req_id_fk.RequisitionID if candidate.Req_id_fk else "N/A",
                    applied_position,
                    jd_url,
                    resume_url,
                    cover_url,
                    current_stage,
                    "N/A",  # Placeholder for Next Stage
                    time_in_stage,
                    candidate.Result or "N/A",
                    candidate.Final_rating if candidate.Final_rating is not None else "N/A",
                    candidate.Source or "N/A",
                    candidate.Score or "N/A",
                    candidate.Phone_no or "N/A"
                ])

            # Return as downloadable Excel file
            response = HttpResponse(
                content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            )
            response['Content-Disposition'] = 'attachment; filename="candidate_details.xlsx"'
            wb.save(response)
            return response

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error exporting Excel. {str(e)}",
                500,
                {}
            ), status=200)


class CandidateAllRequisitionsView(APIView):
    def get(self, request):
        try:
            candidates = Candidate.objects.select_related("Req_id_fk").all()

            if not candidates.exists():
                return Response(api_json_response_format(False, "No candidate records found.", 404, {}), status=200)

            candidate_data = []
            for candidate in candidates:
                serializer = CandidateDetailWithInterviewSerializer(candidate)
                serialized_data = serializer.data

                # Optional cleanup: remove unused interview_stages field
                serialized_data.pop("interview_stages", None)

                candidate_data.append(serialized_data)

            return Response(api_json_response_format(True, "All candidate details retrieved successfully.", 200, candidate_data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error fetching all candidate data. {str(e)}", 500, {}), status=200)




class CandidateInterviewDetailView(APIView):
    def post(self, request):
        try:
            req_id = request.data.get("req_id")

            if not req_id:
                return Response(api_json_response_format(False, "req_id is required.", 400, {}), status=200)

            candidates = Candidate.objects.filter(Req_id_fk=req_id)

            if not candidates.exists():
                return Response(api_json_response_format(False, "No candidates found for the given req_id.", 404, {}), status=200)

            # Only include candidates with interview stages or skip the field later
            candidate_data = []
            for candidate in candidates:
                interview_exists = CandidateInterviewStages.objects.filter(candidate_id=candidate.CandidateID).exists()
                serializer = CandidateDetailWithInterviewSerializer(candidate)
                serialized_data = serializer.data

                if interview_exists:
                    candidate_data.append(serialized_data)
                else:
                    # 🔍 Remove empty interview_stages
                    serialized_data.pop("interview_stages", None)
                    candidate_data.append(serialized_data)

            return Response(api_json_response_format(True, "Full candidate details retrieved successfully.", 200, candidate_data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error fetching candidate details. {str(e)}", 500, {}), status=200)


# class BulkUploadResumeView(APIView):
#     parser_classes = (MultiPartParser, FormParser)

#     def post(self, request, *args, **kwargs):
#         try:
#             req_id = request.data.get("req_id")
#             files = request.FILES.getlist("files")

#             if not files:
#                 return Response(api_json_response_format(
#                     False, "No files were uploaded.", 400, {}
#                 ), status=200)

#             try:
#                 job_req = JobRequisition.objects.get(RequisitionID=req_id)
#             except JobRequisition.DoesNotExist:
#                 return Response(api_json_response_format(
#                     False, "Invalid requisition ID.", 400, {}
#                 ), status=200)

#             file_req_pairs = [(file, job_req) for file in files]
#             num_workers = min(len(files), os.cpu_count())

#             with ThreadPoolExecutor(max_workers=num_workers) as executor:
#                 candidates = list(executor.map(process_resume, file_req_pairs))

#             Candidate.objects.bulk_create(candidates, batch_size=100)

#             return Response(api_json_response_format(
#                 True,
#                 f"{len(candidates)} resumes processed and candidates stored successfully.",
#                 200,
#                 {"processed_count": len(candidates)}
#             ), status=200)

#         except Exception as e:
#             return Response(api_json_response_format(
#                 False,
#                 "Failed to process bulk resume upload. " + str(e),
#                 500,
#                 {}
#             ), status=200)


class BulkUploadResumeView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        try:
            req_id = request.data.get("req_id")
            files = request.FILES.getlist("files")
            Source = request.data.get("Source")

            if not req_id:
                return Response(api_json_response_format(
                    False, "Requisition ID is required.", 400, {}
                ), status=200)

            if not files:
                return Response(api_json_response_format(
                    False, "No files uploaded.", 400, {}
                ), status=200)

            try:
                job_req = JobRequisition.objects.get(RequisitionID=req_id)
            except JobRequisition.DoesNotExist:
                return Response(api_json_response_format(
                    False, "Invalid Requisition ID.", 400, {}
                ), status=200)

            # ✅ Generate randomized candidate data
            candidates = []
            SOURCE_OPTIONS = ["LinkedIn", "Referral", "Job Board", "Walk-In", "Campus Drive", "Employee Network"]

            for i, file in enumerate(files, start=1):
                unique_id = random.randint(1000, 9999)
                random_source = random.choice(SOURCE_OPTIONS)
                first_name = f"CandidateFirst{unique_id}"
                last_name = f"CandidateLast{unique_id}"

                candidate = Candidate(
                    candidate_first_name=first_name,
                    candidate_last_name=last_name,
                    Email=f"candidate{unique_id}@gmail.com",
                    Req_id_fk=job_req,
                    Resume=file.name,
                    CoverLetter=f"This is a sample cover letter for candidate{unique_id}.",
                    Phone_no = "9999999999",
                    Source=Source  # ✅ Injected random source
                )
                candidates.append(candidate)


            with transaction.atomic():
                Candidate.objects.bulk_create(candidates, batch_size=100)

            return Response(api_json_response_format(
                True,
                f"{len(candidates)} resumes uploaded and candidates stored successfully.",
                200,
                {"uploaded_count": len(candidates)}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Failed to upload resumes. {str(e)}",
                500,
                {}
            ), status=200)


# def extract_info_from_text(text):
#     """Attempts AI-based name & email extraction, with fallback regex."""
#     prompt = f"""
#     Extract only the full name and email address from this resume.
#     Return data in JSON format: 
#     {{
#         "name": "[Full Name]",
#         "email": "[Email Address]"
#     }}
#     Resume Content: {text}
#     """
#     # ollama_model = OllamaLLM(base_url='http://ollama:11434', model='ats_model')
#     # response = ollama.chat(model='ats_model', messages=[{"role": "user", "content": prompt}])
#     # ai_output = response['message']['content']
#     # ai_output = ollama_model.invoke(prompt)
#     # return response.strip()
#     # Print AI response for debugging
#     try:
#         ai_output = ollama_model.invoke(prompt)
#     except Exception as e:
#         print("Ollama Error:", e)

#     print("AI Response:\n", ai_output)

#     # Try extracting using AI response JSON
#     name_match = re.search(r'"name":\s*"([^"]+)"', ai_output)
#     email_match = re.search(r'"email":\s*"([^"]+)"', ai_output)

#     if name_match and email_match:
#         return name_match.group(1), email_match.group(1)

#     # Fallback regex extraction if AI fails
#     name_fallback = re.search(r"Name:\s*(.*)", text)
#     email_fallback = re.search(r"Email:\s*([\w\.-]+@[\w\.-]+)", text)

#     name = name_fallback.group(1) if name_fallback else "Unknown"
#     email = email_fallback.group(1) if email_fallback else "Not found"

#     return name, email

# def process_resume(file_req_tuple):
#     file, req_id = file_req_tuple

#     os.makedirs(RESUME_STORAGE_FOLDER, exist_ok=True)

#     file_path = os.path.join(RESUME_STORAGE_FOLDER, file.name)
#     with open(file_path, "wb") as f:
#         f.write(file.read())

#     text = extract_text_from_pdf(file)
#     name, email = extract_info_from_text(text)

#     return Candidate(
#         Name=name,
#         Email=email,
#         Resume=file_path,
#         Req_id_fk =req_id  # Set FK using ID to avoid query overhead
#     )


# class BulkUploadResumeView(APIView):
#     parser_classes = (MultiPartParser, FormParser)

#     def post(self, request, *args, **kwargs):
#         try:
#             req_id = request.data.get("req_id")
#             files = request.FILES.getlist("files")

#             if not files:
#                 return Response(api_json_response_format(
#                     False,
#                     "No files were uploaded.",
#                     400,
#                     {}
#                 ), status=200)
#             try:
#                 job_req = JobRequisition.objects.get(pk=req_id)
#                 print(job_req)
#             except JobRequisition.DoesNotExist:
#                 return Response(api_json_response_format(
#                     False, "Invalid requisition ID.", 400, {}
#                 ), status=200)

#             file_req_pairs = [(file, job_req) for file in files]
#             num_workers = min(len(files), os.cpu_count())

#             with ThreadPoolExecutor(max_workers=num_workers) as executor:
#                 candidates = list(executor.map(process_resume, file_req_pairs))

#             Candidate.objects.bulk_create(candidates, batch_size=100)

#             return Response(api_json_response_format(
#                 True,
#                 f"{len(candidates)} resumes processed and candidates stored successfully.",
#                 200,
#                 {"processed_count": len(candidates)}
#             ), status=200)

#         except Exception as e:
#             return Response(api_json_response_format(
#                 False,
#                 "Failed to process bulk resume upload. " + str(e),
#                 500,
#                 {}
            # ), status=200)

# model = SentenceTransformer("models/paraphrase-MiniLM-L6-v2")
# model.save("models/paraphrase-MiniLM-L6-v2")  # Save it locally
# print("Model saved to local folder.")


# def get_matching_score(job_description, resume_text, resume_name):
#     job_embedding = model.encode(job_description, convert_to_tensor=True)
#     resume_embedding = model.encode(resume_text[:2000], convert_to_tensor=True)
#     similarity = util.pytorch_cos_sim(job_embedding, resume_embedding).item()
#     percentage = round(similarity * 100)

#     return {
#         "resume_name": resume_name,
#         "percentage": percentage
#     }


# def extract_text_from_pdf(uploaded_file):
#     reader = pdf.PdfReader(uploaded_file)
#     text = ""
#     for page in reader.pages:
#         text += str(page.extract_text())
#     return text


# class ResumeMatchingAPI(APIView):
#     parser_classes = (MultiPartParser, FormParser)

#     def post(self, request):
#         try:
#             job_description = request.data.get('job_description')
#             uploaded_files = request.FILES.getlist('resumes')

#             if not job_description or not uploaded_files:
#                 return Response(api_json_response_format(
#                     False, "Missing job description or resume files.", 400, {}
#                 ), status=200)

#             results = []
#             for uploaded_file in uploaded_files:
#                 resume_text = extract_text_from_pdf(uploaded_file)
#                 score = get_matching_score(job_description, resume_text, uploaded_file.name)
#                 results.append(score)

#             return Response(api_json_response_format(
#                 True, "Matching scores calculated successfully!", 200, {"matching_scores": results}
#             ), status=200)

#         except Exception as e:
#             return Response(api_json_response_format(
#                 False, "Error while processing resumes. " + str(e), 500, {}
#             ), status=200)

class CandidateSubmissionViewSet(viewsets.ModelViewSet):
    queryset = CandidateSubmission.objects.all()
    serializer_class = CandidateSubmissionSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            submission = serializer.save()
            return Response(api_json_response_format(
                True,
                "Candidate submission saved successfully.",
                200,
                self.get_serializer(submission).data
            ), status=200)

        return Response(api_json_response_format(
            False,
            "Validation error.",
            400,
            serializer.errors
        ), status=200)


    @action(detail=False, methods=["POST"],url_path="get-submissions-by-candidate-id")
    def get_submissions_by_candidate_id(self, request):
        candidate_id = request.data.get("candidate_id")
        if not candidate_id:
            return Response(api_json_response_format(
                False, "Candidate ID is required.", 400, {}
            ), status=200)

        submissions = CandidateSubmission.objects.filter(candidate_id=candidate_id)
        if not submissions.exists():
            return Response(api_json_response_format(
                False, "No submissions found for this candidate.", 404, {}
            ), status=200)

        serializer = self.get_serializer(submissions, many=True)
        return Response(api_json_response_format(
            True, "Submissions retrieved successfully.", 200, serializer.data
        ), status=200)

class CandidateDetailView(APIView):
    def post(self, request):
        try:
            candidate_id = request.data.get("candidate_id")
            if not candidate_id:
                return Response(api_json_response_format(False, "Missing candidate_id", 400, {}), status=200)

            candidate = Candidate.objects.select_related("Req_id_fk__HiringManager").get(pk=candidate_id)
            requisition = candidate.Req_id_fk

            # Serialize base candidate data
            serializer = CandidateSerializer(candidate)
            candidate_data = serializer.data

            # Enrich with HR name and position title
            candidate_data["position_title"] = requisition.PositionTitle if requisition else "Not Provided"
            candidate_data["hr_name"] = requisition.HiringManager.Name if requisition and requisition.HiringManager else "Unknown"
            
            # Format profile creation date
            raw_created = candidate.ProfileCreated
            candidate_data["ProfileCreated"] = raw_created.strftime("%Y-%m-%d") if raw_created else None

            # Add interview_design_id based on req_id
            interview_design = InterviewDesignScreen.objects.filter(req_id=requisition.RequisitionID).first()
            candidate_data["interview_design_id"] = interview_design.interview_design_id if interview_design else None

            return Response(api_json_response_format(
                True,
                "Candidate detail retrieved",
                200,
                candidate_data
            ), status=200)

        except Candidate.DoesNotExist:
            return Response(api_json_response_format(False, "Candidate not found", 404, {}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, str(e), 500, {}), status=200)



class CandidateListByRequisitionView(APIView):
    def post(self, request):
        try:
            requisition_id = request.data.get("requisition_id")
            if not requisition_id:
                return Response(api_json_response_format(False, "Missing requisition_id", 400, {}), status=200)

            candidates = Candidate.objects.filter(Req_id_fk__RequisitionID=requisition_id)
            data = [
                {"id": c.CandidateID, "name": f"{c.candidate_first_name} {c.candidate_last_name}"}
                for c in candidates
            ]
            return Response(api_json_response_format(True, "Candidates fetched successfully", 200, data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False, str(e), 500, {}), status=200)




class CandidateScreeningView(APIView):
    def get(self, request):
        candidates = Candidate.objects.select_related("Req_id_fk__Planning_id").all()
        response_data = []

        for candidate in candidates:
            reviews = CandidateReview.objects.filter(CandidateID=candidate).values(
                "ParameterDefined", "Guidelines", "MinimumQuestions", "ActualRating", "Feedback"
            )

            approvals = CandidateApproval.objects.filter(candidate=candidate).values(
                "approver__email", "role", "decision"
            )

            # Resume URL
            resume_path = candidate.Resume
            resume_url = request.build_absolute_uri(settings.MEDIA_URL + "resumes/" + str(resume_path)) if resume_path else "N/A"

            # Cover Letter URL
            cover_path = candidate.CoverLetter
            cover_url = request.build_absolute_uri(settings.MEDIA_URL + "resumes/" + str(cover_path)) if cover_path else "N/A"

            # JD HTML URL (if available)
            jd_url = "N/A"
            jd_html_content = "N/A"
            if candidate.Req_id_fk and hasattr(candidate.Req_id_fk, "posting_details"):
                jd_html = candidate.Req_id_fk.posting_details.internal_job_description
                if jd_html:
                    jd_filename = f"jd_candidate_{candidate.pk}.html"
                    jd_dir = os.path.join(settings.MEDIA_ROOT, "jd_descriptions")
                    os.makedirs(jd_dir, exist_ok=True)
                    jd_path = os.path.join(jd_dir, jd_filename)

                    with open(jd_path, "w", encoding="utf-8") as jd_file:
                        jd_file.write(jd_html)

                    jd_url = request.build_absolute_uri(settings.MEDIA_URL + "jd_descriptions/" + jd_filename)
                    jd_html_content = jd_html
            
            stage = CandidateInterviewStages.objects.filter(candidate_id=candidate.CandidateID).order_by('-interview_date').first()
            time_in_stage = f"{(datetime.now().date() - stage.interview_date).days} days" if stage and stage.interview_date else "N/A"
            current_stage = stage.interview_stage if stage else "N/A"

            applied_position = candidate.Req_id_fk.position_information.job_position if candidate.Req_id_fk and hasattr(candidate.Req_id_fk, "position_information") else "N/A"

            candidate_info = {
                "candidate_id": candidate.pk,
                "req_id": candidate.Req_id_fk.RequisitionID if candidate.Req_id_fk else None,
                "planning_id": candidate.Req_id_fk.Planning_id.hiring_plan_id if candidate.Req_id_fk and candidate.Req_id_fk.Planning_id else None,
                "client_name": candidate.Req_id_fk.company_client_name if candidate.Req_id_fk else None,
                "final_rating": candidate.Final_rating,
                "final_feedback": candidate.Feedback,
                "result": candidate.Result,
                "applied_position": applied_position,
                "current_stage": current_stage,
                "time_in_stage": time_in_stage,
                "reviews": list(reviews),
                "approvals": list(approvals),
                "resume_url": resume_url,
                "cover_letter_url": cover_url,
                "JD_url": jd_url,
                "JD": jd_html_content

            }

            response_data.append(candidate_info)

        return Response(api_json_response_format(
            True,
            "All candidate screening data retrieved successfully",
            200,
            response_data
        ), status=200)


    def put(self, request):
        candidate_id = request.data.get("candidate_id")

        if not candidate_id:
            return Response(api_json_response_format(
                False, "Missing candidate_id in request body", 400, {}
            ), status=200)

        try:
            candidate = Candidate.objects.get(pk=candidate_id)
        except Candidate.DoesNotExist:
            return Response(api_json_response_format(
                False, "Candidate not found", 404, {}
            ), status=200)

        reviews_data = request.data.get("reviews", [])
        final_rating = request.data.get("final_rating")
        final_feedback = request.data.get("final_feedback")
        result = request.data.get("result")

        try:
            with transaction.atomic():
                # Delete existing reviews first
                CandidateReview.objects.filter(CandidateID=candidate).delete()

                # Insert updated reviews
                updated_reviews = [
                    CandidateReview(
                        CandidateID=candidate,
                        ParameterDefined=review.get("ParameterDefined"),
                        Guidelines=review.get("Guidelines"),
                        MinimumQuestions=review.get("MinimumQuestions"),
                        ActualRating=review.get("ActualRating"),
                        Feedback=review.get("Feedback")
                    )
                    for review in reviews_data
                ]
                CandidateReview.objects.bulk_create(updated_reviews)

                # Update candidate fields
                if final_rating is not None:
                    candidate.Final_rating = final_rating
                if final_feedback:
                    candidate.Feedback = final_feedback
                if result:
                    candidate.Result = result
                candidate.save()

            return Response(api_json_response_format(
                True, "Candidate screening data updated successfully", 200, {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, f"Error updating screening data: {e}", 500, {}
            ), status=200)


    def post(self, request):
        candidate_id = request.data.get("candidate_id")

        if not candidate_id:
            return Response(api_json_response_format(
                False, "Missing candidate_id in request body", 400, {}
            ), status=200)

        try:
            candidate = Candidate.objects.get(pk=candidate_id)
        except Candidate.DoesNotExist:
            return Response(api_json_response_format(
                False, "Candidate not found", 404, {}
            ), status=200)

        reviews_data = request.data.get("reviews", [])
        final_rating = request.data.get("final_rating")
        final_feedback = request.data.get("final_feedback")
        result = request.data.get("result")

        review_instances = [
            CandidateReview(
                CandidateID=candidate,
                ParameterDefined=review.get("ParameterDefined"),
                Guidelines=review.get("Guidelines"),
                MinimumQuestions=review.get("MinimumQuestions"),
                ActualRating=review.get("ActualRating"),
                Feedback=review.get("Feedback")
            )
            for review in reviews_data
        ]

        try:
            with transaction.atomic():
                CandidateReview.objects.bulk_create(review_instances)

                if final_rating is not None:
                    candidate.Final_rating = final_rating
                if final_feedback:
                    candidate.Feedback = final_feedback
                if result:
                    candidate.Result = result
                candidate.save()

                # 🔁 Insert CandidateApproval records for assigned approvers
                hiring_plan_id = candidate.Req_id_fk.Planning_id.hiring_plan_id
                approvers = Approver.objects.filter(hiring_plan_id=hiring_plan_id, set_as_approver__in=["Yes", "Maybe"])

                approval_instances = [
                    CandidateApproval(
                        candidate=candidate,
                        approver=approver,
                        role=approver.role,
                        decision="Awaiting"
                    )
                    for approver in approvers
                ]
                CandidateApproval.objects.bulk_create(approval_instances)

            return Response(api_json_response_format(
                True, "Screening data submitted successfully", 200, {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, f"Error saving screening data: {e}", 500, {}
            ), status=200)


class GenerateOfferView(APIView):
    def post(self, request):
        try:
            candidate_id = request.data.get("candidate_id")
            requisition_id = request.data.get("requisition_id")

            if not candidate_id or not requisition_id:
                return Response(api_json_response_format(
                    False,
                    "Missing candidate_id or requisition_id",
                    400,
                    {}
                ), status=200)

            approvals = CandidateApproval.objects.select_related("approver").filter(
                candidate_id=candidate_id,
                approver__requisition__RequisitionID=requisition_id
            )

            response_data = []
            for approval in approvals:
                approver = approval.approver
                response_data.append({
                    "role": approver.role,
                    "approver_name": f"{approver.first_name} {approver.last_name}",
                    "email": approver.email,
                    "decision": approval.decision,
                    "comment": approval.comment,
                    "reviewed_at": approval.reviewed_at.strftime("%Y-%m-%d %H:%M") if approval.reviewed_at else None
                })

            return Response(api_json_response_format(
                True,
                "Approver status retrieved successfully.",
                200,
                response_data
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error retrieving approver status: {str(e)}",
                500,
                {}
            ), status=200)

# class GenerateOfferView(APIView):
#     def post(self, request):
#         try:
#             requisition_id = request.data.get("requisition_id")
#             candidate_id = request.data.get("candidate_id")

#             if not requisition_id:
#                 return Response(api_json_response_format(False, "Missing requisition_id", 400, {}), status=200)

#             queryset = Candidate.objects.filter(Req_id_fk__RequisitionID=requisition_id)

#             if candidate_id:
#                 queryset = queryset.filter(CandidateID=candidate_id)

#             response_data = []
#             for candidate in queryset:
#                 job_req = candidate.Req_id_fk
#                 hm_approved = "Yes" if job_req.HiringManager and job_req.HiringManager.Approved else "No"
#                 fpna_approved = "Yes" if job_req.CommentFromBusinessOps != "" else "No"  # simple proxy

#                 offer_status = "Offer Sent" if candidate.Result == "Offer Accepted" else (
#                     "Need to Generate" if candidate.Result in ["Shortlisted", None] else "Unknown"
#                 )

#                 response_data.append({
#                     "req_id": job_req.RequisitionID,
#                     "client_id": job_req.client_id,
#                     "client_name": job_req.company_client_name,
#                     "candidate_id": candidate.CandidateID,
#                     "candidate_first_name": candidate.candidate_first_name,
#                     "candidate_last_name": candidate.candidate_last_name,
#                     "hm_approver": hm_approved,
#                     "fpna_approver": fpna_approved,
#                     "generate_offer": ["Generate", "Preview"],
#                     "status": offer_status,
#                     "actions": ["Edit", "Delete"]
#                 })

#             return Response(api_json_response_format(True, "Offer data generated", 200, response_data), status=200)

#         except Exception as e:
#             return Response(api_json_response_format(False, str(e), 500, {}), status=200)


# class JobRequisitionViewSetget(viewsets.ReadOnlyModelViewSet):
#     queryset = JobRequisition.objects.all()
#     serializer_class = JobRequisitionSerializerget

#     def list(self, request):
#         try:
#             queryset = self.filter_queryset(self.get_queryset())
#             serializer = self.get_serializer(queryset, many=True)
#             return Response({
#                 "data": serializer.data,
#                 "status_code": 200
#             })
#         except Exception as e:
#             return Response({
#                 "error": "Error fetching job requisitions",
#                 "details": str(e),
#                 "status_code": 500
#             }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def extract_requested_fields(queryset, selected_fields, field_map):
    model_fields = set()
    field_lookup = {}  # display_name → actual ORM field path(s)

    for display in selected_fields:
        mapping = field_map.get(display)
        if isinstance(mapping, str):
            model_fields.add(mapping)
            field_lookup[display] = [mapping]
        elif isinstance(mapping, list):
            model_fields.update(mapping)
            field_lookup[display] = mapping
        else:
            field_lookup[display] = []

    data = list(queryset.values(*model_fields))
    result = []

    for row in data:
        flat = {}
        for display, fields in field_lookup.items():
            if fields:
                values = [row.get(f) for f in fields if f in row]
                flat[display] = values[0] if len(values) == 1 else values if any(values) else None
            else:
                flat[display] = None
        result.append(flat)

    return result

class JobRequisitionFlatViewSet(viewsets.ViewSet):
    def create(self, request):
        try:
            selected_fields = request.data.get("fields", [])
            user_role = request.data.get("user_role")  # 👈 get the role from request

            if not isinstance(selected_fields, list) or not selected_fields:
                return Response(
                    api_json_response_format(False, "Missing or invalid 'fields' parameter.", 400, {}),
                    status=200
                )

            queryset = JobRequisition.objects.select_related("position_information", "Planning_id").order_by("-RequisitionID")

            # 🔍 Filter 'Incomplete form' based on user_role
            if str(user_role) != "1":
                queryset = queryset.exclude(Status="Incomplete form")

            result_data = extract_requested_fields(queryset, selected_fields, DISPLAY_TO_MODEL_FIELD)

            return Response(
                api_json_response_format(True, "Dynamic field data fetched successfully!", 200, {
                    "data": result_data,
                    "selected_fields": selected_fields
                }),
                status=200
            )

        except Exception as e:
            return Response(
                api_json_response_format(False, "Failed to retrieve dynamic field data: " + str(e), 500, {}),
                status=200
            )


class JobRequisitionPublicViewSet(viewsets.ViewSet):
    def list(self, request):
        try:
            requisitions = JobRequisition.objects.prefetch_related(
                'interview_team', 'teams'
            ).select_related('position_information', 'billing_details', 'posting_details')

            data = []
            for obj in requisitions:
                internal_title = getattr(obj.position_information, "internal_title", "") if obj.position_information else ""
                location = getattr(obj.position_information, "location", "") if obj.position_information else ""
                template_name = f"{internal_title} - {location}".strip(" -")

                job_template_data = JobTemplateSerializer({
                    "requisition_details": getattr(obj, "position_information", None),
                    "billing": getattr(obj, "billing_details", None),
                    "posting": getattr(obj, "posting_details", None),
                    "interviewers": obj.interview_team.all(),
                    "functional_teams": obj.teams.all(),
                }).data

                job_template_data["template_name"] = template_name  # Injecting display label
                data.append(job_template_data)


            return Response(api_json_response_format(
                True,
                "Job templates retrieved successfully!",
                200,
                {"job_template": data}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error while fetching data for template"+str(e),
                500,
                {}
            ), status=200)

class JobRequisitionViewSet(viewsets.ModelViewSet):
    queryset = JobRequisition.objects.select_related("HiringManager").all()
    serializer_class = JobRequisitionSerializer

    def create(self, request, *args, **kwargs):
        try:
            serializer = JobRequisitionSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            job_requisition = serializer.save()

            return Response(api_json_response_format(True, "Initial requisition created.", 200, {
                "RequisitionID": job_requisition.RequisitionID
                # "Planning_id": job_requisition.Planning_id.hiring_plan_id
            }), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Failed to create initial requisition. " + str(e), 500, {}), status=200)
    
    @action(detail=False, methods=['put'], url_path='update-requisition')
    def update_requisition(self, request):
        try:
            requisition_id = request.data.get("requisition_id")
            user_role = request.data.get("user_role")

            if user_role != 1:
                return Response(api_json_response_format(False, "Only Hiring Managers can update requisitions.", 403, {}), status=200)
            if not requisition_id:
                return Response(api_json_response_format(False, "Requisition ID is required.", 400, {}), status=200)

            instance = get_object_or_404(JobRequisition, RequisitionID=requisition_id)

            # 🔧 Normalize posting_details fields if they are arrays
            fixed_payload = request.data.copy()
            posting_block = fixed_payload.get("posting_details", {})

            def normalize_to_string(value):
                return ", ".join(value) if isinstance(value, list) else value

            posting_block["experience"] = normalize_to_string(posting_block.get("experience"))
            posting_block["designation"] = normalize_to_string(posting_block.get("designation"))
            posting_block["job_region"] = normalize_to_string(posting_block.get("job_region"))
            posting_block["qualification"] = normalize_to_string(posting_block.get("qualification"))

            fixed_payload["posting_details"] = posting_block

            serializer = self.get_serializer(instance, data=fixed_payload, partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()

            return Response(api_json_response_format(True, "Job requisition updated successfully!", 200, {
                "requisition_id": serializer.instance.RequisitionID
            }), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error while updating requisition. {str(e)}", 500, {}), status=200)
    @action(detail=False, methods=['delete'], url_path='delete-requisition')
    def delete_requisition(self, request):
        try:
            user_role = request.data.get("user_role")
            requisition_id = request.data.get("requisition_id")

            if user_role != 1:
                return Response(api_json_response_format(False, "Only Hiring Managers can delete requisitions.", 403, {}), status=200)
            if not requisition_id:
                return Response(api_json_response_format(False, "requisition_id is required.", 400, {}), status=200)

            try:
                requisition = JobRequisition.objects.get(RequisitionID=requisition_id)
            except JobRequisition.DoesNotExist:
                return Response(api_json_response_format(False, "Job requisition not found.", 404, {}), status=200)

            requisition.delete()
            return Response(api_json_response_format(True, "Job requisition deleted successfully!", 200, {}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error while deleting requisition. " + str(e), 500, {}), status=200)

    @action(detail=False, methods=["post"], url_path="list-requisitions")
    def list_requisitions(self, request):
        try:
            user_role = request.data.get("user_role")

            if user_role not in [1, 2, 3]:
                return Response(api_json_response_format(False, "Unauthorized", 403, {}), status=200)

            # 🔍 Role-based filtering + ordering (latest first)
            if user_role == 2:
                queryset = JobRequisition.objects.filter(Status="Approved").order_by("-RequisitionID")
            elif user_role == 3:
                queryset = JobRequisition.objects.all().order_by("-RequisitionID")
            else:  # Hiring Manager
                queryset = JobRequisition.objects.filter(HiringManager=request.user).order_by("-RequisitionID")

            current_date = datetime.now(dt_timezone.utc).date()

            data = []
            for requisition in queryset:
                info = getattr(requisition, "position_information", None)
                billing = getattr(requisition, "billing_details", None)

                start_date = billing.contract_start_date if billing else None
                end_date = billing.contract_end_date if billing else None
                age = (current_date - start_date).days if start_date else "N/A"
                age = max(age, 0) if isinstance(age, int) else "N/A"
                planning_obj = getattr(requisition, "Planning_id", None)
                planning_id = planning_obj.hiring_plan_id if planning_obj else "Not Provided"

                data.append({
                    "PlanningID": planning_id,
                    "RequisitionID": requisition.RequisitionID,
                    "ClientName": requisition.company_client_name or "Not Provided",
                    "ClientID": requisition.client_id or "Not Provided",
                    "JobTitle": requisition.PositionTitle,
                    "HiringManager": getattr(requisition.HiringManager, "Name", "Unknown"),
                    "JobPosting": getattr(requisition, "PostingSource", "Not Specified"),
                    "StartDate": start_date,
                    "DueDate": end_date,
                    "HiringStatus": requisition.Status,
                    "Age(Days)": age
                })

            return Response(api_json_response_format(True, "Job requisitions retrieved successfully!", 200, data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error fetching job requisitions. {str(e)}", 500, {}), status=200)

    @action(detail=False, methods=["POST"], url_path='approve_requisition')
    def update_requisition_status(self, request):
        try:
            user_role = request.data.get("user_role")
            req_data = request.data.get("req_data")

            if user_role != 3:
                return Response(api_json_response_format(
                    False,
                    "Only Business Ops can update requisition statuses.",
                    403,
                    {}
                ), status=200)

            if not isinstance(req_data, list):
                return Response(api_json_response_format(
                    False,
                    "req_data should be a list of requisition update objects.",
                    400,
                    {}
                ), status=200)

            updated = []
            not_found = []

            for item in req_data:
                req_id = item.get("req_id")
                new_status = item.get("status")
                comment = item.get("comment", "")

                if not req_id or not new_status:
                    continue  # skip incomplete entries

                try:
                    requisition = JobRequisition.objects.get(RequisitionID=req_id)
                    requisition.Status = new_status
                    requisition.CommentFromBusinessOps = comment
                    requisition.save()
                    updated.append(req_id)
                except JobRequisition.DoesNotExist:
                    not_found.append(req_id)
            decision = "approved" if new_status.lower() == "approved" else "rejected"
            login_url = "https://hiring.pixeladvant.com/"
            # requisition_url = f"https://yourdomain.com/requisitions/{requisition.pk}/details/"

            email_body = f"""
            Hi Team,

            Your Job Requisition '{requisition.RequisitionID}' has been {decision} by Business Ops.

            📌 Status: {new_status}
            📝 Comment: {comment or "No comments provided."}

            You can login to review the requisition status:
            🔗 Login: {login_url}

            Regards,
            Business Ops Team
            """

            send_mail(
                subject=f"Requisition '{requisition.RequisitionID}' {decision.capitalize()}",
                message=email_body,
                from_email='hiring@pixeladvant.com',
                recipient_list=['anand040593@gmail.com'],  # 🔄 Use requisition owner’s email if dynamic
                fail_silently=False,
            )

            return Response(api_json_response_format(
                True,
                "Requisitions updated successfully.",
                200,
                {
                    "updated": updated,
                    "not_found": not_found
                }
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error updating requisitions. {str(e)}",
                500,
                {}
            ), status=200)
    
    @action(detail=False, methods=["POST"])
    def get_approved_extra_details(self, request):
        try:
            user_role = request.data.get("user_role")

            if user_role not in [2, 3]:
                return Response(api_json_response_format(False, "Unauthorized access.", 403, {}), status=200)

            approved_ids = JobRequisition.objects.filter(Status="Approved").values_list("RequisitionID", flat=True)
            details = RequisitionDetails.objects.filter(requisition_id__in=approved_ids).order_by("requisition_id")

            data = [{
                "requisition_id": d.requisition_id,
                "internal_title": d.internal_title,
                "external_title": d.external_title,
                "position": d.job_position,
                "business_line": d.business_line,
                "business_unit": d.business_unit,
                "division": d.division,
                "department": d.department,
                "location": d.location,
                "geo_zone": d.geo_zone,
                "employee_group": d.employee_group,
                "employee_sub_group": d.employee_sub_group,
                "contract_start_date": d.contract_start_date.isoformat() if d.contract_start_date else "",
                "contract_end_date": d.contract_end_date.isoformat() if d.contract_end_date else "",
                "career_level": d.career_level,
                "band": d.band,
                "sub_band": d.sub_band,
                "primary_skills": d.primary_skills,
                "secondary_skills": d.secondary_skills,
                "mode_of_working": d.working_model,
                "requisition_type": d.requisition_type,
                "client_interview": d.client_interview,
                "required_score": d.required_score,
                "onb_coordinator": d.onb_coordinator,
                "onb_coordinator_team": d.onb_coordinator_team,
                "isg_team": d.isg_team,
                "interviewer_teammate_employee_id": d.interviewer_teammate_employee_id
            } for d in details]

            return Response(api_json_response_format(True, "Extra requisition details retrieved successfully!", 200, data), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, "Error retrieving extra requisition details."+ str(e), 500, {}), status=200)

    @action(detail=False, methods=["POST"])
    def get_requisition_by_id(self, request):
        try:
            requisition_id = request.data.get("req_id")
            if not requisition_id:
                return Response(api_json_response_format(False, "Requisition ID is required.", 400, {}), status=200)

            instance = get_object_or_404(JobRequisition, RequisitionID=requisition_id)

            # Safely access related objects
            details = getattr(instance, "position_information", None)
            billing = getattr(instance, "billing_details", None)
            posting = getattr(instance, "posting_details", None)
            asset = getattr(instance, "asset_details", None)

            response_payload = {
                # "user_role": request.data.get("user_role", "Not Provided"),  # ⬅️ added fallback
                "Planning_id": getattr(instance.Planning_id, "hiring_plan_id", "Not Provided") if instance.Planning_id else "Not Provided",
                "HiringManager": getattr(instance.HiringManager, "Name", "Unknown") if instance.HiringManager else "Unknown",
                "PositionTitle": instance.PositionTitle or "Not Provided",
                "requisition_id": instance.RequisitionID or "Not Provided",

                "position_information": {
                    "internal_title": getattr(details, "internal_title", ""),
                    "external_title": getattr(details, "external_title", ""),
                    "job_position": getattr(details, "job_position", ""),
                    "company_client_name": instance.company_client_name or "",
                    "business_unit": getattr(details, "business_unit", ""),
                    "business_line": getattr(details, "business_line", ""),
                    "division": getattr(details, "division", ""),
                    "department": getattr(details, "department", ""),
                    "location": getattr(details, "location", ""),
                    "geo_zone": getattr(details, "geo_zone", ""),
                    "career_level": getattr(details, "career_level", ""),
                    "band": getattr(details, "band", ""),
                    "sub_band": getattr(details, "sub_band", ""),
                    "working_model": getattr(details, "working_model", ""),
                    "client_interview": "Yes" if getattr(details, "client_interview", "") == "Yes" else "No",
                    "requisition_type": getattr(details, "requisition_type", ""),
                    "date_of_requisition": instance.requisition_date,
                    "due_date_of_requisition": instance.due_requisition_date
                },

                "skills_required": {
                    "primary_skills": [s.strip() for s in getattr(details, "primary_skills", "").split(",")] if getattr(details, "primary_skills", "") else [],
                    "secondary_skills": [s.strip() for s in getattr(details, "secondary_skills", "").split(",")] if getattr(details, "secondary_skills", "") else []
                },

                "billing_details": {
                    "billing_type": getattr(billing, "billing_type", ""),
                    "billing_start_date": getattr(billing, "billing_start_date", ""),
                    "billing_end_date": getattr(billing, "billing_end_date", ""),
                    "contract_start_date": getattr(billing, "contract_start_date", ""),
                    "contract_end_date": getattr(billing, "contract_end_date", "")
                },

                "posting_details": {
                    "experience": [e.strip() for e in getattr(posting, "experience", "").split(",")] if getattr(posting, "experience", "") else [],
                    "qualification": [q.strip() for q in getattr(posting, "qualification", "").split(",")] if getattr(posting, "qualification", "") else [],
                    "designation": [d.strip() for d in getattr(posting, "designation", "").split(",")] if getattr(posting, "designation", "") else [],
                    "job_region": [r.strip() for r in getattr(posting, "job_region", "").split(",")] if getattr(posting, "job_region", "") else [],
                    "required_score": getattr(posting, "required_score", ""),
                    "internalDesc": getattr(posting, "internal_job_description", ""),
                    "externalDesc": getattr(posting, "external_job_description", ""),
                    "questions": [],  # Stub for future use
                    "Competencies": []  # Stub for future use
                },

                "asset_deatils": {  # matches incoming payload key
                    "laptop_type": getattr(asset, "laptop_type", ""),
                    "laptop_needed": "Yes" if getattr(asset, "laptop_needed", "") == "Yes" else "No",
                    "comments": getattr(asset, "comments", "")
                }
            }


            return Response(api_json_response_format(True, "Requisition retrieved successfully!", 200, response_payload), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error retrieving requisition. {str(e)}", 500, {}), status=200)


def get_matching_score(job_description, resume_text, resume_name):
    """Send job description and resume to Ollama model and get only the matching score"""
    prompt = f"""
    You are an AI-powered resume analysis agent.
    Given a job description, compare multiple resumes.
    
    For each resume, **ONLY return the JSON output**:
    
    {{
        "resume_name": "{resume_name}",
        "percentage": 90
    }}

    **DO NOT** provide additional analysis, explanations, keywords, or recommendations.
    
    Job Description: {job_description}
    Resume Text:{resume_text[:2000]} 

    """
    # response = ollama.chat(model='ats_model:latest', messages=[{"role": "user", "content": prompt}])
    # ai_output = response['message']['content']
    response = ollama_model.invoke(prompt)
    return response.strip()  # Remove unnecessary formatting

class ResumeMatchingAPI(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request):
        """Handles resume uploads and returns matching scores only"""
        try:
            job_description = request.data.get('job_description')
            uploaded_files = request.FILES.getlist('resumes')

            if not job_description or not uploaded_files:
                return Response(api_json_response_format(
                    False, "Missing job description or resume files.",400, {}
                ), status=200)

            results = []
            for uploaded_file in uploaded_files:
                resume_text = extract_text_from_pdf(uploaded_file)
                score = get_matching_score(job_description, resume_text, uploaded_file.name)
                results.append(score)

            return Response(api_json_response_format(
                True, "Matching scores calculated successfully!", 200, {"matching_scores": results}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, "Error while processing resumes."+ str(e), 500, {}
            ), status=200)

# def send_email():
#     send_mail(
#         'Job Requsition Added',
#         'Please verify and Approve the added job requsition.',
#         settings.EMAIL_HOST_USER,
#         ['anandsivakumar27@gmail.com'],
#         fail_silently=False,
#     )
# send_mail(
#     subject='Test Email',
#     message='This is a test email from Django using Zoho SMTP.',
#     from_email='hiring@pixeladvant.com',
#     recipient_list=['anand040593@gmail.com'],
#     fail_silently=False,
# )

    
def generate_jwt_token(user):
    """ Generate JWT Token """
    payload = {
        'user_id': user.UserID,
        'email': user.Email,
        'role': UserroleDetails.objects.get(RoleID=user.RoleID).RoleName,
        'exp': datetime.datetime.now() + datetime.timedelta(hours=12)  # Token expires in 1 hour
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')


@csrf_exempt
@api_view(['POST'])
def login_page(request):
    auth_header = request.headers.get("Authorization")

    if not auth_header or not auth_header.startswith("Basic "):
        return Response(api_json_response_format(False, "Authorization header missing or incorrect", 401, {}))

    try:
        _, encoded_credentials = auth_header.split(" ")
        decoded_credentials = base64.b64decode(encoded_credentials).decode("utf-8")
        username, password = decoded_credentials.split(":")
    except Exception as e:
        return Response(api_json_response_format(False, "Invalid credentials encoding. " + str(e), 401, {}))

    try:
        user_details = UserDetails.objects.get(Email=username)
        userrole = UserroleDetails.objects.get(RoleID=user_details.RoleID)

        if not check_password(password, user_details.PasswordHash):
            raise UserDetails.DoesNotExist  # reuse the same error logic

        user, created = User.objects.get_or_create(
            email=username,
            defaults={
                'username': username,
                'password': make_password(password)  # user should be able to sign-in via Django
            }
        )

        user = User.objects.get(email=username)
        refresh = RefreshToken.for_user(user)

        response_data = {
            'role': userrole.RoleName,
            'user_id':user_details.RoleID,
            'Name' :user_details.Name,
            'username': user.get_username(),
            'access': str(refresh.access_token),
            'refresh': str(refresh)
        }
        return Response(api_json_response_format(True, "Login successful", 200, response_data))

    except UserDetails.DoesNotExist:
        return Response(api_json_response_format(False, "Invalid username or password USER_NOT_FOUND", 400, {}))



@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    try:
        refresh_token = request.data.get("refresh")

        if not refresh_token:
            return Response(api_json_response_format(False, "Refresh token required for logout", 400, {}))

        token = RefreshToken(refresh_token)
        token.blacklist()

        return Response(api_json_response_format(True, "Logout successful. Token blacklisted.", 200, {}))

    except Exception as e:
        return Response(api_json_response_format(False, f"Error during logout: {str(e)}", 500, {}))
    
class ForgotPasswordView(APIView):
    def post(self, request):
        try:
            email = request.data.get("email")
            user = get_object_or_404(UserDetails, Email=email)

            reset_token = get_random_string(32)
            user.ResetToken = reset_token
            user.save()
            send_mail(
                subject='Test Email',
                message='This is a test email from Django using Zoho SMTP.',
                from_email='hiring@pixeladvant.com',
                recipient_list=['anand040593@gmail.com'],
                fail_silently=False,
            )
            # send_mail(
            #     "Password Reset Request",
            #     f"Your reset token is: {reset_token}",
            #     "noreply@example.com",
            #     [user.Email],
            #     fail_silently=False,
            # )

            return Response(api_json_response_format(
                True,
                "Reset token sent to email",
                200,
                {"email": user.Email}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error while sending reset token."+ str(e),500,
                {}
            ), status=200)

class ResetPasswordView(APIView):
    def post(self, request):
        try:
            reset_token = request.data.get("token")
            new_password = request.data.get("new_password")

            user = get_object_or_404(UserDetails, ResetToken=reset_token)
            user.PasswordHash = make_password(new_password)
            user.ResetToken = None
            user.save()

            return Response(api_json_response_format(
                True,
                "Password reset successful",
                200,
                {"email": user.Email}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error while resetting password."+ str(e),
                500,
                {}
            ), status=200)
        
class InterviewPlannerCalculation(APIView):
    def get(self, request):
        try:   
            plan_id = request.data.get('plan_id')
            req_id = request.data.get('req_id') 
            if  req_id:
                filters = {}
                if req_id:
                    filters['requisition_id'] = req_id

                queryset = InterviewPlanner.objects.filter(**filters)
                serializer = InterviewPlannerSerializer(queryset, many=True)            
                return Response(api_json_response_format(True,"Interview planning calculation",200,serializer.data), status=200)
            else:
                excluded_plan_ids = InterviewPlanner.objects.values_list('hiring_plan_id', flat=True)            
                filtered_overview = HiringPlan.objects.exclude(hiring_plan_id__in=excluded_plan_ids).values_list('hiring_plan_id', flat=True)            
                return Response(api_json_response_format(True,"Hiring Plan ID ",0,{"plan_id":filtered_overview}), status=status.HTTP_200_OK)
        except Exception as e:
            return Response(api_json_response_format(False,"Error in interview planning calculation get method "+str(e),500,{}), status=status.HTTP_200_OK)



    def post(self, request):
        try:
            plan_id = request.data.get('plan_id')
            req_id = request.data.get('req_id')
            if not req_id:
                return Response(api_json_response_format(False,"req_id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200) 
            filters = {}
            if plan_id:
                filters['hiring_plan_id'] = plan_id
            if req_id:
                filters['requisition_id'] = req_id

            queryset = InterviewPlanner.objects.filter(**filters)
            if queryset.exists():
                    return Response(api_json_response_format(True, "Already Bandwidth created "+plan_id+" and "+req_id+" ", status.HTTP_200_OK, {}), status=200)
            
            dead_line_days = int(request.data.get('dead_line_days'))
            offer_decline = int(request.data.get('offer_decline'))
            working_hours_per_day = int(request.data.get('working_hours_per_day'))
            no_of_roles_to_hire = int(request.data.get('no_of_roles_to_hire'))
            conversion_ratio = int(request.data.get('conversion_ratio'))
            # elimination = int(request.data.get('elimination'))  # currently unused
            avg_interviewer_time_per_week_hrs = int(request.data.get('avg_interviewer_time_per_week_hrs'))
            interview_round = int(request.data.get('interview_round'))
            interview_time_per_round = int(request.data.get('interview_time_per_round'))
            interviewer_leave_days = int(request.data.get('interviewer_leave_days'))
            no_of_month_interview_happens = int(request.data.get('no_of_month_interview_happens'))  # currently unused
            working_hrs_per_week = int(request.data.get('working_hrs_per_week'))

            required_candidate = int(no_of_roles_to_hire * conversion_ratio)
            decline_adjust_count = (required_candidate * offer_decline) / 100
            total_candidate_pipline = required_candidate + decline_adjust_count
            total_interviews_needed = total_candidate_pipline * interview_round
            total_interview_hrs = total_interviews_needed * interview_time_per_round
            total_interview_weeks = total_interview_hrs / working_hrs_per_week
            no_of_interviewer_need = total_interview_hrs / dead_line_days
            leave_adjustment = round(
                no_of_interviewer_need + (
                    ((interviewer_leave_days * avg_interviewer_time_per_week_hrs) /
                     (dead_line_days * working_hours_per_day)) * no_of_interviewer_need
                )
            )    
                 
            data = request.data.copy()  
            data["hiring_plan_id"] = plan_id    
            data["requisition_id"] = req_id
            data["required_candidate"] = required_candidate
            data["decline_adjust_count"] = decline_adjust_count
            data["total_candidate_pipline"] = total_candidate_pipline
            data["total_interviews_needed"] = total_interviews_needed
            data["total_interview_hrs"] = total_interview_hrs
            data["total_interview_weeks"] = total_interview_weeks
            data["no_of_interviewer_need"] = no_of_interviewer_need
            data["leave_adjustment"] = leave_adjustment             
            serializer = InterviewPlannerSerializer(data=data)
            if serializer.is_valid():
                serializer.save()
                interview_plan_data = {
                    "required_candidate": required_candidate,
                    "decline_adjust_count": decline_adjust_count,
                    "total_candidate_pipline": total_candidate_pipline,
                    "total_interviews_needed": total_interviews_needed,
                    "total_interview_hrs": total_interview_hrs,
                    "working_hrs_per_week": working_hrs_per_week,
                    "total_interview_weeks": total_interview_weeks,
                    "no_of_interviewer_need": no_of_interviewer_need,
                    "leave_adjustment": leave_adjustment
                }
                return Response(api_json_response_format(True,"Interview planning calculation completed.",201,interview_plan_data), status=200)

            return Response(api_json_response_format(True,"Interview planning calculation completed.",201,{
                    "required_candidate": required_candidate,
                    "decline_adjust_count": decline_adjust_count,
                    "total_candidate_pipline": total_candidate_pipline,
                    "total_interviews_needed": total_interviews_needed,
                    "total_interview_hrs": total_interview_hrs,
                    "working_hrs_per_week": working_hrs_per_week,
                    "total_interview_weeks": total_interview_weeks,
                    "no_of_interviewer_need": no_of_interviewer_need,
                    "leave_adjustment": leave_adjustment
                }
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(False,"Error in interview planning calculation post method "+str(e),500,{}), status=status.HTTP_200_OK)

    def put(self, request):
        try:
            interview_plan_id = request.data.get('interview_plan_id')
            if not interview_plan_id:
                return Response(api_json_response_format(False, "interview_plan_id is required.", status.HTTP_400_BAD_REQUEST, {}), status=200)

            obj = InterviewPlanner.objects.get(interview_plan_id=interview_plan_id)
            if not obj:
                return Response(api_json_response_format(False, "Interview plan not found.", 404, {}), status=200)

            # 🧮 Perform calculations
            dead_line_days = int(request.data.get('dead_line_days'))
            offer_decline = int(request.data.get('offer_decline'))
            working_hours_per_day = int(request.data.get('working_hours_per_day'))
            no_of_roles_to_hire = int(request.data.get('no_of_roles_to_hire'))
            conversion_ratio = int(request.data.get('conversion_ratio'))
            avg_interviewer_time_per_week_hrs = int(request.data.get('avg_interviewer_time_per_week_hrs'))
            interview_round = int(request.data.get('interview_round'))
            interview_time_per_round = int(request.data.get('interview_time_per_round'))
            interviewer_leave_days = int(request.data.get('interviewer_leave_days'))
            working_hrs_per_week = int(request.data.get('working_hrs_per_week'))

            required_candidate = int(no_of_roles_to_hire * conversion_ratio)
            decline_adjust_count = (required_candidate * offer_decline) / 100
            total_candidate_pipline = required_candidate + decline_adjust_count
            total_interviews_needed = total_candidate_pipline * interview_round
            total_interview_hrs = total_interviews_needed * interview_time_per_round
            total_interview_weeks = total_interview_hrs / working_hrs_per_week
            no_of_interviewer_need = total_interview_hrs / dead_line_days
            leave_adjustment = round(
                no_of_interviewer_need + (
                    ((interviewer_leave_days * avg_interviewer_time_per_week_hrs) /
                    (dead_line_days * working_hours_per_day)) * no_of_interviewer_need
                )
            )

            update_data = request.data.copy()
            update_data["required_candidate"] = required_candidate
            update_data["decline_adjust_count"] = decline_adjust_count
            update_data["total_candidate_pipline"] = total_candidate_pipline
            update_data["total_interviews_needed"] = total_interviews_needed
            update_data["total_interview_hrs"] = total_interview_hrs
            update_data["total_interview_weeks"] = total_interview_weeks
            update_data["no_of_interviewer_need"] = no_of_interviewer_need
            update_data["leave_adjustment"] = leave_adjustment

            serializer = InterviewPlannerSerializer(obj, data=update_data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(
                    True,
                    "Interview planning calculation updated successfully.",
                    200,
                    {
                        "interview_plan_id": interview_plan_id,
                        "required_candidate": required_candidate,
                        "decline_adjust_count": decline_adjust_count,
                        "total_candidate_pipline": total_candidate_pipline,
                        "total_interviews_needed": total_interviews_needed,
                        "total_interview_hrs": total_interview_hrs,
                        "working_hrs_per_week": working_hrs_per_week,
                        "total_interview_weeks": total_interview_weeks,
                        "no_of_interviewer_need": no_of_interviewer_need,
                        "leave_adjustment": leave_adjustment
                    }
                ), status=200)

            return Response(api_json_response_format(False, f"Validation error: {serializer.errors}", 400, {}), status=200)

        except Exception as error:
            return Response(api_json_response_format(
                False,
                f"Error updating interview planning calculation: {str(error)}",
                500,
                {}
            ), status=200)

    def delete(self, request):
        try:
            plan_id = request.data.get('plan_id')
            req_id = request.data.get('req_id')            
            
            if not req_id:
                return Response(api_json_response_format(False,"req_id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)
            
            filters = {}
            if plan_id:
                filters['hiring_plan_id'] = plan_id
            if req_id:
                filters['requisition_id'] = req_id

            queryset = InterviewPlanner.objects.filter(**filters)
            queryset.delete()            
            return Response(api_json_response_format(True,"Record deleted successfully.",200,{}), status=200)             
        except Exception as error:
            return Response(api_json_response_format(False,"Could not delete data ."+str(error),500,{}), status=204)
 


class InterviewerBandwidthDashboard(APIView):
    def post(self, request):
        try:
            requested_fields = request.data.get('field_names', [
                "hiring_plan_id",
                "requisition_id",
                "leave_adjustment",
                "dead_line_days",
                "offer_decline",
                "no_of_roles_to_hire",
                "interview_round",
                "no_of_interviewer_need",
                "required_candidate"
            ])

            if not isinstance(requested_fields, list):
                return Response(api_json_response_format(False, "field_names must be a list", 400, {}), status=200)

            model_fields = [f.name for f in InterviewPlanner._meta.fields]
            allowed_virtual_fields = ["job_position", "client_name", "client_id"]

            for field in requested_fields:
                if field not in model_fields and field not in allowed_virtual_fields:
                    return Response(api_json_response_format(False, f"Invalid field: {field}", 400, {}), status=200)

            # 🔁 Append computed fields if needed
            for virtual_field in allowed_virtual_fields:
                if virtual_field not in requested_fields:
                    requested_fields.append(virtual_field)

            queryset = InterviewPlanner.objects.all()
            result = []

            for obj in queryset:
                row = {field: getattr(obj, field, None) for field in requested_fields if field in model_fields}

                # 🔍 Enrich with requisition info
                try:
                    requisition = JobRequisition.objects.filter(RequisitionID=obj.requisition_id).first()
                    if requisition:
                        row["job_position"] = requisition.PositionTitle or "Not Provided"
                        row["client_name"] = requisition.company_client_name or "N/A"
                        row["client_id"] = requisition.client_id or "N/A"
                    else:
                        row["job_position"] = "Not Found"
                        row["client_name"] = "Not Found"
                        row["client_id"] = "Not Found"
                except Exception:
                    row["job_position"] = "Error"
                    row["client_name"] = "Error"
                    row["client_id"] = "Error"

                result.append(row)

            return Response(api_json_response_format(True, "Interviewer Bandwidth Dashboard", 200, result), status=200)

        except Exception as e:
            return Response(api_json_response_format(False, f"Error in Interviewer Bandwidth Dashboard post method: {str(e)}", 500, {}), status=200)


class ManageRequisitionView(APIView):
    def post(self, request):
        try:
            # Extract expected fields directly from request payload
            requisition_date = request.data.get("requisition_date")
            due_requisition_date = request.data.get("due_requisition_date")
            requisition_template = request.data.get("requisition_template")
            no_of_openings = request.data.get("no_of_openings")
            hiring_plan_id = request.data.get("hiring_plan_id")

            response_data = {
                "hiring_plan_id": hiring_plan_id,
                "requisition_date": requisition_date,
                "due_requisition_date": due_requisition_date,
                "requisition_template": requisition_template,
                "no_of_openings": no_of_openings
            }

            return Response(
                api_json_response_format(True, "Manage requisition payload echoed successfully.", 200, response_data),
                status=200
            )

        except Exception as e:
            return Response(
                api_json_response_format(False, "Error echoing manage requisition payload: " + str(e), 500, {}),
                status=200
            )

# @parser_classes([MultiPartParser, FormParser])
class HiringPlanOverviewDetails(APIView):
    def get(self, request):
        try:
            raw_fields = request.query_params.get("fields")
            if raw_fields:
                selected_fields = [f.strip() for f in raw_fields.split(",") if f.strip()]
            else:
                selected_fields = []

            if selected_fields:
                # Use only Planning-related fields
                planning_fields_map = {
                    key: val for key, val in DISPLAY_TO_MODEL_FIELD.items()
                    if isinstance(val, str) and val.startswith("Planning_id__") or
                       isinstance(val, list) and all(f.startswith("Planning_id__") for f in val)
                }

                queryset = HiringPlan.objects.select_related("JobRequisition_id", "JobRequisition_id__details")
                result_data = extract_requested_fields(queryset, selected_fields, planning_fields_map)

                return Response(api_json_response_format(
                    True, "Filtered hiring plan data retrieved successfully!", 200, {
                        "hiring_plans": result_data,
                        "selected_fields": selected_fields
                    }), status=200)

            # Fallback to full serializer if no dynamic fields requested
            hiring_plan = HiringPlan.objects.all()
            serializer = HiringPlanSerializer(hiring_plan, many=True)
            return Response(api_json_response_format(
                True, "Hiring plans retrieved successfully.", 200, {
                    "hiring_plans": serializer.data
                }), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, "Error retrieving hiring plans. " + str(e), 500, {}), status=200)


    def post(self, request, *args, **kwargs):
        last_plan_id = HiringPlan.objects.order_by('-id').first()            
        if last_plan_id and last_plan_id.hiring_plan_id.startswith('PL'):
            last_id = int(last_plan_id.hiring_plan_id.replace('PL', ''))
            new_hiring_plan_id = f"PL{last_id + 1:04d}"
        else:
            new_hiring_plan_id = "PL0001"
        data = request.data.copy()
        data['hiring_plan_id'] = new_hiring_plan_id
        serializer = HiringPlanSerializer(data=data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(api_json_response_format(
                True,
                "Hiring plan created successfully.",
                200,
                {
                    "hiring_plan_id": instance.hiring_plan_id,
                    "job_position": instance.job_position
                }
            ), status=200)
        return Response(api_json_response_format(
            False,
            "Validation error while creating hiring plan."+serializer.errors,
            400,
            {}
        ), status=200)

    def put(self, request):
        hiring_plan_id = request.data.get('hiring_plan_id')        
        if not hiring_plan_id:
            return Response(api_json_response_format(False,"Hiring Plan ID is required in request body.",400,{}), status=200)
        try:
            instance = HiringPlan.objects.get(hiring_plan_id=hiring_plan_id)
        except HiringPlan.DoesNotExist:
            return Response(api_json_response_format(False,"Hiring plan not found.",404,{}), status=200)

        serializer = HiringPlanSerializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            if 'requisition_date' in request.data:             
                rs=serializer.save()            
                result_data = {"hiring_plan_id":rs.hiring_plan_id,"requisition_date":rs.requisition_date,"requisition_template":rs.requisition_template,"no_of_openings":rs.no_of_openings}
            else:
                serializer.save()  
                result_data = serializer.data
            return Response(api_json_response_format(True,"Hiring plan updated successfully.",200,result_data), status=200)
        return Response(api_json_response_format(False,"Validation error while updating hiring plan.",400,{"errors": serializer.errors}), status=200)

    def delete(self, request):
        hiring_plan_id = request.data.get('hiring_plan_id')
        if not hiring_plan_id:
            return Response(api_json_response_format(
                False,
                "Hiring Plan ID is required in request body.",400,
                {}
            ), status=200)

        obj = get_object_or_404(HiringPlan, hiring_plan_id=hiring_plan_id)
        obj.delete()
        return Response(api_json_response_format(
            True,
            "Hiring plan deleted successfully.",
            204,
            {}
        ), status=200)        

@api_view(['GET'])
def get_hiring_plans(request):
    try:
        hiring_plans = HiringPlan.objects.all()
        serializer = HiringPlanSerializer(hiring_plans, many=True)

        filtered_data = [
            {'hiring_plan_id': item['hiring_plan_id'], 'job_position': item['job_position']}
            for item in serializer.data
        ]

        return Response(api_json_response_format(
            True,
            "Hiring plan detail fetched successfully!",
            200,
            {"plans": filtered_data}
        ), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False,
            "Error retrieving hiring plan list."+str(e),500,
            {}
        ), status=200)

@api_view(['POST'])
def get_hiring_plans(request):
    try:
        selected_fields = request.data.get("fields", [])
        if not isinstance(selected_fields, list) or not selected_fields:
            return Response(api_json_response_format(
                False, "Missing or invalid 'fields' parameter.", 400, {}), status=200)

        queryset = HiringPlan.objects.select_related("JobRequisition_id", "JobRequisition_id__details")

        # Filtered field map (Planning_id only)
        planning_fields_map = {
            "id": "hiring_plan_id",  # ensure this field is manually injected
            **{
                key: val for key, val in DISPLAY_TO_MODEL_FIELD1.items()
                if isinstance(val, str) or (isinstance(val, list) and all(isinstance(f, str) for f in val))
            }
        }


        result_data = extract_requested_fields(queryset, selected_fields, planning_fields_map)

        return Response(api_json_response_format(
            True, "Filtered hiring plan data retrieved successfully!", 200, {
                "data": result_data,
                "selected_fields": selected_fields
            }), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False, "Error retrieving hiring plan data. " + str(e), 500, {}), status=200)


@api_view(['GET'])
def get_all_req_ids(request):
    req_ids = JobRequisition.objects.all().values_list('RequisitionID', flat=True)
    job_positions = JobRequisition.objects.all().values_list('PositionTitle', flat=True)
    combined_data = [
        {"req_ids": req_id, "job_position": position}
        for req_id, position in zip(req_ids, job_positions)
    ]

    return Response(api_json_response_format(
        True,
        "All requisition data fetched successfully!",
        200,
        combined_data
    ), status=200)


@api_view(['POST'])
def get_hiring_plan_details(request):
    hiring_plan_id = request.data.get('hiring_plan_id')

    if not hiring_plan_id:
        return Response(api_json_response_format(
            False,
            "No hiring_plan_id provided.",400,
            {}
        ), status=200)

    try:
        hiring_plan = HiringPlan.objects.get(hiring_plan_id=hiring_plan_id)
        serializer = HiringPlanSerializer(hiring_plan)
        return Response(api_json_response_format(
            True,
            "Hiring plan detail fetched successfully!",
            200,
            serializer.data
        ), status=200)

    except HiringPlan.DoesNotExist:
        return Response(api_json_response_format(
            False,
            "Hiring plan not found.",
            "HIRING_PLAN_NOT_FOUND",
            {}
        ), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False,
            "Error retrieving hiring plan. "+ str(e),500,
            {}
        ), status=200)


class HiringPlanDetailView(APIView):
    def post(self, request):
        try:
            hiring_plan_id = request.data.get("Planning_id")
            if not hiring_plan_id:
                return Response(api_json_response_format(
                    False, "Missing hiring_plan_id", 400, {}), status=200)

            try:
                obj = HiringPlan.objects.get(hiring_plan_id=hiring_plan_id)
                serializer = HiringPlanSerializer(obj)
                return Response(api_json_response_format(
                    True, "Hiring plan fetched successfully", 200, serializer.data), status=200)
            except HiringPlan.DoesNotExist:
                return Response(api_json_response_format(
                    False, "Hiring plan not found", 404, {}), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False, "Error fetching hiring plan: " + str(e), 500, {}), status=200)


class HiringInterviewRounds(APIView):
    def get(self, request):
        try:
            hiring_rounds = InterviewRounds.objects.all()
            serializer = HiringInterviewRoundsSerializer(hiring_rounds, many=True)
            return Response(api_json_response_format(
                True,
                "Interview rounds fetched successfully.",
                200,
                {"rounds": serializer.data}
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error fetching interview rounds."+str(e),
                500,
                {"details": str(e)}
            ), status=200)

    def post(self, request):
        try:
            requisition_id = request.data.get('plan_id')
            round_name_list = request.data.get('round_name', [])

            if not requisition_id or not round_name_list:
                return Response(api_json_response_format(
                    False,
                    "Missing requisition_id or round_name list.",
                    400,
                    {}
                ), status=200)

            data_to_insert = [
                {"plan_id": requisition_id, "round_name": name}
                for name in round_name_list
            ]

            serializer = HiringInterviewRoundsSerializer(data=data_to_insert, many=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(
                    True,
                    "Interview rounds created successfully.",
                    200,
                    serializer.data
                ), status=200)
            return Response(api_json_response_format(
                False,
                "Validation failed while creating interview rounds."+serializer.errors,
                400,
                {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Unexpected error during round creation."+str(e),
                500,
                {}
            ), status=200)

    def put(self, request):
        requisition_id = request.data.get('id')
        if not requisition_id:
            return Response(api_json_response_format(
                False,
                "Hiring Plan ID is required in request body.",
                400,
                {}
            ), status=200)

        try:
            instance = InterviewRounds.objects.get(id=requisition_id)
        except InterviewRounds.DoesNotExist:
            return Response(api_json_response_format(
                False,
                "Interview round not found.",
                404,
                {}
            ), status=200)

        serializer = HiringInterviewRoundsSerializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(api_json_response_format(
                True,
                "Interview round updated successfully.",
                200,
                serializer.data
            ), status=200)
        return Response(api_json_response_format(
            False,
            "Validation error while updating interview round."+serializer.errors,
            400,
            {}
        ), status=200)
    
class HiringInterviewSkills(APIView):
    def post(self, request):
        try:
            requisition_id = request.data.get('plan_id')
            skill_name_list = request.data.get('skill_name', [])
            skill_value_list = request.data.get('skill_value', [])

            if not requisition_id or not skill_name_list or not skill_value_list:
                return Response(api_json_response_format(
                    False,
                    "Missing requisition_id or skill data.",
                    400,
                    {}
                ), status=200)

            if len(skill_name_list) != len(skill_value_list):
                return Response(api_json_response_format(
                    False,
                    "skill_name and skill_value must have same number of items.",
                    400,
                    {}
                ), status=200)

            data_to_insert = [
                {"plan_id": requisition_id, "skill_name": name, "skill_value": value}
                for name, value in zip(skill_name_list, skill_value_list)
            ]

            serializer = HiringSkillsSerializer(data=data_to_insert, many=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(
                    True,
                    "Interview skills created successfully!",
                    200,
                    serializer.data
                ), status=200)

            return Response(api_json_response_format(
                False,
                "Validation error while creating interview skills."+serializer.errors,
                400,
                {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Unexpected error during interview skills creation."+str(e),
                500,
                {}
            ), status=200)
        

class InterviewDesignScreenView(APIView):
    def get(self, request):
        try:
            interview_design_id = request.query_params.get('interview_design_id')
            if interview_design_id:
                hiring_plan = InterviewDesignParameters.objects.filter(interview_design_id=interview_design_id)
                serializer = InterviewDesignParametersSerializer(hiring_plan, many=True) 
            else:
                db_model = InterviewDesignScreen.objects.all()
                serializer = InterviewDesignScreenSerializer(db_model, many=True)            
            return Response(api_json_response_format(True,"InterviewDesignScreenView.",200,serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False,"Error InterviewDesignScreenView get method ()."+str(e),500,{}), status=200)
    # def get(self, request):
    #     try:
    #         db_model = InterviewDesignScreen.objects.all()
    #         serializer = InterviewDesignScreenSerializer(db_model, many=True)
    #         return Response(api_json_response_format(True, "InterviewDesignScreenView.", 200, serializer.data), status=200)
    #     except Exception as e:
    #         return Response(api_json_response_format(False, f"Error InterviewDesignScreenView get method: {str(e)}", 500, {}), status=200)

        
    def post(self, request, *args, **kwargs):
        try:
            design_params = request.data.get("params", [])
            interview_design = request.data.copy()

            req_id = interview_design.get("req_id")
            plan_id = interview_design.get("plan_id")  # optional

            if not req_id:
                return Response(api_json_response_format(False, "req_id is required.", 400, {}), status=200)

            interview_design["req_id"] = req_id
            interview_design["hiring_plan_id"] = plan_id or ""  # default to empty string if not provided

            # Optional: inject plan_id only if present
            if plan_id:
                interview_design["plan_id"] = plan_id

            # 🧠 Auto-fill position_role from JobRequisition
            requisition = JobRequisition.objects.filter(RequisitionID=req_id).first()
            if requisition:
                interview_design["position_role"] = requisition.PositionTitle

            # Clean payload
            interview_design.pop("params", None)

            serializer = InterviewDesignScreenSerializer(data=interview_design)
            if serializer.is_valid():
                instance = serializer.save()
                interview_design_id = instance.interview_design_id
                
                # Attach nested parameters
                for obj in design_params:
                    obj["score_card"] = obj.get("score_card_name", "")
                    obj["interview_design_id"] = interview_design_id
                    obj["hiring_plan_id"] = instance.hiring_plan_id or ""

                serializer_params = InterviewDesignParametersSerializer(data=design_params, many=True)
                if serializer_params.is_valid():
                    serializer_params.save()

                    response_data = serializer.data.copy()
                    response_data["req_id"] = req_id
                    response_data["params"] = serializer_params.data

                    return Response(api_json_response_format(
                        True,
                        "Interview Design Screen Details Saved Successfully!",
                        200,
                        response_data
                    ), status=200)

                return Response(api_json_response_format(
                    False,
                    f"Could not save Interview Design parameters: {serializer_params.errors}",
                    400,
                    {}
                ), status=200)

            return Response(api_json_response_format(
                False,
                f"Could not save Interview Design: {serializer.errors}",
                400,
                {}
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Could not save Interview Design: {str(e)}",
                500,
                {}
            ), status=200)


    def put(self, request, *args, **kwargs):
        try:
            interview_design_id = request.data.get("interview_design_id")
            design_params = request.data.get("params", [])
            interview_design = request.data.copy()

            if not interview_design_id:
                return Response(api_json_response_format(
                    False, "interview_design_id is required.", status.HTTP_400_BAD_REQUEST, {}
                ), status=200)

            instance = InterviewDesignScreen.objects.filter(interview_design_id=interview_design_id).first()
            if not instance:
                return Response(api_json_response_format(
                    False, "No matching InterviewDesignScreen found.", 404, {}
                ), status=200)

            # 🔁 Extract and assign req_id + plan_id explicitly
            req_id = interview_design.get("req_id")
            plan_id = interview_design.get("plan_id")

            interview_design["hiring_plan_id"] = plan_id
            interview_design["req_id"] = req_id

            # 🧠 Auto-fill position_role from JobRequisition
            requisition = JobRequisition.objects.filter(RequisitionID=req_id).first()
            if requisition:
                interview_design["position_role"] = requisition.PositionTitle

            # 🧹 Clean payload before serializer
            interview_design.pop("plan_id", None)
            interview_design.pop("params", None)

            serializer = InterviewDesignScreenSerializer(instance, data=interview_design, partial=True)
            if serializer.is_valid():
                updated_instance = serializer.save()

                # 🔄 Refresh DesignParameters: delete & recreate
                InterviewDesignParameters.objects.filter(interview_design_id=interview_design_id).delete()

                for obj in design_params:
                    obj["score_card"] = obj.get("score_card_name", "")
                    obj["interview_design_id"] = interview_design_id
                    obj["hiring_plan_id"] = updated_instance.hiring_plan_id

                serializer_params = InterviewDesignParametersSerializer(data=design_params, many=True)
                if serializer_params.is_valid():
                    serializer_params.save()

                    response_data = serializer.data.copy()
                    response_data["req_id"] = req_id

                    return Response(api_json_response_format(
                        True,
                        "Interview Design Screen Updated Successfully!",
                        200,
                        response_data
                    ))

                return Response(api_json_response_format(
                    False,
                    f"Failed to update parameters: {serializer_params.errors}",
                    status.HTTP_400_BAD_REQUEST,
                    {}
                ))

            return Response(api_json_response_format(
                False,
                f"Failed to update Interview Design: {serializer.errors}",
                status.HTTP_400_BAD_REQUEST,
                {}
            ))

        except Exception as e:
            return Response(api_json_response_format(
                False,
                f"Error updating Interview Design: {str(e)}",
                500,
                {}
            ), status=200)


    def delete(self, request):
        interview_design_id = request.data.get('interview_design_id')
        if not interview_design_id:
            return Response(api_json_response_format(False,"interview_design_id is required in request body.",400,{}), status=200)

        obj = get_object_or_404(InterviewDesignScreen, interview_design_id=interview_design_id)
        obj.delete()
        InterviewDesignParameters.objects.filter(interview_design_id=interview_design_id).delete()
        return Response(api_json_response_format(True,"Interview Desing screen Details are deleted successfully.",200,{}), status=202)  


@api_view(['POST'])
def interview_design_by_id(request):
    try:
        interview_design_id = request.data.get("interview_design_id")
        if not interview_design_id:
            return Response(api_json_response_format(False, "interview_design_id is required in request body.", 400, {}), status=200)

        instance = InterviewDesignScreen.objects.filter(interview_design_id=interview_design_id).first()
        if not instance:
            return Response(api_json_response_format(False, "Design not found.", 404, {}), status=200)

        serializer = InterviewDesignScreenSerializer(instance)
        return Response(api_json_response_format(True, "Interview design retrieved successfully.", 200, serializer.data), status=200)

    except Exception as e:
        return Response(api_json_response_format(False, f"Error retrieving interview design: {str(e)}", 500, {}), status=200)

@api_view(['POST'])
def interview_planner_by_id(request):
    try:
        planner_id = request.data.get("interview_plan_id")
        if not planner_id:
            return Response(api_json_response_format(False, "interview_plan_id is required in request body.", 400, {}), status=200)

        instance = InterviewPlanner.objects.filter(interview_plan_id=planner_id).first()
        if not instance:
            return Response(api_json_response_format(False, "Interview Planner not found.", 404, {}), status=200)

        serializer = InterviewPlannerSerializer(instance)
        return Response(api_json_response_format(True, "Interview Planner retrieved successfully.", 200, serializer.data), status=200)

    except Exception as e:
        return Response(api_json_response_format(False, f"Error retrieving Interview Planner: {str(e)}", 500, {}), status=200)

      
class StateAlertResposibilityView(APIView):
    def get(self, request):
        try:
            hiring_plan_id = request.query_params.get('hiring_plan_id')  # Changed from request.data.get
            if hiring_plan_id:
                queryset = StageAlertResponsibility.objects.filter(hiring_plan_id=hiring_plan_id)
            else:
                queryset = StageAlertResponsibility.objects.all()

            serializer = StageAlertResponsibilitySerializer(queryset, many=True)
            return Response(api_json_response_format(
                True,
                "Stage alert and responsibility settings details retrieved successfully.",
                200,
                {"stage_alert_and_responsibility": serializer.data}
            ), status=200)
        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error retrieving stage alert and responsibility settings: " + str(e),
                500,
                {}
            ), status=200)

    def post(self, request):
        try:      
            serializer = StageAlertResponsibilitySerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Stage alert and responsibility settings Details updated Successfully!.",200,serializer.data), status=200)

            return Response(api_json_response_format(
                False,
                "Could not update Stage alert and responsibility settings Details",
                200,
                {
                }
            ), status=200)

        except Exception as e:
            return Response(api_json_response_format(
                False,
                "Error during Could not update Stage alert and responsibility settings Details "+str(e),
                500,
                {}
            ), status=200)
        
@action(detail=False, methods=["post"], url_path="get-candidates-by-req")
def get_candidates_by_req_id(self, request):
    req_id = request.data.get("req_id")

    if not req_id:
        return Response(api_json_response_format(False, "req_id is required.", 400, {}), status=200)

    candidates = Candidate.objects.filter(Req_id_fk=req_id)

    if not candidates.exists():
        return Response(api_json_response_format(False, "No candidates found for the given req_id.", 404, {}), status=200)

    serializer = CandidateDetailWithInterviewSerializer(candidates, many=True)
    return Response(api_json_response_format(True, "Candidates retrieved successfully.", 200, serializer.data), status=200)

class CandidateInterviewStagesView(APIView):
    def get(self, request):
        try:
            db_model = CandidateInterviewStages.objects.all()
            serializer = CandidateInterviewStagesSerializer(db_model, many=True)
            
            return Response(api_json_response_format(True,"Interviwer Calender Details Details.",200,serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False,"Error during get Interviwer Calender Details  "+str(e),500,{}), status=200)
            
    def post(self, request):
        try:             
            serializer = CandidateInterviewStagesSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Interviwer Calender Details updated Successfully!.",200,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Interviwer Calender Details Details",200,{}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False,"Error during Could not update Interviwer Calender Details Details "+str(e),500,{}), status=200)
     

@api_view(["POST"])
def get_plan_id_position_role(request):
    try:
        hiring_plan_id = request.data.get('hiring_plan_id')
        if hiring_plan_id:          
            hiring_plan = HiringPlan.objects.filter(hiring_plan_id=hiring_plan_id)
            serializer = HiringPlanSerializer(hiring_plan, many=True)            
            position_list = [item['job_position'] for item in serializer.data]
            return Response(api_json_response_format(True,"Job Position Details",200,position_list))
        else:            
            hiring_plans = list(HiringPlan.objects.values_list('hiring_plan_id', flat=True))
            return Response(api_json_response_format(True,"Candidate Details",200,hiring_plans))
    except Exception as e:
        return Response(api_json_response_format(False,"Error in get_plan_id_position_role  .",500,{}), status=200)
        
        
class InterviewScreenDashboardView(APIView):
    def get(self, request):
        try:
            model_data = InterviewDesignScreen.objects.all()
            design_screen_dashboard_data = []

            for design in model_data:
                score_card_qs = InterviewDesignParameters.objects.filter(
                    interview_design_id=design.interview_design_id
                )
                score_cards = [param.score_card for param in score_card_qs]

                # 🔍 Get requisition info
                requisition = JobRequisition.objects.filter(RequisitionID=design.req_id).first()

                design_screen_data = {
                    "interview_design_id":design.interview_design_id,
                    "plan_id": design.hiring_plan_id,
                    "position_role": requisition.PositionTitle,
                    "tech_stacks": design.tech_stacks,
                    "screening_type": design.screening_type,
                    "interview_rounds": score_cards,
                    "status": design.status,
                    "requisition_id": design.req_id,
                    "client_name": requisition.company_client_name if requisition else "Not Found",
                    "client_id": requisition.client_id if requisition else "Not Found"
                }

                design_screen_dashboard_data.append(design_screen_data)

            return Response(
                api_json_response_format(True, "Interview Design Screen Dashboard Details", 200, design_screen_dashboard_data),
                status=200
            )

        except Exception as e:
            return Response(
                api_json_response_format(False, f"Error in InterviewScreenDashboardView get method: {str(e)}", 500, {}),
                status=200
            )

@api_view(["POST"])
def filter_candidates_dashboard(request):
    try:
        status_filter = request.data.get('status')       # e.g., 'In-Progress', 'Selected', 'Rejected'
        req_id_filter = request.data.get('req_id')       # e.g., 1234
        interview_stage_filter = request.data.get('stage')  # e.g., 'Screening', 'Final Round'

        candidates = Candidate.objects.all()

        if status_filter and status_filter != "All":
            candidates = candidates.filter(final_status__iexact=status_filter)

        if req_id_filter:
            candidates = candidates.filter(req_id=req_id_filter)

        if interview_stage_filter:
            candidates = candidates.filter(candidate_current_stage__iexact=interview_stage_filter)

        candidate_list = []
        for candidate in candidates:
            candidate_list.append({
                "req_id": candidate.Req_id_fk,
                "candidate_id": candidate.CandidateID,
                "candidate_name": candidate.Name,
                "applied_position": candidate.applied_position,
                "time_in_stage": candidate.time_in_stage,
                "jd_url": candidate.jd_file.url if candidate.jd_file else None,
                "cv_url": candidate.cv_file.url if candidate.cv_file else None,
                "cover_letter_url": candidate.cover_letter.url if candidate.cover_letter else None,
                "current_stage": candidate.candidate_current_stage,
                "next_stage": candidate.candidate_next_stage,
                "overall_score": candidate.Final_rating,
                "final_status": candidate.Result,
                "source": candidate.source,
            })

        return Response(api_json_response_format(True, "Filtered Candidate List", 200, candidate_list), status=200)

    except Exception as e:
        return Response(api_json_response_format(False, f"Error in filter_candidates_dashboard: {str(e)}", 500, {}), status=200)            
    
def admin_configuration(request):
    return render(request, "admin_configuration.html")

class ConfigPositionRoleSearchView(APIView):
    def post(self, request):
        try:
            search_query = request.data.get('query', '').strip()
            if not search_query:
                return Response(
                    api_json_response_format(False, "Search query is required in body.", status.HTTP_400_BAD_REQUEST, {}),
                    status=200
                )

            matched_roles = ConfigPositionRole.objects.filter(position_role__icontains=search_query)
            serializer = ConfigPositionRoleSerializer(matched_roles, many=True)
            return Response(
                api_json_response_format(True, "Search results", 200, serializer.data),
                status=200
            )
        except Exception as e:
            return Response(
                api_json_response_format(False, f"Error during search: {str(e)}", 500, {}),
                status=200
            )
        
class ConfigScreeningTypeSearchView(APIView):
    def post(self, request):
        try:
            search_query = request.data.get('query', '').strip()
            if not search_query:
                return Response(
                    api_json_response_format(False, "Search query is required in body.", status.HTTP_400_BAD_REQUEST, {}),
                    status=200
                )

            matched_types = ConfigScreeningType.objects.filter(screening_type_name__icontains=search_query)
            serializer = ConfigScreeningTypeSerializer(matched_types, many=True)
            return Response(
                api_json_response_format(True, "Search results", 200, serializer.data),
                status=200
            )
        except Exception as e:
            return Response(
                api_json_response_format(False, f"Error during search: {str(e)}", 500, {}),
                status=200
            )
        
class ConfigScoreCardSearchView(APIView):
    def post(self, request):
        try:
            search_query = request.data.get('query', '').strip()
            if not search_query:
                return Response(
                    api_json_response_format(False, "Search query is required in body.", status.HTTP_400_BAD_REQUEST, {}),
                    status=200
                )

            matched_scorecards = ConfigScoreCard.objects.filter(score_card_name__icontains=search_query)
            serializer = ConfigScoreCardSerializer(matched_scorecards, many=True)
            return Response(
                api_json_response_format(True, "Search results", 200, serializer.data),
                status=200
            )
        except Exception as e:
            return Response(
                api_json_response_format(False, f"Error during search: {str(e)}", 500, {}),
                status=200
            )
       
class ConfigPositionRoleView(APIView):
    def get(self, request):
        try:           

            db_model = ConfigPositionRole.objects.all()
            serializer = ConfigPositionRoleSerializer(db_model, many=True)            
            return Response(api_json_response_format(True,"Job Position Role details",200,serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False,"Error in Job Position Role details get method  "+str(e),500,{}), status=200)
            
    def post(self, request):
        try:
            table_value = (request.data.get('table_value') )
            json_data = {"position_role" : table_value}
            serializer = ConfigPositionRoleSerializer(data=json_data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Job Position Role details updated Successfully!.",200,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Job Position Role details",200,{}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False,"Error during Could not update Job Position Role details post method "+str(e),500,{}), status=200)
        
    def put(self, request):
        ref_id = request.data.get('id')        
        if not ref_id:
            return Response(api_json_response_format(False,"ref_id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)       
        try:
            instance = ConfigPositionRole.objects.get(id=ref_id)
            serializer = ConfigPositionRoleSerializer(instance, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Job Position Role Details updated successfully : ",status.HTTP_200_OK,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Job Position Role error : "+str(serializer.errors),500,{}), status=200)       
                
        except Exception as error:
            return Response(api_json_response_format(False,"Could not update Job Position Role error in put method : "+str(error),500,{}), status=200)            
        

    def delete(self, request):
        try:
            ref_id = request.data.get('id') 
            if not ref_id:
                return Response(api_json_response_format(False,"id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)
            obj = ConfigPositionRole.objects.get(id=ref_id)
            obj.delete()
            return Response(api_json_response_format(True,"Job Position Role deleted successfully.",200,{}), status=200)             
        except Exception as error:
            return Response(api_json_response_format(False,"Could not delete Job Position Role ."+str(error),500,{}), status=200) 
        
class ConfigScreeningTypeView(APIView):
    def get(self, request):
        try:           

            db_model = ConfigScreeningType.objects.all()
            serializer = ConfigScreeningTypeSerializer(db_model, many=True)            
            return Response(api_json_response_format(True,"Job Position Role details",200,serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False,"Error in Job Position Role details get method  "+str(e),500,{}), status=200)
            
    def post(self, request):
        try:
            table_value = (request.data.get('table_value') )
            json_data = {"screening_type_name" : table_value}
            serializer = ConfigScreeningTypeSerializer(data=json_data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Job Position Role details updated Successfully!.",200,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Job Position Role details",200,{}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False,"Error during Could not update Job Position Role details post method "+str(e),500,{}), status=200)
        
    def put(self, request):
        ref_id = request.data.get('id')        
        if not ref_id:
            return Response(api_json_response_format(False,"ref_id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)       
        try:
            instance = ConfigScreeningType.objects.get(id=ref_id)
            serializer = ConfigScreeningTypeSerializer(instance, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Job Position Role Details updated successfully : ",status.HTTP_200_OK,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Job Position Role error : "+str(serializer.errors),500,{}), status=200)       
                
        except Exception as error:
            return Response(api_json_response_format(False,"Could not update Job Position Role error in put method : "+str(error),500,{}), status=200)            
        

    def delete(self, request):
        try:
            ref_id = request.data.get('id') 
            if not ref_id:
                return Response(api_json_response_format(False,"id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)
            obj = ConfigScreeningType.objects.get(id=ref_id)
            obj.delete()
            return Response(api_json_response_format(True,"Job Position Role deleted successfully.",200,{}), status=200)             
        except Exception as error:
            return Response(api_json_response_format(False,"Could not delete Job Position Role ."+str(error),500,{}), status=200) 
        
class ConfigScoreCardView(APIView):
    def get(self, request):
        try:           
            # screening_type_name_list = list(ConfigScoreCard.objects.values_list('score_card_name', flat=True))
            db_model = ConfigScoreCard.objects.all()
            serializer = ConfigScoreCardSerializer(db_model, many=True)            
            return Response(api_json_response_format(True,"Job Position Role details",200,serializer.data), status=200)
        except Exception as e:
            return Response(api_json_response_format(False,"Error in Job Position Role details get method  "+str(e),500,{}), status=200)
            
    def post(self, request):
        try:
            table_value = (request.data.get('table_value') )
            json_data = {"score_card_name" : table_value}
            serializer = ConfigScoreCardSerializer(data=json_data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Job Position Role details updated Successfully!.",200,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Job Position Role details",200,{}), status=200)

        except Exception as e:
            return Response(api_json_response_format(False,"Error during Could not update Job Position Role details post method "+str(e),500,{}), status=200)
        
    def put(self, request):
        ref_id = request.data.get('id')        
        if not ref_id:
            return Response(api_json_response_format(False,"ref_id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)       
        try:
            instance = ConfigScoreCard.objects.get(id=ref_id)
            serializer = ConfigScoreCardSerializer(instance, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Job Position Role Details updated successfully : ",status.HTTP_200_OK,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Job Position Role error : "+str(serializer.errors),500,{}), status=200)       
                
        except Exception as error:
            return Response(api_json_response_format(False,"Could not update Job Position Role error in put method : "+str(error),500,{}), status=200)            
        

    def delete(self, request):
        try:
            ref_id = request.data.get('id') 
            if not ref_id:
                return Response(api_json_response_format(False,"id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)
            obj = ConfigScoreCard.objects.get(id=ref_id)
            obj.delete()
            return Response(api_json_response_format(True,"Job Position Role deleted successfully.",200,{}), status=200)             
        except Exception as error:
            return Response(api_json_response_format(False,"Could not delete Job Position Role ."+str(error),500,{}), status=200) 

class AdminConfigurationView(APIView):
    def get(self, request):
        try:        
            category_name = request.query_params.get('category_name')
            if not category_name:
                categories = ConfigHiringData.objects.values_list('category_name', flat=True).distinct()
                data = {}
                for category in categories:
                    values = ConfigHiringData.objects.filter(category_name=category).values_list('category_values', flat=True)
                    data[category] = list(values)         
                return Response(api_json_response_format(True,"Admin Configuration Details details",200,data), status=200)
            else:
                print(category_name)
                queryset = ConfigHiringData.objects.filter(category_name=category_name)
                serializer = ConfigHiringDataSerializer(queryset, many=True)
                return Response(api_json_response_format(True,"Admin Configuration Details details",200,serializer.data), status=200)                

        except Exception as e:
            return Response(api_json_response_format(False,"Error in Admin Configuration Details details get method  "+str(e),500,{}), status=status.HTTP_200_OK)
            
    def post(self, request):
        try:            
            serializer = ConfigHiringDataSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Admin Configuration Details updated Successfully!.",201,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Admin Configuration details",201,{}), status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response(api_json_response_format(False,"Error during Could not update Admin Configuration details post method "+str(e),500,{}), status=status.HTTP_200_OK)
        
    def put(self, request):
        ref_id = request.data.get('id')        
        if not ref_id:
            return Response(api_json_response_format(False,"ref_id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)       
        try:
            instance = ConfigHiringData.objects.get(id=ref_id)
            serializer = ConfigHiringDataSerializer(instance, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(api_json_response_format(True,"Admin Configuration Details Details updated successfully : ",status.HTTP_200_OK,serializer.data), status=200)
            return Response(api_json_response_format(False,"Could not update Admin Configuration Details error : "+str(serializer.errors),500,{}), status=200)       
                
        except Exception as error:
            return Response(api_json_response_format(False,"Could not update Admin Configuration Details error in put method : "+str(error),500,{}), status=200)            
        

    def delete(self, request):
        try:
            ref_id = request.data.get('id') 
            if not ref_id:
                return Response(api_json_response_format(False,"id is required.",status.HTTP_400_BAD_REQUEST,{}), status=200)
            obj = ConfigHiringData.objects.get(id=ref_id)
            obj.delete()
            return Response(api_json_response_format(True,"Admin Configuration Details  deleted successfully.",200,{}), status=200)             
        except Exception as error:
            return Response(api_json_response_format(False,"Could not delete Admin Configuration Details ."+str(error),500,{}), status=204) 

@api_view(['GET'])
def design_screen_list_data(request):
    try:
        position_role_list = list(ConfigPositionRole.objects.values_list('position_role', flat=True))
        hiring_plan_id_list = list(HiringPlan.objects.values_list('hiring_plan_id', flat=True))
        screening_type_name_list = list(ConfigScreeningType.objects.values_list('screening_type_name', flat=True))

        # 🎯 Filter requisitions present in InterviewDesignScreen and not incomplete
        # valid_req_ids = InterviewDesignScreen.objects.values_list('req_id', flat=True)
        requisition_id_list = list(
            JobRequisition.objects
            .exclude(Status="Incomplete form")
            # .filter(RequisitionID__in=valid_req_ids)
            .values_list('RequisitionID', flat=True)
        )

        result_data = {
            "position_role": position_role_list,
            "plan_id": hiring_plan_id_list,
            "screening_type": screening_type_name_list,
            "requisition_id": requisition_id_list
        }

        return Response(api_json_response_format(True, "Design Screen Dropdown details", 200, result_data), status=200)

    except Exception as e:
        return Response(api_json_response_format(False, f"Error: {str(e)}", 500, {}), status=200)

@api_view(['GET'])
def design_screen_list_data_interviewer(request):
    try:
        position_role_list = list(ConfigPositionRole.objects.values_list('position_role', flat=True))
        hiring_plan_id_list = list(HiringPlan.objects.values_list('hiring_plan_id', flat=True))
        screening_type_name_list = list(ConfigScreeningType.objects.values_list('screening_type_name', flat=True))

        # 🎯 Filter requisitions present in InterviewDesignScreen and not incomplete
        valid_req_ids = InterviewDesignScreen.objects.values_list('req_id', flat=True)
        requisition_id_list = list(
            JobRequisition.objects
            .exclude(Status="Incomplete form")
            .filter(RequisitionID__in=valid_req_ids)
            .values_list('RequisitionID', flat=True)
        )

        result_data = {
            "position_role": position_role_list,
            "plan_id": hiring_plan_id_list,
            "screening_type": screening_type_name_list,
            "requisition_id": requisition_id_list
        }

        return Response(api_json_response_format(True, "Design Screen Dropdown details", 200, result_data), status=200)

    except Exception as e:
        return Response(api_json_response_format(False, f"Error: {str(e)}", 500, {}), status=200)

@api_view(['POST'])
def client_lookup_from_plan(request):
    try:
        req_id = request.data.get("req_id")
        plan_id = request.data.get("plan_id")

        if not req_id:
            return Response(api_json_response_format(
                False, "'req_id' is required.", 400, {}
            ), status=200)

        filter_kwargs = {"RequisitionID": req_id}
        if plan_id:
            filter_kwargs["Planning_id__hiring_plan_id"] = plan_id

        requisition = JobRequisition.objects.filter(**filter_kwargs).first()

        if not requisition:
            return Response(api_json_response_format(
                False, "No matching requisition found.", 404, {}
            ), status=200)

        data = {
            "client_name": requisition.company_client_name or "Not Provided",
            "client_id": requisition.client_id or "Not Provided"
        }

        return Response(api_json_response_format(
            True, "Client info retrieved.", 200, data
        ), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False, f"Error retrieving client info. {str(e)}", 500, {}
        ), status=200)

@api_view(['POST'])
def job_metadata_lookup(request):
    try:
        req_id = request.data.get("req_id")
        plan_id = request.data.get("plan_id")

        if not req_id:
            return Response(api_json_response_format(
                False, "'req_id' is required.", 400, {}
            ), status=200)

        # 🔍 Find the requisition
        filter_kwargs = {"RequisitionID": req_id}
        if plan_id:
            filter_kwargs["Planning_id__hiring_plan_id"] = plan_id

        requisition = JobRequisition.objects.filter(**filter_kwargs).first()

        if not requisition:
            return Response(api_json_response_format(
                False, "No matching requisition found.", 404, {}
            ), status=200)

        # ✅ Extract hiring_plan_id from requisition (via Planning_id)
        # hiring_plan_id = requisition.Planning_id.hiring_plan_id if requisition.Planning_id else None
        interview_design_id = InterviewDesignScreen.objects.get(req_id=req_id).interview_design_id
        # 🔍 Query InterviewDesignParameters for metadata
        design_params = InterviewDesignParameters.objects.filter(interview_design_id=interview_design_id).order_by("interview_desing_params_id")

        # 💡 Map score_card = stage, screen_type = mode
        stages = [param.score_card for param in design_params]
        modes = [param.screen_type for param in design_params]

        data = {
            "job_position": requisition.PositionTitle or "Not Provided",
            "interview_mode": list(set(modes)) if modes else [],
            "interviewer_stage": list(set(stages)) if stages else []

        }

        return Response(api_json_response_format(
            True, "Job metadata retrieved.", 200, data
        ), status=200)

    except Exception as e:
        return Response(api_json_response_format(
            False, f"Error retrieving job metadata: {str(e)}", 500, {}
        ), status=200)

    

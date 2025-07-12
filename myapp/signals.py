from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import OfferNegotiation, Approver, ApprovalStatus

@receiver(post_save, sender=OfferNegotiation)
def create_approval_statuses(sender, instance, created, **kwargs):
    if created:
        try:
            hiring_plan = getattr(instance.requisition.Planning_id, 'hiring_plan_id', None)
            if hiring_plan:
                approvers = Approver.objects.filter(hiring_plan_id=hiring_plan)
                for approver in approvers:
                    ApprovalStatus.objects.get_or_create(
                        offer_negotiation=instance,
                        approver=approver,
                        defaults={'status': 'Pending'}
                    )
        except Exception as e:
            print(f"[Signal] Failed to create approval statuses: {e}")
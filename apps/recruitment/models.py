"""Staff recruitment: job openings, applicants, interviews, offers."""
from django.db import models

from apps.core.models import TimestampedModel


class OpeningStatus(models.TextChoices):
    OPEN = "open", "Open"
    CLOSED = "closed", "Closed"
    ON_HOLD = "on_hold", "On hold"


class ApplicantStatus(models.TextChoices):
    APPLIED = "applied", "Applied"
    SHORTLISTED = "shortlisted", "Shortlisted"
    INTERVIEWING = "interviewing", "Interviewing"
    OFFERED = "offered", "Offered"
    REJECTED = "rejected", "Rejected"
    JOINED = "joined", "Joined"
    WITHDRAWN = "withdrawn", "Withdrawn"


class RecOfferStatus(models.TextChoices):
    OFFERED = "offered", "Offered"
    ACCEPTED = "accepted", "Accepted"
    DECLINED = "declined", "Declined"
    JOINED = "joined", "Joined"


class JobOpening(TimestampedModel):
    title = models.CharField(max_length=200)
    department = models.ForeignKey(
        "organization.Department", on_delete=models.PROTECT, related_name="openings"
    )
    designation = models.ForeignKey(
        "employees.Designation", on_delete=models.PROTECT, related_name="openings"
    )
    description = models.TextField(blank=True)
    vacancies = models.SmallIntegerField(default=1)
    min_experience_years = models.DecimalField(max_digits=4, decimal_places=1, default=0)
    opened_on = models.DateField()
    closing_on = models.DateField(null=True, blank=True)
    status = models.CharField(
        max_length=16, choices=OpeningStatus.choices, default=OpeningStatus.OPEN
    )


class JobApplicant(TimestampedModel):
    opening = models.ForeignKey(JobOpening, on_delete=models.CASCADE, related_name="applicants")
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField()
    phone = models.CharField(max_length=20, blank=True)
    resume = models.FileField(upload_to="recruitment/resumes/", null=True, blank=True)
    years_of_experience = models.DecimalField(max_digits=4, decimal_places=1, null=True, blank=True)
    current_ctc = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    expected_ctc = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    applied_on = models.DateField(auto_now_add=True)
    status = models.CharField(
        max_length=16, choices=ApplicantStatus.choices, default=ApplicantStatus.APPLIED
    )


class RecruitmentInterview(TimestampedModel):
    applicant = models.ForeignKey(JobApplicant, on_delete=models.CASCADE, related_name="interviews")
    round_no = models.SmallIntegerField(default=1)
    scheduled_at = models.DateTimeField()
    interviewer = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True
    )
    feedback = models.TextField(blank=True)
    rating = models.SmallIntegerField(null=True, blank=True)
    result = models.CharField(max_length=16, default="pending")


class RecruitmentOffer(TimestampedModel):
    applicant = models.OneToOneField(JobApplicant, on_delete=models.CASCADE, related_name="offer")
    offered_on = models.DateField()
    ctc = models.DecimalField(max_digits=12, decimal_places=2)
    joining_date = models.DateField(null=True, blank=True)
    offer_letter = models.FileField(upload_to="recruitment/offers/", null=True, blank=True)
    status = models.CharField(
        max_length=16, choices=RecOfferStatus.choices, default=RecOfferStatus.OFFERED
    )

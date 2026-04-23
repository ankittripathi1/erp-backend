"""Student placements: companies, drives, job postings, applications, interviews, offers."""
from django.db import models

from apps.core.models import TimestampedModel


class PlacementApplicationStatus(models.TextChoices):
    APPLIED = "applied", "Applied"
    SHORTLISTED = "shortlisted", "Shortlisted"
    IN_PROCESS = "in_process", "In process"
    REJECTED = "rejected", "Rejected"
    OFFERED = "offered", "Offered"
    ACCEPTED = "accepted", "Accepted"
    DECLINED = "declined", "Declined"


class OfferStatus(models.TextChoices):
    OFFERED = "offered", "Offered"
    ACCEPTED = "accepted", "Accepted"
    DECLINED = "declined", "Declined"
    WITHDRAWN = "withdrawn", "Withdrawn"


class InterviewResultStatus(models.TextChoices):
    PENDING = "pending", "Pending"
    SELECTED = "selected", "Selected"
    REJECTED = "rejected", "Rejected"
    ON_HOLD = "on_hold", "On hold"


class Company(TimestampedModel):
    name = models.CharField(max_length=200, unique=True)
    website = models.URLField(blank=True)
    industry = models.CharField(max_length=128, blank=True)
    hq_location = models.CharField(max_length=200, blank=True)
    contact_name = models.CharField(max_length=200, blank=True)
    contact_email = models.EmailField(blank=True)
    contact_phone = models.CharField(max_length=20, blank=True)

    def __str__(self) -> str:
        return self.name


class PlacementDrive(TimestampedModel):
    company = models.ForeignKey(Company, on_delete=models.PROTECT, related_name="drives")
    academic_year = models.ForeignKey(
        "academic.AcademicYear", on_delete=models.PROTECT, related_name="drives"
    )
    name = models.CharField(max_length=200)
    start_date = models.DateField()
    end_date = models.DateField(null=True, blank=True)
    eligibility_criteria = models.TextField(blank=True)


class JobPosting(TimestampedModel):
    drive = models.ForeignKey(PlacementDrive, on_delete=models.CASCADE, related_name="postings")
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    role_type = models.CharField(max_length=64, help_text="e.g. internship / fte / part-time")
    ctc = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    stipend = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    location = models.CharField(max_length=200, blank=True)
    min_cgpa = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True)
    eligible_programs = models.ManyToManyField(
        "academic.Program", blank=True, related_name="job_postings"
    )
    apply_by = models.DateField()


class PlacementApplication(TimestampedModel):
    posting = models.ForeignKey(JobPosting, on_delete=models.CASCADE, related_name="applications")
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="placement_applications"
    )
    applied_on = models.DateTimeField(auto_now_add=True)
    resume = models.FileField(upload_to="placements/resumes/", null=True, blank=True)
    status = models.CharField(
        max_length=16,
        choices=PlacementApplicationStatus.choices,
        default=PlacementApplicationStatus.APPLIED,
    )

    class Meta:
        unique_together = [("posting", "student")]


class PlacementInterviewRound(TimestampedModel):
    posting = models.ForeignKey(JobPosting, on_delete=models.CASCADE, related_name="rounds")
    round_no = models.SmallIntegerField()
    name = models.CharField(max_length=128, help_text="e.g. Aptitude, Technical 1, HR")
    scheduled_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = [("posting", "round_no")]
        ordering = ("posting", "round_no")


class PlacementInterviewResult(TimestampedModel):
    application = models.ForeignKey(
        PlacementApplication, on_delete=models.CASCADE, related_name="round_results"
    )
    round = models.ForeignKey(
        PlacementInterviewRound, on_delete=models.CASCADE, related_name="results"
    )
    result = models.CharField(
        max_length=16,
        choices=InterviewResultStatus.choices,
        default=InterviewResultStatus.PENDING,
    )
    remarks = models.TextField(blank=True)

    class Meta:
        unique_together = [("application", "round")]


class PlacementOffer(TimestampedModel):
    application = models.OneToOneField(
        PlacementApplication, on_delete=models.CASCADE, related_name="offer"
    )
    offered_on = models.DateField()
    ctc = models.DecimalField(max_digits=12, decimal_places=2)
    joining_date = models.DateField(null=True, blank=True)
    offer_letter = models.FileField(upload_to="placements/offers/", null=True, blank=True)
    status = models.CharField(
        max_length=16, choices=OfferStatus.choices, default=OfferStatus.OFFERED
    )

"""Applications, Student profile, Guardians, Enrollments."""
from django.db import models

from apps.core.models import Address, TimestampedModel, User


class ApplicationStatus(models.TextChoices):
    SUBMITTED = "submitted", "Submitted"
    UNDER_REVIEW = "under_review", "Under review"
    SHORTLISTED = "shortlisted", "Shortlisted"
    OFFERED = "offered", "Offered"
    ACCEPTED = "accepted", "Accepted"
    REJECTED = "rejected", "Rejected"
    WITHDRAWN = "withdrawn", "Withdrawn"


class AdmissionType(models.TextChoices):
    REGULAR = "regular", "Regular"
    LATERAL = "lateral", "Lateral entry"
    TRANSFER = "transfer", "Transfer"


class StudentStatus(models.TextChoices):
    ACTIVE = "active", "Active"
    ON_LEAVE = "on_leave", "On leave"
    GRADUATED = "graduated", "Graduated"
    DROPPED = "dropped", "Dropped"
    SUSPENDED = "suspended", "Suspended"
    TRANSFERRED = "transferred", "Transferred"


class GuardianRelation(models.TextChoices):
    FATHER = "father", "Father"
    MOTHER = "mother", "Mother"
    GUARDIAN = "guardian", "Guardian"
    SPOUSE = "spouse", "Spouse"
    SIBLING = "sibling", "Sibling"


class EnrollmentStatus(models.TextChoices):
    ENROLLED = "enrolled", "Enrolled"
    DROPPED = "dropped", "Dropped"
    COMPLETED = "completed", "Completed"
    FAILED = "failed", "Failed"


class Application(TimestampedModel):
    application_no = models.CharField(max_length=32, unique=True)
    program = models.ForeignKey(
        "academic.Program", on_delete=models.PROTECT, related_name="applications"
    )
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField()
    phone = models.CharField(max_length=20)
    date_of_birth = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=24, blank=True)
    previous_qualification = models.CharField(max_length=128, blank=True)
    previous_percentage = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    entrance_exam = models.CharField(max_length=64, blank=True)
    entrance_score = models.DecimalField(max_digits=7, decimal_places=2, null=True, blank=True)
    status = models.CharField(
        max_length=24, choices=ApplicationStatus.choices, default=ApplicationStatus.SUBMITTED
    )
    applied_on = models.DateField(auto_now_add=True)
    decision_on = models.DateField(null=True, blank=True)

    def __str__(self) -> str:
        return f"{self.application_no} — {self.first_name} {self.last_name}"


class Student(TimestampedModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="student_profile")
    enrollment_no = models.CharField(max_length=32, unique=True)
    roll_no = models.CharField(max_length=32)
    program = models.ForeignKey("academic.Program", on_delete=models.PROTECT, related_name="students")
    batch = models.ForeignKey("academic.Batch", on_delete=models.PROTECT, related_name="students")
    current_term = models.ForeignKey(
        "academic.AcademicTerm", on_delete=models.SET_NULL, null=True, blank=True
    )
    current_section = models.ForeignKey(
        "academic.Section", on_delete=models.SET_NULL, null=True, blank=True, related_name="students"
    )
    admission_date = models.DateField()
    admission_type = models.CharField(
        max_length=24, choices=AdmissionType.choices, default=AdmissionType.REGULAR
    )
    category = models.CharField(max_length=16, blank=True, help_text="e.g. general / obc / sc / st / ews")
    religion = models.CharField(max_length=32, blank=True)
    nationality = models.CharField(max_length=64, default="Indian")
    blood_group = models.CharField(max_length=5, blank=True)
    aadhaar_no = models.CharField(max_length=20, blank=True)
    pan_no = models.CharField(max_length=20, blank=True)
    status = models.CharField(
        max_length=24, choices=StudentStatus.choices, default=StudentStatus.ACTIVE
    )

    class Meta:
        unique_together = [("batch", "current_section", "roll_no")]

    def __str__(self) -> str:
        return f"{self.enrollment_no} — {self.user.full_name()}"


class Guardian(TimestampedModel):
    user = models.OneToOneField(
        User, on_delete=models.SET_NULL, null=True, blank=True, related_name="guardian_profile"
    )
    name = models.CharField(max_length=200)
    relation = models.CharField(max_length=32, choices=GuardianRelation.choices)
    occupation = models.CharField(max_length=128, blank=True)
    annual_income = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    phone = models.CharField(max_length=20, blank=True)
    email = models.EmailField(blank=True)
    address = models.ForeignKey(Address, on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self) -> str:
        return f"{self.name} ({self.relation})"


class StudentGuardian(TimestampedModel):
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name="guardian_links")
    guardian = models.ForeignKey(Guardian, on_delete=models.CASCADE, related_name="student_links")
    is_primary = models.BooleanField(default=False)

    class Meta:
        unique_together = [("student", "guardian")]


class StudentEnrollment(TimestampedModel):
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name="enrollments")
    offering = models.ForeignKey(
        "courses.CourseOffering", on_delete=models.CASCADE, related_name="enrollments"
    )
    enrolled_on = models.DateField(auto_now_add=True)
    status = models.CharField(
        max_length=16, choices=EnrollmentStatus.choices, default=EnrollmentStatus.ENROLLED
    )

    class Meta:
        unique_together = [("student", "offering")]

    def __str__(self) -> str:
        return f"{self.student.enrollment_no} → {self.offering}"

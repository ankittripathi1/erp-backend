"""Employee profile + Designation + Qualifications + WorkExperience."""
from django.db import models

from apps.core.models import TimestampedModel, User


class DesignationCategory(models.TextChoices):
    TEACHING = "teaching", "Teaching"
    NON_TEACHING = "non_teaching", "Non-teaching"
    ADMIN = "admin", "Admin"
    SUPPORT = "support", "Support"


class EmploymentType(models.TextChoices):
    PERMANENT = "permanent", "Permanent"
    CONTRACT = "contract", "Contract"
    VISITING = "visiting", "Visiting"
    ADJUNCT = "adjunct", "Adjunct"
    INTERN = "intern", "Intern"


class EmployeeStatus(models.TextChoices):
    ACTIVE = "active", "Active"
    ON_LEAVE = "on_leave", "On leave"
    RESIGNED = "resigned", "Resigned"
    TERMINATED = "terminated", "Terminated"
    RETIRED = "retired", "Retired"


class Designation(TimestampedModel):
    name = models.CharField(max_length=128, unique=True)
    category = models.CharField(
        max_length=24, choices=DesignationCategory.choices, default=DesignationCategory.TEACHING
    )

    def __str__(self) -> str:
        return self.name


class Employee(TimestampedModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="employee_profile")
    employee_no = models.CharField(max_length=32, unique=True)
    department = models.ForeignKey(
        "organization.Department",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="employees",
    )
    designation = models.ForeignKey(Designation, on_delete=models.PROTECT, related_name="employees")
    reports_to = models.ForeignKey(
        "self", on_delete=models.SET_NULL, null=True, blank=True, related_name="reports"
    )
    employment_type = models.CharField(
        max_length=24, choices=EmploymentType.choices, default=EmploymentType.PERMANENT
    )
    joining_date = models.DateField()
    confirmation_date = models.DateField(null=True, blank=True)
    exit_date = models.DateField(null=True, blank=True)
    status = models.CharField(
        max_length=24, choices=EmployeeStatus.choices, default=EmployeeStatus.ACTIVE
    )
    pan_no = models.CharField(max_length=20, blank=True)
    aadhaar_no = models.CharField(max_length=20, blank=True)
    pf_no = models.CharField(max_length=32, blank=True)
    uan_no = models.CharField(max_length=32, blank=True)
    bank_account_no = models.CharField(max_length=32, blank=True)
    bank_ifsc = models.CharField(max_length=16, blank=True)

    def __str__(self) -> str:
        return f"{self.employee_no} — {self.user.full_name()}"


class Qualification(TimestampedModel):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE, related_name="qualifications")
    degree = models.CharField(max_length=128)
    institution = models.CharField(max_length=200)
    year = models.SmallIntegerField(null=True, blank=True)
    percentage = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    specialization = models.CharField(max_length=128, blank=True)

    def __str__(self) -> str:
        return f"{self.degree} ({self.employee.employee_no})"


class WorkExperience(TimestampedModel):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE, related_name="experience")
    company = models.CharField(max_length=200)
    role = models.CharField(max_length=128)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    description = models.TextField(blank=True)

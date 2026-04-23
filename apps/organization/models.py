"""Institute → Campus → School → Department."""
from django.db import models

from apps.core.models import Address, TimestampedModel


class Institute(TimestampedModel):
    name = models.CharField(max_length=200)
    short_code = models.CharField(max_length=32, unique=True)
    established_on = models.DateField(null=True, blank=True)
    logo = models.ImageField(upload_to="institute/", null=True, blank=True)
    website = models.URLField(blank=True)
    email = models.EmailField(blank=True)
    phone = models.CharField(max_length=20, blank=True)
    address = models.ForeignKey(Address, on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self) -> str:
        return self.name


class Campus(TimestampedModel):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, related_name="campuses")
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=32)
    address = models.ForeignKey(Address, on_delete=models.SET_NULL, null=True, blank=True)

    class Meta:
        unique_together = [("institute", "code")]

    def __str__(self) -> str:
        return f"{self.institute.short_code} / {self.name}"


class School(TimestampedModel):
    """Faculty, e.g. School of Engineering, School of Computer Applications."""

    campus = models.ForeignKey(Campus, on_delete=models.CASCADE, related_name="schools")
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=32)
    dean = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True, related_name="dean_of"
    )

    class Meta:
        unique_together = [("campus", "code")]

    def __str__(self) -> str:
        return self.name


class Department(TimestampedModel):
    school = models.ForeignKey(School, on_delete=models.CASCADE, related_name="departments")
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=32)
    hod = models.ForeignKey(
        "employees.Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="head_of_department",
    )

    class Meta:
        unique_together = [("school", "code")]

    def __str__(self) -> str:
        return f"{self.school.name} / {self.name}"

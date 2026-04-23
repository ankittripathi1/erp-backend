"""AcademicYear, AcademicTerm, Program, Batch, Section."""
from django.db import models

from apps.core.models import TimestampedModel


class TermType(models.TextChoices):
    SEMESTER = "semester", "Semester"
    TRIMESTER = "trimester", "Trimester"
    ANNUAL = "annual", "Annual"


class ProgramLevel(models.TextChoices):
    UG = "undergraduate", "Undergraduate"
    PG = "postgraduate", "Postgraduate"
    DOCTORAL = "doctoral", "Doctoral"
    DIPLOMA = "diploma", "Diploma"


class AcademicYear(TimestampedModel):
    name = models.CharField(max_length=32, unique=True, help_text="e.g. 2025-2026")
    start_date = models.DateField()
    end_date = models.DateField()
    is_current = models.BooleanField(default=False)

    class Meta:
        ordering = ("-start_date",)

    def __str__(self) -> str:
        return self.name


class AcademicTerm(TimestampedModel):
    academic_year = models.ForeignKey(AcademicYear, on_delete=models.CASCADE, related_name="terms")
    name = models.CharField(max_length=32)
    term_type = models.CharField(max_length=16, choices=TermType.choices, default=TermType.SEMESTER)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    is_current = models.BooleanField(default=False)

    class Meta:
        unique_together = [("academic_year", "name")]
        ordering = ("academic_year", "start_date")

    def __str__(self) -> str:
        return f"{self.academic_year.name} — {self.name}"


class Program(TimestampedModel):
    department = models.ForeignKey(
        "organization.Department", on_delete=models.CASCADE, related_name="programs"
    )
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=32)
    level = models.CharField(max_length=24, choices=ProgramLevel.choices)
    duration_years = models.DecimalField(max_digits=3, decimal_places=1)
    total_terms = models.SmallIntegerField()
    total_credits = models.SmallIntegerField(null=True, blank=True)
    grading_scheme = models.ForeignKey(
        "grading.GradingScheme",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="programs",
    )
    description = models.TextField(blank=True)

    class Meta:
        unique_together = [("department", "code")]

    def __str__(self) -> str:
        return f"{self.code} — {self.name}"


class Batch(TimestampedModel):
    program = models.ForeignKey(Program, on_delete=models.CASCADE, related_name="batches")
    name = models.CharField(max_length=64)
    start_year = models.SmallIntegerField()
    end_year = models.SmallIntegerField()
    max_strength = models.IntegerField(null=True, blank=True)

    class Meta:
        unique_together = [("program", "name")]

    def __str__(self) -> str:
        return f"{self.program.code} {self.name}"


class Section(TimestampedModel):
    batch = models.ForeignKey(Batch, on_delete=models.CASCADE, related_name="sections")
    term = models.ForeignKey(AcademicTerm, on_delete=models.CASCADE, related_name="sections")
    name = models.CharField(max_length=32)
    class_teacher = models.ForeignKey(
        "employees.Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="class_teacher_of",
    )
    max_strength = models.IntegerField(null=True, blank=True)

    class Meta:
        unique_together = [("batch", "term", "name")]

    def __str__(self) -> str:
        return f"{self.batch} / {self.term} / {self.name}"

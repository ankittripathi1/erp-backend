"""Configurable grading schemes: percentage / letter / gpa."""
from django.db import models

from apps.core.models import TimestampedModel


class SchemeType(models.TextChoices):
    PERCENTAGE = "percentage", "Percentage"
    LETTER = "letter", "Letter grade"
    GPA = "gpa", "GPA"


class GradingScheme(TimestampedModel):
    name = models.CharField(max_length=128, unique=True)
    scheme_type = models.CharField(max_length=16, choices=SchemeType.choices)
    max_grade_points = models.DecimalField(
        max_digits=4, decimal_places=2, null=True, blank=True, help_text="e.g., 10.00 for 10-point GPA"
    )
    pass_threshold = models.DecimalField(
        max_digits=6, decimal_places=2, help_text="Minimum percentage / grade_points to pass"
    )
    description = models.TextField(blank=True)

    def __str__(self) -> str:
        return f"{self.name} ({self.scheme_type})"


class GradeBand(TimestampedModel):
    scheme = models.ForeignKey(GradingScheme, on_delete=models.CASCADE, related_name="bands")
    band_code = models.CharField(max_length=16, help_text="e.g. A+, A, First Class, 80-89")
    min_percentage = models.DecimalField(max_digits=6, decimal_places=2)
    max_percentage = models.DecimalField(max_digits=6, decimal_places=2)
    grade_points = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True)
    is_pass = models.BooleanField(default=True)
    sort_order = models.SmallIntegerField(default=0)

    class Meta:
        ordering = ("scheme", "-min_percentage")
        unique_together = [("scheme", "band_code")]

    def __str__(self) -> str:
        return f"{self.scheme.name}: {self.band_code} ({self.min_percentage}-{self.max_percentage})"


class GradeConversionRule(TimestampedModel):
    """Optional — explicit cross-scheme conversion, e.g. CGPA → Percentage."""

    from_scheme = models.ForeignKey(
        GradingScheme, on_delete=models.CASCADE, related_name="conversions_from"
    )
    to_scheme = models.ForeignKey(
        GradingScheme, on_delete=models.CASCADE, related_name="conversions_to"
    )
    formula = models.CharField(
        max_length=255, help_text="e.g. 'CGPA * 9.5' (common 10-pt to percentage conversion)"
    )
    description = models.TextField(blank=True)

    class Meta:
        unique_together = [("from_scheme", "to_scheme")]

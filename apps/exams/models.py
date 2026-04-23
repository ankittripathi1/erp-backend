"""Exams, schedules, marks, and results."""
from django.db import models

from apps.core.models import TimestampedModel


class ExamType(TimestampedModel):
    name = models.CharField(max_length=64, unique=True, help_text="e.g. Mid Sem, End Sem, Quiz, Viva")

    def __str__(self) -> str:
        return self.name


class Exam(TimestampedModel):
    term = models.ForeignKey("academic.AcademicTerm", on_delete=models.CASCADE, related_name="exams")
    exam_type = models.ForeignKey(ExamType, on_delete=models.PROTECT)
    name = models.CharField(max_length=128)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)

    def __str__(self) -> str:
        return f"{self.name} ({self.term})"


class ExamSchedule(TimestampedModel):
    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name="schedules")
    offering = models.ForeignKey(
        "courses.CourseOffering", on_delete=models.CASCADE, related_name="exam_schedules"
    )
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    room = models.ForeignKey(
        "timetable.Room", on_delete=models.SET_NULL, null=True, blank=True
    )
    max_marks = models.DecimalField(max_digits=6, decimal_places=2)
    min_passing = models.DecimalField(max_digits=6, decimal_places=2)
    weight = models.DecimalField(max_digits=5, decimal_places=2, help_text="% contribution to final")


class StudentMark(TimestampedModel):
    schedule = models.ForeignKey(ExamSchedule, on_delete=models.CASCADE, related_name="marks")
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="exam_marks"
    )
    marks_obtained = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    is_absent = models.BooleanField(default=False)
    remarks = models.CharField(max_length=255, blank=True)

    class Meta:
        unique_together = [("schedule", "student")]


class StudentCourseResult(TimestampedModel):
    """Final grade per course per student — snapshotted at finalize-time."""

    enrollment = models.OneToOneField(
        "students.StudentEnrollment", on_delete=models.CASCADE, related_name="result"
    )
    total_percentage = models.DecimalField(max_digits=6, decimal_places=2)
    grade_band = models.ForeignKey(
        "grading.GradeBand", on_delete=models.SET_NULL, null=True, blank=True
    )
    grade_letter = models.CharField(max_length=8, blank=True)
    grade_points = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True)
    credits_earned = models.DecimalField(max_digits=4, decimal_places=1, default=0)
    finalized_on = models.DateField(null=True, blank=True)


class StudentTermResult(TimestampedModel):
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="term_results"
    )
    term = models.ForeignKey("academic.AcademicTerm", on_delete=models.CASCADE)
    sgpa = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    total_credits = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    percentage = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)

    class Meta:
        unique_together = [("student", "term")]


class StudentCumulativeResult(TimestampedModel):
    student = models.OneToOneField(
        "students.Student", on_delete=models.CASCADE, related_name="cumulative_result"
    )
    cgpa = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    percentage = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    total_credits_earned = models.DecimalField(max_digits=7, decimal_places=1, default=0)

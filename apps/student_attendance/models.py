"""Per-lecture attendance sessions + StudentAttendance."""
from django.db import models

from apps.core.models import TimestampedModel


class StudentAttendanceStatus(models.TextChoices):
    PRESENT = "present", "Present"
    ABSENT = "absent", "Absent"
    LATE = "late", "Late"
    EXCUSED = "excused", "Excused"


class AttendanceSession(TimestampedModel):
    offering = models.ForeignKey(
        "courses.CourseOffering", on_delete=models.CASCADE, related_name="attendance_sessions"
    )
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    room = models.ForeignKey(
        "timetable.Room", on_delete=models.SET_NULL, null=True, blank=True, related_name="sessions_held"
    )
    taken_by = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True
    )

    class Meta:
        unique_together = [("offering", "date", "start_time")]


class StudentAttendance(TimestampedModel):
    session = models.ForeignKey(
        AttendanceSession, on_delete=models.CASCADE, related_name="student_attendances"
    )
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="attendance_records"
    )
    status = models.CharField(
        max_length=16,
        choices=StudentAttendanceStatus.choices,
        default=StudentAttendanceStatus.PRESENT,
    )
    remarks = models.CharField(max_length=255, blank=True)

    class Meta:
        unique_together = [("session", "student")]

"""Staff leave management + attendance + shifts + holidays."""
from django.db import models

from apps.core.models import TimestampedModel


class LeaveStatus(models.TextChoices):
    PENDING = "pending", "Pending"
    APPROVED = "approved", "Approved"
    REJECTED = "rejected", "Rejected"
    CANCELLED = "cancelled", "Cancelled"


class AttendanceStatus(models.TextChoices):
    PRESENT = "present", "Present"
    ABSENT = "absent", "Absent"
    LATE = "late", "Late"
    HALF_DAY = "half_day", "Half day"
    ON_LEAVE = "on_leave", "On leave"
    HOLIDAY = "holiday", "Holiday"
    WEEKLY_OFF = "weekly_off", "Weekly off"


class AttendanceSource(models.TextChoices):
    MANUAL = "manual", "Manual"
    BIOMETRIC = "biometric", "Biometric"
    IMPORT = "import", "Import"


class LeaveType(TimestampedModel):
    code = models.CharField(max_length=16, unique=True)
    name = models.CharField(max_length=64)
    is_paid = models.BooleanField(default=True)

    def __str__(self) -> str:
        return self.name


class LeavePolicy(TimestampedModel):
    leave_type = models.ForeignKey(LeaveType, on_delete=models.CASCADE, related_name="policies")
    designation = models.ForeignKey(
        "employees.Designation", on_delete=models.CASCADE, null=True, blank=True
    )
    employment_type = models.CharField(max_length=24, blank=True)
    annual_quota = models.DecimalField(max_digits=5, decimal_places=1)


class LeaveBalance(TimestampedModel):
    employee = models.ForeignKey(
        "employees.Employee", on_delete=models.CASCADE, related_name="leave_balances"
    )
    leave_type = models.ForeignKey(LeaveType, on_delete=models.CASCADE)
    year = models.SmallIntegerField()
    balance = models.DecimalField(max_digits=5, decimal_places=1)

    class Meta:
        unique_together = [("employee", "leave_type", "year")]


class LeaveApplication(TimestampedModel):
    employee = models.ForeignKey(
        "employees.Employee", on_delete=models.CASCADE, related_name="leave_applications"
    )
    leave_type = models.ForeignKey(LeaveType, on_delete=models.PROTECT)
    from_date = models.DateField()
    to_date = models.DateField()
    half_day = models.BooleanField(default=False)
    reason = models.TextField(blank=True)
    status = models.CharField(max_length=16, choices=LeaveStatus.choices, default=LeaveStatus.PENDING)
    approved_by = models.ForeignKey(
        "employees.Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="leaves_approved",
    )
    approved_on = models.DateTimeField(null=True, blank=True)


class HolidayList(TimestampedModel):
    name = models.CharField(max_length=128)
    academic_year = models.ForeignKey(
        "academic.AcademicYear", on_delete=models.CASCADE, related_name="holiday_lists"
    )


class Holiday(TimestampedModel):
    holiday_list = models.ForeignKey(HolidayList, on_delete=models.CASCADE, related_name="holidays")
    date = models.DateField()
    name = models.CharField(max_length=128)
    is_optional = models.BooleanField(default=False)

    class Meta:
        unique_together = [("holiday_list", "date")]


class Shift(TimestampedModel):
    name = models.CharField(max_length=64, unique=True)
    start_time = models.TimeField()
    end_time = models.TimeField()
    grace_minutes = models.SmallIntegerField(default=10)


class EmployeeAttendance(TimestampedModel):
    employee = models.ForeignKey(
        "employees.Employee", on_delete=models.CASCADE, related_name="attendance"
    )
    date = models.DateField()
    shift = models.ForeignKey(Shift, on_delete=models.SET_NULL, null=True, blank=True)
    check_in = models.DateTimeField(null=True, blank=True)
    check_out = models.DateTimeField(null=True, blank=True)
    status = models.CharField(
        max_length=16, choices=AttendanceStatus.choices, default=AttendanceStatus.PRESENT
    )
    source = models.CharField(
        max_length=16, choices=AttendanceSource.choices, default=AttendanceSource.MANUAL
    )

    class Meta:
        unique_together = [("employee", "date")]

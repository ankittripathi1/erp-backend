"""Hostels, blocks, floors, rooms; allocation; mess; visitors; leaves."""
from django.db import models

from apps.core.models import TimestampedModel


class HostelType(models.TextChoices):
    BOYS = "boys", "Boys"
    GIRLS = "girls", "Girls"
    COED = "coed", "Co-ed"


class RoomOccupancyType(models.TextChoices):
    SINGLE = "single", "Single"
    DOUBLE = "double", "Double"
    TRIPLE = "triple", "Triple"
    DORMITORY = "dormitory", "Dormitory"


class RoomAllocationStatus(models.TextChoices):
    ACTIVE = "active", "Active"
    RELEASED = "released", "Released"


class VisitorStatus(models.TextChoices):
    IN = "in", "In"
    OUT = "out", "Out"


class HostelLeaveStatus(models.TextChoices):
    PENDING = "pending", "Pending"
    APPROVED = "approved", "Approved"
    REJECTED = "rejected", "Rejected"
    COMPLETED = "completed", "Completed"


class Hostel(TimestampedModel):
    name = models.CharField(max_length=128)
    code = models.CharField(max_length=32, unique=True)
    campus = models.ForeignKey(
        "organization.Campus", on_delete=models.PROTECT, related_name="hostels"
    )
    hostel_type = models.CharField(max_length=16, choices=HostelType.choices)
    warden = models.ForeignKey(
        "employees.Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="warden_of",
    )
    total_capacity = models.IntegerField(default=0)

    def __str__(self) -> str:
        return self.name


class HostelBlock(TimestampedModel):
    hostel = models.ForeignKey(Hostel, on_delete=models.CASCADE, related_name="blocks")
    name = models.CharField(max_length=64)
    total_floors = models.SmallIntegerField(default=1)

    class Meta:
        unique_together = [("hostel", "name")]


class HostelFloor(TimestampedModel):
    block = models.ForeignKey(HostelBlock, on_delete=models.CASCADE, related_name="floors")
    floor_number = models.SmallIntegerField()

    class Meta:
        unique_together = [("block", "floor_number")]


class HostelRoom(TimestampedModel):
    floor = models.ForeignKey(HostelFloor, on_delete=models.CASCADE, related_name="rooms")
    room_no = models.CharField(max_length=32)
    occupancy_type = models.CharField(
        max_length=16, choices=RoomOccupancyType.choices, default=RoomOccupancyType.DOUBLE
    )
    capacity = models.SmallIntegerField()
    monthly_rent = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    class Meta:
        unique_together = [("floor", "room_no")]

    def __str__(self) -> str:
        return f"{self.floor.block.hostel.code}-{self.floor.block.name}-{self.room_no}"


class HostelApplication(TimestampedModel):
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="hostel_applications"
    )
    preferred_hostel = models.ForeignKey(
        Hostel, on_delete=models.SET_NULL, null=True, blank=True, related_name="applications"
    )
    applied_on = models.DateField(auto_now_add=True)
    academic_year = models.ForeignKey("academic.AcademicYear", on_delete=models.PROTECT)
    status = models.CharField(max_length=16, default="submitted")
    remarks = models.TextField(blank=True)


class RoomAllocation(TimestampedModel):
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="room_allocations"
    )
    room = models.ForeignKey(HostelRoom, on_delete=models.PROTECT, related_name="allocations")
    allocated_from = models.DateField()
    allocated_to = models.DateField(null=True, blank=True)
    status = models.CharField(
        max_length=16,
        choices=RoomAllocationStatus.choices,
        default=RoomAllocationStatus.ACTIVE,
    )

    class Meta:
        constraints = [
            # A student can have only one ACTIVE allocation at a time.
            models.UniqueConstraint(
                fields=["student"],
                condition=models.Q(status="active"),
                name="uniq_active_allocation_per_student",
            ),
        ]
        indexes = [models.Index(fields=["room", "status"])]


class Mess(TimestampedModel):
    hostel = models.ForeignKey(Hostel, on_delete=models.CASCADE, related_name="messes")
    name = models.CharField(max_length=128)
    monthly_charge = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    contractor = models.CharField(max_length=200, blank=True)


class MessMenu(TimestampedModel):
    mess = models.ForeignKey(Mess, on_delete=models.CASCADE, related_name="menus")
    day_of_week = models.SmallIntegerField()
    meal_type = models.CharField(max_length=16, help_text="breakfast/lunch/snacks/dinner")
    items = models.TextField()

    class Meta:
        unique_together = [("mess", "day_of_week", "meal_type")]


class MessBill(TimestampedModel):
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="mess_bills"
    )
    mess = models.ForeignKey(Mess, on_delete=models.PROTECT)
    period_start = models.DateField()
    period_end = models.DateField()
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    paid = models.BooleanField(default=False)


class HostelVisitor(TimestampedModel):
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="visitors"
    )
    visitor_name = models.CharField(max_length=200)
    relation = models.CharField(max_length=64, blank=True)
    phone = models.CharField(max_length=20, blank=True)
    id_proof = models.CharField(max_length=64, blank=True)
    in_time = models.DateTimeField()
    out_time = models.DateTimeField(null=True, blank=True)
    status = models.CharField(max_length=8, choices=VisitorStatus.choices, default=VisitorStatus.IN)


class HostelLeave(TimestampedModel):
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="hostel_leaves"
    )
    from_date = models.DateField()
    to_date = models.DateField()
    destination = models.CharField(max_length=200, blank=True)
    reason = models.TextField(blank=True)
    status = models.CharField(
        max_length=16, choices=HostelLeaveStatus.choices, default=HostelLeaveStatus.PENDING
    )
    approved_by = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True
    )

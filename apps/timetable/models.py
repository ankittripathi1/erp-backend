"""Rooms + TimeSlots + TimetableEntries."""
from django.db import models

from apps.core.models import TimestampedModel


class RoomType(models.TextChoices):
    LECTURE_HALL = "lecture_hall", "Lecture Hall"
    LAB = "lab", "Lab"
    SEMINAR = "seminar", "Seminar"
    AUDITORIUM = "auditorium", "Auditorium"
    TUTORIAL = "tutorial", "Tutorial"


class Room(TimestampedModel):
    campus = models.ForeignKey(
        "organization.Campus", on_delete=models.CASCADE, related_name="rooms"
    )
    building = models.CharField(max_length=64, blank=True)
    floor = models.SmallIntegerField(null=True, blank=True)
    room_no = models.CharField(max_length=32)
    room_type = models.CharField(max_length=16, choices=RoomType.choices, default=RoomType.LECTURE_HALL)
    capacity = models.IntegerField(default=0)
    has_projector = models.BooleanField(default=False)
    has_ac = models.BooleanField(default=False)

    class Meta:
        unique_together = [("campus", "building", "room_no")]

    def __str__(self) -> str:
        return f"{self.campus.name} {self.building} {self.room_no}"


class TimeSlot(TimestampedModel):
    day_of_week = models.SmallIntegerField(help_text="0=Mon .. 6=Sun")
    start_time = models.TimeField()
    end_time = models.TimeField()
    name = models.CharField(max_length=32, blank=True)

    class Meta:
        unique_together = [("day_of_week", "start_time", "end_time")]
        ordering = ("day_of_week", "start_time")


class TimetableEntry(TimestampedModel):
    section = models.ForeignKey(
        "academic.Section", on_delete=models.CASCADE, related_name="timetable"
    )
    offering = models.ForeignKey(
        "courses.CourseOffering", on_delete=models.CASCADE, related_name="timetable_entries"
    )
    time_slot = models.ForeignKey(TimeSlot, on_delete=models.PROTECT, related_name="entries")
    teacher = models.ForeignKey(
        "employees.Employee", on_delete=models.PROTECT, related_name="timetable_entries"
    )
    room = models.ForeignKey(Room, on_delete=models.PROTECT, related_name="timetable_entries")
    effective_from = models.DateField()
    effective_to = models.DateField(null=True, blank=True)

    class Meta:
        # Hard DB constraints: prevent double-booking teacher / room / section
        constraints = [
            models.UniqueConstraint(
                fields=["time_slot", "teacher"], name="uniq_teacher_per_slot"
            ),
            models.UniqueConstraint(
                fields=["time_slot", "room"], name="uniq_room_per_slot"
            ),
            models.UniqueConstraint(
                fields=["time_slot", "section"], name="uniq_section_per_slot"
            ),
        ]

"""Alumni profiles, events, donations."""
from django.db import models

from apps.core.models import TimestampedModel, User


class AlumniEventType(models.TextChoices):
    REUNION = "reunion", "Reunion"
    MEETUP = "meetup", "Meetup"
    WEBINAR = "webinar", "Webinar"
    FUNDRAISER = "fundraiser", "Fundraiser"
    CONFERENCE = "conference", "Conference"


class Alumni(TimestampedModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="alumni_profile")
    student = models.OneToOneField(
        "students.Student",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="alumni_profile",
    )
    program = models.ForeignKey(
        "academic.Program", on_delete=models.SET_NULL, null=True, blank=True
    )
    batch = models.ForeignKey(
        "academic.Batch", on_delete=models.SET_NULL, null=True, blank=True
    )
    graduation_year = models.SmallIntegerField()
    current_company = models.CharField(max_length=200, blank=True)
    current_role = models.CharField(max_length=128, blank=True)
    linkedin_url = models.URLField(blank=True)
    location = models.CharField(max_length=200, blank=True)
    bio = models.TextField(blank=True)

    def __str__(self) -> str:
        return f"{self.user.full_name()} ({self.graduation_year})"


class AlumniEvent(TimestampedModel):
    title = models.CharField(max_length=200)
    event_type = models.CharField(max_length=16, choices=AlumniEventType.choices)
    description = models.TextField(blank=True)
    start_at = models.DateTimeField()
    end_at = models.DateTimeField(null=True, blank=True)
    venue = models.CharField(max_length=255, blank=True)
    is_online = models.BooleanField(default=False)
    meeting_link = models.URLField(blank=True)


class AlumniEventAttendee(TimestampedModel):
    event = models.ForeignKey(AlumniEvent, on_delete=models.CASCADE, related_name="attendees")
    alumni = models.ForeignKey(Alumni, on_delete=models.CASCADE, related_name="events")
    registered_on = models.DateTimeField(auto_now_add=True)
    attended = models.BooleanField(default=False)

    class Meta:
        unique_together = [("event", "alumni")]


class AlumniDonation(TimestampedModel):
    alumni = models.ForeignKey(Alumni, on_delete=models.PROTECT, related_name="donations")
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    purpose = models.CharField(max_length=255, blank=True)
    donated_on = models.DateField()
    payment_mode = models.CharField(max_length=32, blank=True)
    txn_reference = models.CharField(max_length=64, blank=True)
    journal_entry = models.ForeignKey(
        "accounting.JournalEntry", on_delete=models.SET_NULL, null=True, blank=True
    )

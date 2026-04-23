"""Announcements, notifications, events."""
from django.db import models

from apps.core.models import TimestampedModel, User


class Audience(models.TextChoices):
    ALL = "all", "All"
    STUDENTS = "students", "Students"
    EMPLOYEES = "employees", "Employees"
    ALUMNI = "alumni", "Alumni"
    CUSTOM = "custom", "Custom"


class NotificationStatus(models.TextChoices):
    PENDING = "pending", "Pending"
    SENT = "sent", "Sent"
    READ = "read", "Read"
    FAILED = "failed", "Failed"


class NotificationChannel(models.TextChoices):
    IN_APP = "in_app", "In-app"
    EMAIL = "email", "Email"
    SMS = "sms", "SMS"
    PUSH = "push", "Push"


class Announcement(TimestampedModel):
    title = models.CharField(max_length=200)
    body = models.TextField()
    audience = models.CharField(max_length=16, choices=Audience.choices, default=Audience.ALL)
    department = models.ForeignKey(
        "organization.Department", on_delete=models.SET_NULL, null=True, blank=True
    )
    program = models.ForeignKey(
        "academic.Program", on_delete=models.SET_NULL, null=True, blank=True
    )
    batch = models.ForeignKey(
        "academic.Batch", on_delete=models.SET_NULL, null=True, blank=True
    )
    author = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    published_at = models.DateTimeField(null=True, blank=True)
    expires_at = models.DateTimeField(null=True, blank=True)


class Notification(TimestampedModel):
    recipient = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="notifications"
    )
    title = models.CharField(max_length=200)
    body = models.TextField(blank=True)
    channel = models.CharField(
        max_length=16, choices=NotificationChannel.choices, default=NotificationChannel.IN_APP
    )
    status = models.CharField(
        max_length=16, choices=NotificationStatus.choices, default=NotificationStatus.PENDING
    )
    sent_at = models.DateTimeField(null=True, blank=True)
    read_at = models.DateTimeField(null=True, blank=True)
    url = models.URLField(blank=True)

    class Meta:
        indexes = [models.Index(fields=["recipient", "status"])]


class Event(TimestampedModel):
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    start_at = models.DateTimeField()
    end_at = models.DateTimeField(null=True, blank=True)
    venue = models.CharField(max_length=255, blank=True)
    organized_by = models.CharField(max_length=200, blank=True)

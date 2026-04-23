"""Audit logs + system-wide settings."""
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models

from apps.core.models import TimestampedModel, User


class AuditAction(models.TextChoices):
    CREATE = "create", "Create"
    UPDATE = "update", "Update"
    DELETE = "delete", "Delete"
    LOGIN = "login", "Login"
    LOGOUT = "logout", "Logout"
    VIEW = "view", "View"


class AuditLog(models.Model):
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)
    actor = models.ForeignKey(
        User, on_delete=models.SET_NULL, null=True, blank=True, related_name="audit_events"
    )
    action = models.CharField(max_length=16, choices=AuditAction.choices)
    target_content_type = models.ForeignKey(
        ContentType, on_delete=models.SET_NULL, null=True, blank=True
    )
    target_id = models.BigIntegerField(null=True, blank=True)
    target = GenericForeignKey("target_content_type", "target_id")
    changes = models.JSONField(null=True, blank=True)
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.CharField(max_length=255, blank=True)

    class Meta:
        indexes = [
            models.Index(fields=["target_content_type", "target_id"]),
            models.Index(fields=["actor", "timestamp"]),
        ]


class Setting(TimestampedModel):
    key = models.CharField(max_length=128, unique=True)
    value = models.JSONField()
    description = models.TextField(blank=True)

    def __str__(self) -> str:
        return self.key

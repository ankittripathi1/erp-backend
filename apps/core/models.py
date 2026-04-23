"""Core identity models: User, Role, Address, Document, EmergencyContact, Currency."""
from django.contrib.auth.models import AbstractUser
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models


class TimestampedModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        abstract = True


# ---------------------------------------------------------------------------
# Enums / choices
# ---------------------------------------------------------------------------


class Gender(models.TextChoices):
    MALE = "male", "Male"
    FEMALE = "female", "Female"
    OTHER = "other", "Other"
    PREFER_NOT_TO_SAY = "prefer_not_to_say", "Prefer not to say"


class UserType(models.TextChoices):
    STUDENT = "student", "Student"
    EMPLOYEE = "employee", "Employee"
    ADMIN = "admin", "Admin"
    GUARDIAN = "guardian", "Guardian"
    ALUMNI = "alumni", "Alumni"
    APPLICANT = "applicant", "Applicant"


class AddressType(models.TextChoices):
    PERMANENT = "permanent", "Permanent"
    CURRENT = "current", "Current"
    OFFICE = "office", "Office"
    BILLING = "billing", "Billing"


# ---------------------------------------------------------------------------
# User
# ---------------------------------------------------------------------------


class User(AbstractUser):
    """Root identity. All students, staff, alumni, guardians are Users."""

    middle_name = models.CharField(max_length=100, blank=True)
    phone = models.CharField(max_length=20, blank=True, db_index=True)
    date_of_birth = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=24, choices=Gender.choices, blank=True)
    blood_group = models.CharField(max_length=5, blank=True)
    profile_photo = models.ImageField(upload_to="users/photos/", null=True, blank=True)
    user_type = models.CharField(
        max_length=24, choices=UserType.choices, default=UserType.ADMIN
    )

    class Meta:
        indexes = [
            models.Index(fields=["user_type"]),
        ]

    def full_name(self) -> str:
        return " ".join(filter(None, [self.first_name, self.middle_name, self.last_name]))

    def __str__(self) -> str:
        return f"{self.username} ({self.full_name() or self.email})"


# ---------------------------------------------------------------------------
# Roles
# ---------------------------------------------------------------------------


class Role(TimestampedModel):
    code = models.CharField(max_length=64, unique=True)
    name = models.CharField(max_length=128)
    description = models.TextField(blank=True)

    def __str__(self) -> str:
        return self.code


class UserRole(TimestampedModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="user_roles")
    role = models.ForeignKey(Role, on_delete=models.CASCADE, related_name="role_users")
    assigned_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = [("user", "role")]

    def __str__(self) -> str:
        return f"{self.user_id}:{self.role.code}"


# ---------------------------------------------------------------------------
# Address
# ---------------------------------------------------------------------------


class Address(TimestampedModel):
    line1 = models.CharField(max_length=255)
    line2 = models.CharField(max_length=255, blank=True)
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100, blank=True)
    postal_code = models.CharField(max_length=20, blank=True)
    country = models.CharField(max_length=100, default="India")
    address_type = models.CharField(
        max_length=24, choices=AddressType.choices, default=AddressType.PERMANENT
    )

    def __str__(self) -> str:
        return f"{self.line1}, {self.city}"


class UserAddress(TimestampedModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="addresses")
    address = models.ForeignKey(Address, on_delete=models.CASCADE)
    address_type = models.CharField(
        max_length=24, choices=AddressType.choices, default=AddressType.PERMANENT
    )

    class Meta:
        unique_together = [("user", "address", "address_type")]


# ---------------------------------------------------------------------------
# Currency
# ---------------------------------------------------------------------------


class Currency(TimestampedModel):
    code = models.CharField(max_length=8, unique=True)
    name = models.CharField(max_length=64)
    symbol = models.CharField(max_length=8, blank=True)
    is_default = models.BooleanField(default=False)

    def __str__(self) -> str:
        return self.code


# ---------------------------------------------------------------------------
# Polymorphic attachments: Document + EmergencyContact
# ---------------------------------------------------------------------------


class Document(TimestampedModel):
    """Generic file attachment. Point it at any model via (content_type, object_id)."""

    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.BigIntegerField()
    owner = GenericForeignKey("content_type", "object_id")

    name = models.CharField(max_length=255)
    doc_type = models.CharField(max_length=64, blank=True)
    file = models.FileField(upload_to="documents/")
    uploaded_by = models.ForeignKey(
        User, on_delete=models.SET_NULL, null=True, blank=True, related_name="uploaded_documents"
    )
    verified = models.BooleanField(default=False)

    class Meta:
        indexes = [models.Index(fields=["content_type", "object_id"])]

    def __str__(self) -> str:
        return self.name


class EmergencyContact(TimestampedModel):
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.BigIntegerField()
    owner = GenericForeignKey("content_type", "object_id")

    name = models.CharField(max_length=200)
    relation = models.CharField(max_length=64)
    phone = models.CharField(max_length=20)
    email = models.EmailField(blank=True)
    address = models.ForeignKey(Address, on_delete=models.SET_NULL, null=True, blank=True)

    class Meta:
        indexes = [models.Index(fields=["content_type", "object_id"])]

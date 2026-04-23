"""Assets, Vendors, Purchases."""
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models

from apps.core.models import TimestampedModel


class AssetCondition(models.TextChoices):
    NEW = "new", "New"
    GOOD = "good", "Good"
    FAIR = "fair", "Fair"
    POOR = "poor", "Poor"
    DISPOSED = "disposed", "Disposed"


class Vendor(TimestampedModel):
    name = models.CharField(max_length=200, unique=True)
    gst_no = models.CharField(max_length=32, blank=True)
    contact_name = models.CharField(max_length=200, blank=True)
    contact_email = models.EmailField(blank=True)
    contact_phone = models.CharField(max_length=20, blank=True)
    address = models.TextField(blank=True)


class AssetCategory(TimestampedModel):
    name = models.CharField(max_length=128, unique=True)
    depreciation_percent = models.DecimalField(
        max_digits=5, decimal_places=2, null=True, blank=True
    )


class Asset(TimestampedModel):
    asset_tag = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=200)
    category = models.ForeignKey(AssetCategory, on_delete=models.PROTECT, related_name="assets")
    vendor = models.ForeignKey(Vendor, on_delete=models.SET_NULL, null=True, blank=True)
    purchase_date = models.DateField(null=True, blank=True)
    purchase_cost = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    serial_no = models.CharField(max_length=64, blank=True)
    location = models.CharField(max_length=128, blank=True)
    condition = models.CharField(
        max_length=16, choices=AssetCondition.choices, default=AssetCondition.NEW
    )
    warranty_until = models.DateField(null=True, blank=True)

    def __str__(self) -> str:
        return f"{self.asset_tag} — {self.name}"


class AssetAssignment(TimestampedModel):
    """Assign an asset to any owner — a department, an employee, a room, etc."""

    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name="assignments")
    assigned_content_type = models.ForeignKey(ContentType, on_delete=models.PROTECT)
    assigned_object_id = models.BigIntegerField()
    assigned_to = GenericForeignKey("assigned_content_type", "assigned_object_id")
    assigned_on = models.DateField()
    returned_on = models.DateField(null=True, blank=True)
    remarks = models.CharField(max_length=255, blank=True)


class Purchase(TimestampedModel):
    po_no = models.CharField(max_length=32, unique=True)
    vendor = models.ForeignKey(Vendor, on_delete=models.PROTECT, related_name="purchases")
    purchase_date = models.DateField()
    total_amount = models.DecimalField(max_digits=14, decimal_places=2)
    status = models.CharField(max_length=16, default="draft")
    journal_entry = models.ForeignKey(
        "accounting.JournalEntry", on_delete=models.SET_NULL, null=True, blank=True
    )


class PurchaseItem(TimestampedModel):
    purchase = models.ForeignKey(Purchase, on_delete=models.CASCADE, related_name="items")
    description = models.CharField(max_length=255)
    quantity = models.IntegerField(default=1)
    unit_price = models.DecimalField(max_digits=12, decimal_places=2)
    asset = models.ForeignKey(Asset, on_delete=models.SET_NULL, null=True, blank=True)

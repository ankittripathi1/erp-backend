"""Fees: categories, heads, structures, invoices, payments, scholarships, refunds."""
from django.db import models

from apps.core.models import TimestampedModel


class InvoiceStatus(models.TextChoices):
    DRAFT = "draft", "Draft"
    ISSUED = "issued", "Issued"
    PARTIAL = "partial", "Partial"
    PAID = "paid", "Paid"
    OVERDUE = "overdue", "Overdue"
    CANCELLED = "cancelled", "Cancelled"


class PaymentMode(models.TextChoices):
    CASH = "cash", "Cash"
    CARD = "card", "Card"
    UPI = "upi", "UPI"
    NETBANKING = "netbanking", "Net Banking"
    CHEQUE = "cheque", "Cheque"
    DD = "dd", "Demand Draft"


class PaymentStatus(models.TextChoices):
    PENDING = "pending", "Pending"
    SUCCESS = "success", "Success"
    FAILED = "failed", "Failed"
    REFUNDED = "refunded", "Refunded"


class DiscountType(models.TextChoices):
    PERCENTAGE = "percentage", "Percentage"
    FIXED = "fixed", "Fixed"


class ScholarshipSource(models.TextChoices):
    INSTITUTE = "institute", "Institute"
    GOVT = "govt", "Government"
    PRIVATE = "private", "Private"


class FeeCategory(TimestampedModel):
    name = models.CharField(max_length=64, unique=True)

    def __str__(self) -> str:
        return self.name


class FeeHead(TimestampedModel):
    category = models.ForeignKey(FeeCategory, on_delete=models.CASCADE, related_name="heads")
    name = models.CharField(max_length=128)
    code = models.CharField(max_length=32, unique=True)

    def __str__(self) -> str:
        return f"{self.category}/{self.name}"


class FeeStructure(TimestampedModel):
    program = models.ForeignKey(
        "academic.Program", on_delete=models.CASCADE, related_name="fee_structures"
    )
    batch = models.ForeignKey(
        "academic.Batch", on_delete=models.SET_NULL, null=True, blank=True
    )
    term = models.ForeignKey(
        "academic.AcademicTerm", on_delete=models.SET_NULL, null=True, blank=True
    )
    name = models.CharField(max_length=128)


class FeeStructureItem(TimestampedModel):
    structure = models.ForeignKey(FeeStructure, on_delete=models.CASCADE, related_name="items")
    fee_head = models.ForeignKey(FeeHead, on_delete=models.PROTECT)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    is_refundable = models.BooleanField(default=False)

    class Meta:
        unique_together = [("structure", "fee_head")]


class FeeInvoice(TimestampedModel):
    invoice_no = models.CharField(max_length=32, unique=True)
    student = models.ForeignKey(
        "students.Student", on_delete=models.PROTECT, related_name="invoices"
    )
    term = models.ForeignKey(
        "academic.AcademicTerm", on_delete=models.PROTECT, related_name="invoices"
    )
    issue_date = models.DateField()
    due_date = models.DateField()
    total_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    discount_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    paid_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    balance_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    status = models.CharField(
        max_length=16, choices=InvoiceStatus.choices, default=InvoiceStatus.DRAFT
    )
    journal_entry = models.ForeignKey(
        "accounting.JournalEntry",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="fee_invoice_postings",
    )

    def __str__(self) -> str:
        return self.invoice_no


class FeeInvoiceLine(TimestampedModel):
    invoice = models.ForeignKey(FeeInvoice, on_delete=models.CASCADE, related_name="lines")
    fee_head = models.ForeignKey(FeeHead, on_delete=models.PROTECT)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    discount = models.DecimalField(max_digits=12, decimal_places=2, default=0)


class Payment(TimestampedModel):
    payment_no = models.CharField(max_length=32, unique=True)
    invoice = models.ForeignKey(FeeInvoice, on_delete=models.PROTECT, related_name="payments")
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    paid_on = models.DateTimeField()
    mode = models.CharField(max_length=16, choices=PaymentMode.choices)
    txn_reference = models.CharField(max_length=64, blank=True)
    status = models.CharField(
        max_length=16, choices=PaymentStatus.choices, default=PaymentStatus.SUCCESS
    )
    received_by = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True
    )
    journal_entry = models.ForeignKey(
        "accounting.JournalEntry",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="payment_postings",
    )


class Scholarship(TimestampedModel):
    name = models.CharField(max_length=128, unique=True)
    discount_type = models.CharField(max_length=16, choices=DiscountType.choices)
    value = models.DecimalField(max_digits=12, decimal_places=2)
    source = models.CharField(
        max_length=16, choices=ScholarshipSource.choices, default=ScholarshipSource.INSTITUTE
    )


class StudentScholarship(TimestampedModel):
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="scholarships"
    )
    scholarship = models.ForeignKey(Scholarship, on_delete=models.PROTECT)
    effective_from = models.DateField()
    effective_to = models.DateField(null=True, blank=True)
    approved_by = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True
    )
    status = models.CharField(max_length=16, default="active")


class Refund(TimestampedModel):
    payment = models.ForeignKey(Payment, on_delete=models.PROTECT, related_name="refunds")
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    reason = models.TextField(blank=True)
    refunded_on = models.DateTimeField(null=True, blank=True)
    status = models.CharField(max_length=16, default="pending")
    journal_entry = models.ForeignKey(
        "accounting.JournalEntry", on_delete=models.SET_NULL, null=True, blank=True
    )

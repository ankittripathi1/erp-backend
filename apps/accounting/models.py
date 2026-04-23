"""Double-entry accounting ledger: FiscalYear, AccountGroup, ChartOfAccount, JournalEntry, JournalLine."""
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models

from apps.core.models import TimestampedModel


class RootType(models.TextChoices):
    ASSET = "asset", "Asset"
    LIABILITY = "liability", "Liability"
    EQUITY = "equity", "Equity"
    INCOME = "income", "Income"
    EXPENSE = "expense", "Expense"


class JournalSource(models.TextChoices):
    INVOICE = "invoice", "Invoice"
    PAYMENT = "payment", "Payment"
    REFUND = "refund", "Refund"
    PAYSLIP = "payslip", "Payslip"
    FINE = "fine", "Fine"
    SCHOLARSHIP = "scholarship", "Scholarship"
    PURCHASE = "purchase", "Purchase"
    DONATION = "donation", "Donation"
    MANUAL = "manual", "Manual"


class JournalStatus(models.TextChoices):
    DRAFT = "draft", "Draft"
    POSTED = "posted", "Posted"
    REVERSED = "reversed", "Reversed"


class FiscalYear(TimestampedModel):
    name = models.CharField(max_length=32, unique=True, help_text="e.g. FY 2025-26")
    start_date = models.DateField()
    end_date = models.DateField()
    is_closed = models.BooleanField(default=False)

    class Meta:
        ordering = ("-start_date",)

    def __str__(self) -> str:
        return self.name


class AccountGroup(TimestampedModel):
    name = models.CharField(max_length=128)
    code = models.CharField(max_length=32, unique=True)
    parent = models.ForeignKey(
        "self", on_delete=models.CASCADE, null=True, blank=True, related_name="children"
    )
    root_type = models.CharField(max_length=16, choices=RootType.choices)

    def __str__(self) -> str:
        return f"{self.code} — {self.name}"


class ChartOfAccount(TimestampedModel):
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=200)
    group = models.ForeignKey(AccountGroup, on_delete=models.PROTECT, related_name="accounts")
    account_type = models.CharField(max_length=16, choices=RootType.choices)
    currency = models.ForeignKey(
        "core.Currency", on_delete=models.SET_NULL, null=True, blank=True
    )
    is_bank = models.BooleanField(default=False)
    opening_balance = models.DecimalField(max_digits=14, decimal_places=2, default=0)

    def __str__(self) -> str:
        return f"{self.code} — {self.name}"


class JournalEntry(TimestampedModel):
    entry_no = models.CharField(max_length=32, unique=True)
    fiscal_year = models.ForeignKey(FiscalYear, on_delete=models.PROTECT, related_name="entries")
    posting_date = models.DateField()
    narration = models.CharField(max_length=512, blank=True)
    source_type = models.CharField(
        max_length=32, choices=JournalSource.choices, default=JournalSource.MANUAL
    )
    source_id = models.BigIntegerField(null=True, blank=True)
    status = models.CharField(
        max_length=16, choices=JournalStatus.choices, default=JournalStatus.DRAFT
    )
    posted_by = models.ForeignKey(
        "core.User", on_delete=models.SET_NULL, null=True, blank=True, related_name="journal_entries"
    )
    posted_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        indexes = [models.Index(fields=["source_type", "source_id"])]

    def __str__(self) -> str:
        return self.entry_no


class JournalLine(TimestampedModel):
    entry = models.ForeignKey(JournalEntry, on_delete=models.CASCADE, related_name="lines")
    account = models.ForeignKey(ChartOfAccount, on_delete=models.PROTECT, related_name="lines")
    debit = models.DecimalField(max_digits=14, decimal_places=2, default=0)
    credit = models.DecimalField(max_digits=14, decimal_places=2, default=0)
    party_content_type = models.ForeignKey(
        ContentType, on_delete=models.SET_NULL, null=True, blank=True
    )
    party_id = models.BigIntegerField(null=True, blank=True)
    party = GenericForeignKey("party_content_type", "party_id")
    description = models.CharField(max_length=255, blank=True)

    class Meta:
        constraints = [
            models.CheckConstraint(
                check=(
                    models.Q(debit__gt=0, credit=0) | models.Q(credit__gt=0, debit=0)
                ),
                name="journalline_exactly_one_of_debit_credit",
            ),
        ]

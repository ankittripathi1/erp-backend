"""Payroll: SalaryComponent, SalaryStructure, Payslip."""
from django.db import models

from apps.core.models import TimestampedModel


class ComponentType(models.TextChoices):
    EARNING = "earning", "Earning"
    DEDUCTION = "deduction", "Deduction"


class PayslipStatus(models.TextChoices):
    DRAFT = "draft", "Draft"
    APPROVED = "approved", "Approved"
    PAID = "paid", "Paid"


class SalaryComponent(TimestampedModel):
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=128)
    component_type = models.CharField(max_length=16, choices=ComponentType.choices)
    is_taxable = models.BooleanField(default=False)

    def __str__(self) -> str:
        return self.code


class SalaryStructure(TimestampedModel):
    name = models.CharField(max_length=128)
    effective_from = models.DateField()

    def __str__(self) -> str:
        return self.name


class SalaryStructureComponent(TimestampedModel):
    structure = models.ForeignKey(
        SalaryStructure, on_delete=models.CASCADE, related_name="components"
    )
    component = models.ForeignKey(SalaryComponent, on_delete=models.PROTECT)
    amount = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    percentage_of = models.ForeignKey(
        SalaryComponent, on_delete=models.SET_NULL, null=True, blank=True, related_name="+"
    )
    percentage = models.DecimalField(max_digits=6, decimal_places=3, null=True, blank=True)
    formula = models.CharField(max_length=255, blank=True)

    class Meta:
        unique_together = [("structure", "component")]


class EmployeeSalaryAssignment(TimestampedModel):
    employee = models.ForeignKey(
        "employees.Employee", on_delete=models.CASCADE, related_name="salary_assignments"
    )
    structure = models.ForeignKey(SalaryStructure, on_delete=models.PROTECT)
    effective_from = models.DateField()
    effective_to = models.DateField(null=True, blank=True)

    class Meta:
        indexes = [models.Index(fields=["employee", "effective_from"])]


class Payslip(TimestampedModel):
    employee = models.ForeignKey(
        "employees.Employee", on_delete=models.PROTECT, related_name="payslips"
    )
    period_start = models.DateField()
    period_end = models.DateField()
    gross_earnings = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    total_deductions = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    net_pay = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    status = models.CharField(
        max_length=16, choices=PayslipStatus.choices, default=PayslipStatus.DRAFT
    )
    paid_on = models.DateField(null=True, blank=True)
    journal_entry = models.ForeignKey(
        "accounting.JournalEntry",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="payslip_postings",
    )

    class Meta:
        unique_together = [("employee", "period_start", "period_end")]

    def __str__(self) -> str:
        return f"Payslip {self.employee.employee_no} {self.period_start}→{self.period_end}"


class PayslipLine(TimestampedModel):
    payslip = models.ForeignKey(Payslip, on_delete=models.CASCADE, related_name="lines")
    component = models.ForeignKey(SalaryComponent, on_delete=models.PROTECT)
    amount = models.DecimalField(max_digits=12, decimal_places=2)

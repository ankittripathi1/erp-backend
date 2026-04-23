"""Seed initial reference data for a fresh UMS install.

Idempotent: safe to run repeatedly. Populates:
- Roles
- Currency (INR as default)
- Designations
- Fee categories
- Leave types
- A default percentage GradingScheme + GradeBands (Indian-style)
- A standard Chart of Accounts (Assets, Liabilities, Equity, Income, Expense)
"""
from decimal import Decimal

from django.core.management.base import BaseCommand
from django.db import transaction

from apps.core.models import Currency, Role
from apps.employees.models import Designation, DesignationCategory
from apps.fees.models import FeeCategory
from apps.leaves.models import LeaveType
from apps.grading.models import GradingScheme, GradeBand, SchemeType
from apps.accounting.models import AccountGroup, ChartOfAccount, RootType


ROLES = [
    ("admin", "Administrator"),
    ("student", "Student"),
    ("faculty", "Faculty"),
    ("hr", "HR"),
    ("accountant", "Accountant"),
    ("librarian", "Librarian"),
    ("warden", "Warden"),
    ("placement_officer", "Placement Officer"),
    ("guardian", "Guardian"),
    ("alumni", "Alumni"),
    ("receptionist", "Receptionist"),
]

DESIGNATIONS = [
    ("Professor", DesignationCategory.TEACHING),
    ("Associate Professor", DesignationCategory.TEACHING),
    ("Assistant Professor", DesignationCategory.TEACHING),
    ("Lecturer", DesignationCategory.TEACHING),
    ("Lab Assistant", DesignationCategory.TEACHING),
    ("HR Manager", DesignationCategory.ADMIN),
    ("HR Executive", DesignationCategory.ADMIN),
    ("Accountant", DesignationCategory.ADMIN),
    ("Librarian", DesignationCategory.NON_TEACHING),
    ("Warden", DesignationCategory.NON_TEACHING),
    ("Placement Officer", DesignationCategory.ADMIN),
    ("Security", DesignationCategory.SUPPORT),
    ("Housekeeping", DesignationCategory.SUPPORT),
]

FEE_CATEGORIES = ["Tuition", "Hostel", "Mess", "Library", "Examination", "Transport", "Miscellaneous"]

LEAVE_TYPES = [
    ("CL", "Casual Leave", True),
    ("SL", "Sick Leave", True),
    ("EL", "Earned Leave", True),
    ("LOP", "Loss of Pay", False),
    ("ML", "Maternity Leave", True),
    ("PL", "Paternity Leave", True),
]

# Indian-style percentage grading: First Class with Distinction / First Class / Second Class / Pass / Fail
GRADE_BANDS = [
    # (band_code, min_pct, max_pct, grade_points, is_pass, sort_order)
    ("O", 90, 100, 10, True, 1),
    ("A+", 80, 89.99, 9, True, 2),
    ("A", 70, 79.99, 8, True, 3),
    ("B+", 60, 69.99, 7, True, 4),
    ("B", 50, 59.99, 6, True, 5),
    ("C", 45, 49.99, 5, True, 6),
    ("P", 40, 44.99, 4, True, 7),
    ("F", 0, 39.99, 0, False, 8),
]

# Chart-of-accounts skeleton (name, code, root_type, parent_code)
ACCOUNT_GROUPS = [
    ("Assets", "1000", RootType.ASSET, None),
    ("Current Assets", "1100", RootType.ASSET, "1000"),
    ("Fixed Assets", "1200", RootType.ASSET, "1000"),
    ("Liabilities", "2000", RootType.LIABILITY, None),
    ("Current Liabilities", "2100", RootType.LIABILITY, "2000"),
    ("Equity", "3000", RootType.EQUITY, None),
    ("Income", "4000", RootType.INCOME, None),
    ("Tuition & Academic Income", "4100", RootType.INCOME, "4000"),
    ("Other Income", "4900", RootType.INCOME, "4000"),
    ("Expenses", "5000", RootType.EXPENSE, None),
    ("Salaries & Wages", "5100", RootType.EXPENSE, "5000"),
    ("Operating Expenses", "5200", RootType.EXPENSE, "5000"),
]

ACCOUNTS = [
    # (code, name, group_code, account_type, is_bank)
    ("1001", "Cash in Hand", "1100", RootType.ASSET, False),
    ("1002", "Bank - Current Account", "1100", RootType.ASSET, True),
    ("1003", "Accounts Receivable - Fees", "1100", RootType.ASSET, False),
    ("1201", "Furniture & Fixtures", "1200", RootType.ASSET, False),
    ("1202", "Computer Equipment", "1200", RootType.ASSET, False),
    ("2101", "Salaries Payable", "2100", RootType.LIABILITY, False),
    ("2102", "Fees Received in Advance", "2100", RootType.LIABILITY, False),
    ("3001", "Institute Capital", "3000", RootType.EQUITY, False),
    ("4101", "Tuition Fee Income", "4100", RootType.INCOME, False),
    ("4102", "Hostel Fee Income", "4100", RootType.INCOME, False),
    ("4103", "Library Fee Income", "4100", RootType.INCOME, False),
    ("4104", "Examination Fee Income", "4100", RootType.INCOME, False),
    ("4901", "Donations", "4900", RootType.INCOME, False),
    ("4902", "Fine Income", "4900", RootType.INCOME, False),
    ("5101", "Salary Expense", "5100", RootType.EXPENSE, False),
    ("5102", "Provident Fund Expense", "5100", RootType.EXPENSE, False),
    ("5201", "Rent Expense", "5200", RootType.EXPENSE, False),
    ("5202", "Utility Expense", "5200", RootType.EXPENSE, False),
    ("5203", "Office Supplies", "5200", RootType.EXPENSE, False),
    ("5204", "Scholarship Expense", "5200", RootType.EXPENSE, False),
]


class Command(BaseCommand):
    help = "Seed the UMS database with initial reference data (idempotent)."

    @transaction.atomic
    def handle(self, *args, **options):
        self.stdout.write(self.style.MIGRATE_HEADING("Seeding roles..."))
        for code, name in ROLES:
            Role.objects.update_or_create(code=code, defaults={"name": name})

        self.stdout.write(self.style.MIGRATE_HEADING("Seeding default currency (INR)..."))
        Currency.objects.update_or_create(
            code="INR",
            defaults={"name": "Indian Rupee", "symbol": "₹", "is_default": True},
        )

        self.stdout.write(self.style.MIGRATE_HEADING("Seeding designations..."))
        for name, category in DESIGNATIONS:
            Designation.objects.update_or_create(name=name, defaults={"category": category})

        self.stdout.write(self.style.MIGRATE_HEADING("Seeding fee categories..."))
        for name in FEE_CATEGORIES:
            FeeCategory.objects.update_or_create(name=name)

        self.stdout.write(self.style.MIGRATE_HEADING("Seeding leave types..."))
        for code, name, is_paid in LEAVE_TYPES:
            LeaveType.objects.update_or_create(
                code=code, defaults={"name": name, "is_paid": is_paid}
            )

        self.stdout.write(self.style.MIGRATE_HEADING("Seeding default grading scheme..."))
        scheme, _ = GradingScheme.objects.update_or_create(
            name="Default Percentage (10-pt GP)",
            defaults={
                "scheme_type": SchemeType.PERCENTAGE,
                "max_grade_points": Decimal("10.00"),
                "pass_threshold": Decimal("40.00"),
                "description": "Default Indian percentage scheme with 10-point grade-point mapping.",
            },
        )
        for code, lo, hi, gp, is_pass, order in GRADE_BANDS:
            GradeBand.objects.update_or_create(
                scheme=scheme,
                band_code=code,
                defaults={
                    "min_percentage": Decimal(str(lo)),
                    "max_percentage": Decimal(str(hi)),
                    "grade_points": Decimal(str(gp)),
                    "is_pass": is_pass,
                    "sort_order": order,
                },
            )

        self.stdout.write(self.style.MIGRATE_HEADING("Seeding chart of accounts..."))
        groups: dict[str, AccountGroup] = {}
        for name, code, root, parent_code in ACCOUNT_GROUPS:
            parent = groups.get(parent_code) if parent_code else None
            grp, _ = AccountGroup.objects.update_or_create(
                code=code,
                defaults={"name": name, "root_type": root, "parent": parent},
            )
            groups[code] = grp

        inr = Currency.objects.get(code="INR")
        for code, name, group_code, acc_type, is_bank in ACCOUNTS:
            ChartOfAccount.objects.update_or_create(
                code=code,
                defaults={
                    "name": name,
                    "group": groups[group_code],
                    "account_type": acc_type,
                    "is_bank": is_bank,
                    "currency": inr,
                },
            )

        self.stdout.write(self.style.SUCCESS("Seed complete."))

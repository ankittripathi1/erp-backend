"""Library: books, copies, members, issues, fines."""
from django.db import models

from apps.core.models import TimestampedModel, User


class BookCopyStatus(models.TextChoices):
    AVAILABLE = "available", "Available"
    ISSUED = "issued", "Issued"
    RESERVED = "reserved", "Reserved"
    LOST = "lost", "Lost"
    DAMAGED = "damaged", "Damaged"


class MemberType(models.TextChoices):
    STUDENT = "student", "Student"
    FACULTY = "faculty", "Faculty"
    STAFF = "staff", "Staff"
    EXTERNAL = "external", "External"


class IssueStatus(models.TextChoices):
    ISSUED = "issued", "Issued"
    RETURNED = "returned", "Returned"
    LOST = "lost", "Lost"
    OVERDUE = "overdue", "Overdue"


class Author(TimestampedModel):
    name = models.CharField(max_length=200)
    bio = models.TextField(blank=True)

    def __str__(self) -> str:
        return self.name


class Publisher(TimestampedModel):
    name = models.CharField(max_length=200, unique=True)

    def __str__(self) -> str:
        return self.name


class BookCategory(TimestampedModel):
    name = models.CharField(max_length=128, unique=True)

    def __str__(self) -> str:
        return self.name


class Book(TimestampedModel):
    isbn = models.CharField(max_length=20, unique=True)
    title = models.CharField(max_length=255)
    subtitle = models.CharField(max_length=255, blank=True)
    publisher = models.ForeignKey(Publisher, on_delete=models.SET_NULL, null=True, blank=True)
    category = models.ForeignKey(BookCategory, on_delete=models.SET_NULL, null=True, blank=True)
    edition = models.CharField(max_length=32, blank=True)
    year_of_publication = models.SmallIntegerField(null=True, blank=True)
    language = models.CharField(max_length=32, blank=True)
    authors = models.ManyToManyField(Author, through="BookAuthor", related_name="books")
    cover_image = models.ImageField(upload_to="library/covers/", null=True, blank=True)

    def __str__(self) -> str:
        return self.title


class BookAuthor(TimestampedModel):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    author = models.ForeignKey(Author, on_delete=models.CASCADE)
    author_order = models.SmallIntegerField(default=1)

    class Meta:
        unique_together = [("book", "author")]


class BookCopy(TimestampedModel):
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name="copies")
    accession_no = models.CharField(max_length=32, unique=True)
    barcode = models.CharField(max_length=64, blank=True)
    shelf_location = models.CharField(max_length=64, blank=True)
    status = models.CharField(
        max_length=16, choices=BookCopyStatus.choices, default=BookCopyStatus.AVAILABLE
    )
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)

    def __str__(self) -> str:
        return f"{self.book.title} ({self.accession_no})"


class LibraryMember(TimestampedModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="library_membership")
    member_type = models.CharField(max_length=16, choices=MemberType.choices)
    membership_id = models.CharField(max_length=32, unique=True)
    valid_from = models.DateField()
    valid_until = models.DateField(null=True, blank=True)
    max_books_allowed = models.SmallIntegerField(default=3)

    def __str__(self) -> str:
        return f"{self.membership_id} — {self.user.username}"


class BookIssue(TimestampedModel):
    copy = models.ForeignKey(BookCopy, on_delete=models.PROTECT, related_name="issues")
    member = models.ForeignKey(LibraryMember, on_delete=models.PROTECT, related_name="issues")
    issue_date = models.DateField()
    due_date = models.DateField()
    return_date = models.DateField(null=True, blank=True)
    status = models.CharField(
        max_length=16, choices=IssueStatus.choices, default=IssueStatus.ISSUED
    )

    class Meta:
        indexes = [models.Index(fields=["member", "status"])]


class BookReservation(TimestampedModel):
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name="reservations")
    member = models.ForeignKey(LibraryMember, on_delete=models.CASCADE, related_name="reservations")
    reserved_on = models.DateTimeField(auto_now_add=True)
    fulfilled_on = models.DateTimeField(null=True, blank=True)
    status = models.CharField(max_length=16, default="pending")


class LibraryFine(TimestampedModel):
    issue = models.ForeignKey(BookIssue, on_delete=models.CASCADE, related_name="fines")
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    reason = models.CharField(max_length=255, blank=True)
    paid = models.BooleanField(default=False)
    paid_on = models.DateTimeField(null=True, blank=True)
    journal_entry = models.ForeignKey(
        "accounting.JournalEntry", on_delete=models.SET_NULL, null=True, blank=True
    )

"""Course catalogue, offerings, teaching assignments, syllabus topics."""
from django.db import models

from apps.core.models import TimestampedModel


class CourseType(models.TextChoices):
    CORE = "core", "Core"
    ELECTIVE = "elective", "Elective"
    LAB = "lab", "Lab"
    PROJECT = "project", "Project"
    SEMINAR = "seminar", "Seminar"


class TeachingRole(models.TextChoices):
    LECTURER = "lecturer", "Lecturer"
    TA = "ta", "Teaching Assistant"
    LAB_INSTRUCTOR = "lab_instructor", "Lab Instructor"


class Course(TimestampedModel):
    department = models.ForeignKey(
        "organization.Department", on_delete=models.PROTECT, related_name="courses"
    )
    code = models.CharField(max_length=32, unique=True)
    title = models.CharField(max_length=200)
    credits = models.DecimalField(max_digits=4, decimal_places=1)
    course_type = models.CharField(max_length=16, choices=CourseType.choices, default=CourseType.CORE)
    theory_hours = models.SmallIntegerField(default=0)
    practical_hours = models.SmallIntegerField(default=0)
    description = models.TextField(blank=True)

    prerequisites = models.ManyToManyField(
        "self",
        symmetrical=False,
        through="CoursePrerequisite",
        related_name="required_for",
    )

    def __str__(self) -> str:
        return f"{self.code} — {self.title}"


class CoursePrerequisite(TimestampedModel):
    course = models.ForeignKey(
        Course, on_delete=models.CASCADE, related_name="prereq_links"
    )
    prereq_course = models.ForeignKey(
        Course, on_delete=models.CASCADE, related_name="unlocks_links"
    )

    class Meta:
        unique_together = [("course", "prereq_course")]


class ProgramCourse(TimestampedModel):
    program = models.ForeignKey(
        "academic.Program", on_delete=models.CASCADE, related_name="program_courses"
    )
    course = models.ForeignKey(Course, on_delete=models.PROTECT, related_name="in_programs")
    term_number = models.SmallIntegerField(help_text="1..N — which semester of the program")
    is_mandatory = models.BooleanField(default=True)

    class Meta:
        unique_together = [("program", "course", "term_number")]

    def __str__(self) -> str:
        return f"{self.program.code} / T{self.term_number} / {self.course.code}"


class CourseOffering(TimestampedModel):
    """An actual run of a Course in a specific AcademicTerm."""

    course = models.ForeignKey(Course, on_delete=models.PROTECT, related_name="offerings")
    term = models.ForeignKey(
        "academic.AcademicTerm", on_delete=models.PROTECT, related_name="offerings"
    )
    section = models.ForeignKey(
        "academic.Section", on_delete=models.SET_NULL, null=True, blank=True, related_name="offerings"
    )
    primary_teacher = models.ForeignKey(
        "employees.Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="primary_offerings",
    )
    room = models.ForeignKey(
        "timetable.Room", on_delete=models.SET_NULL, null=True, blank=True, related_name="default_for"
    )
    capacity = models.IntegerField(null=True, blank=True)

    class Meta:
        indexes = [models.Index(fields=["term", "course"])]

    def __str__(self) -> str:
        return f"{self.course.code} @ {self.term}"


class TeachingAssignment(TimestampedModel):
    offering = models.ForeignKey(
        CourseOffering, on_delete=models.CASCADE, related_name="teaching_assignments"
    )
    employee = models.ForeignKey(
        "employees.Employee", on_delete=models.CASCADE, related_name="teaching_assignments"
    )
    role = models.CharField(max_length=24, choices=TeachingRole.choices, default=TeachingRole.LECTURER)

    class Meta:
        unique_together = [("offering", "employee", "role")]


class SyllabusTopic(TimestampedModel):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name="syllabus_topics")
    unit_number = models.SmallIntegerField()
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    expected_hours = models.DecimalField(max_digits=4, decimal_places=1, null=True, blank=True)

    class Meta:
        ordering = ("course", "unit_number")

    def __str__(self) -> str:
        return f"{self.course.code} U{self.unit_number}: {self.title}"

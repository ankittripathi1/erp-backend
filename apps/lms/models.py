"""Learning Management: Course materials, assignments, quizzes."""
from django.db import models

from apps.core.models import TimestampedModel


class MaterialType(models.TextChoices):
    DOCUMENT = "document", "Document"
    VIDEO = "video", "Video"
    LINK = "link", "Link"
    SLIDES = "slides", "Slides"
    AUDIO = "audio", "Audio"


class AssignmentStatus(models.TextChoices):
    DRAFT = "draft", "Draft"
    PUBLISHED = "published", "Published"
    CLOSED = "closed", "Closed"


class SubmissionStatus(models.TextChoices):
    SUBMITTED = "submitted", "Submitted"
    LATE = "late", "Late"
    GRADED = "graded", "Graded"
    RESUBMIT = "resubmit", "Needs resubmission"


class QuestionType(models.TextChoices):
    MCQ_SINGLE = "mcq_single", "MCQ (single correct)"
    MCQ_MULTI = "mcq_multi", "MCQ (multiple correct)"
    TRUE_FALSE = "true_false", "True / False"
    SHORT_ANSWER = "short_answer", "Short answer"
    LONG_ANSWER = "long_answer", "Long answer"


class CourseMaterial(TimestampedModel):
    offering = models.ForeignKey(
        "courses.CourseOffering", on_delete=models.CASCADE, related_name="materials"
    )
    title = models.CharField(max_length=200)
    material_type = models.CharField(max_length=16, choices=MaterialType.choices)
    file = models.FileField(upload_to="lms/materials/", null=True, blank=True)
    external_url = models.URLField(blank=True)
    description = models.TextField(blank=True)
    uploaded_by = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True
    )


class Assignment(TimestampedModel):
    offering = models.ForeignKey(
        "courses.CourseOffering", on_delete=models.CASCADE, related_name="assignments"
    )
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    max_marks = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    published_at = models.DateTimeField(null=True, blank=True)
    due_at = models.DateTimeField()
    allow_late_submission = models.BooleanField(default=False)
    status = models.CharField(
        max_length=16, choices=AssignmentStatus.choices, default=AssignmentStatus.DRAFT
    )


class AssignmentSubmission(TimestampedModel):
    assignment = models.ForeignKey(Assignment, on_delete=models.CASCADE, related_name="submissions")
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="assignment_submissions"
    )
    submitted_at = models.DateTimeField()
    file = models.FileField(upload_to="lms/submissions/", null=True, blank=True)
    text_answer = models.TextField(blank=True)
    marks = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    feedback = models.TextField(blank=True)
    status = models.CharField(
        max_length=16, choices=SubmissionStatus.choices, default=SubmissionStatus.SUBMITTED
    )
    graded_by = models.ForeignKey(
        "employees.Employee", on_delete=models.SET_NULL, null=True, blank=True
    )
    graded_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = [("assignment", "student")]


class Quiz(TimestampedModel):
    offering = models.ForeignKey(
        "courses.CourseOffering", on_delete=models.CASCADE, related_name="quizzes"
    )
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    duration_minutes = models.SmallIntegerField(default=30)
    max_attempts = models.SmallIntegerField(default=1)
    start_at = models.DateTimeField(null=True, blank=True)
    end_at = models.DateTimeField(null=True, blank=True)
    is_published = models.BooleanField(default=False)


class Question(TimestampedModel):
    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE, related_name="questions")
    text = models.TextField()
    question_type = models.CharField(max_length=16, choices=QuestionType.choices)
    marks = models.DecimalField(max_digits=5, decimal_places=2, default=1)
    order = models.SmallIntegerField(default=1)

    class Meta:
        ordering = ("quiz", "order")


class QuestionOption(TimestampedModel):
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name="options")
    text = models.CharField(max_length=512)
    is_correct = models.BooleanField(default=False)
    order = models.SmallIntegerField(default=1)

    class Meta:
        ordering = ("question", "order")


class QuizAttempt(TimestampedModel):
    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE, related_name="attempts")
    student = models.ForeignKey(
        "students.Student", on_delete=models.CASCADE, related_name="quiz_attempts"
    )
    started_at = models.DateTimeField()
    submitted_at = models.DateTimeField(null=True, blank=True)
    score = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    attempt_no = models.SmallIntegerField(default=1)

    class Meta:
        unique_together = [("quiz", "student", "attempt_no")]


class QuizAnswer(TimestampedModel):
    attempt = models.ForeignKey(QuizAttempt, on_delete=models.CASCADE, related_name="answers")
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    selected_options = models.ManyToManyField(QuestionOption, blank=True, related_name="selected_in")
    text_answer = models.TextField(blank=True)
    awarded_marks = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    is_correct = models.BooleanField(null=True, blank=True)

    class Meta:
        unique_together = [("attempt", "question")]

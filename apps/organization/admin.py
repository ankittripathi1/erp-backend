"""Admin registration for organization. Auto-registers every concrete model."""
from django.apps import apps
from django.contrib import admin


for model in apps.get_app_config("organization").get_models():
    try:
        admin.site.register(model)
    except admin.sites.AlreadyRegistered:
        pass

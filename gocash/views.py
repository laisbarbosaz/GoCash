from django.contrib.admin.models import LogEntry
from django.shortcuts import render
from django.contrib.auth.decorators import login_required

@login_required
def logs_view(request):
    logs = LogEntry.objects.select_related("user", "content_type").order_by("-action_time")[:50]
    return render(request, "logs.html", {"logs": logs})

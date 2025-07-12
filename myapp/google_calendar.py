# utils/google_calendar.py
from googleapiclient.discovery import build
from .google_auth import get_credentials

def schedule_google_meet(summary, start_time, end_time, attendees):
    service = build("calendar", "v3", credentials=get_credentials())

    event = {
        "summary": summary,
        "start": {"dateTime": start_time, "timeZone": "Asia/Kolkata"},
        "end": {"dateTime": end_time, "timeZone": "Asia/Kolkata"},
        "attendees": [{"email": email} for email in attendees],
        "conferenceData": {
            "createRequest": {
                "requestId": "random-meet-" + str(abs(hash(summary))),
                "conferenceSolutionKey": {"type": "hangoutsMeet"}
            }
        }
    }

    created_event = service.events().insert(
        calendarId='primary',
        body=event,
        conferenceDataVersion=1
    ).execute()

    return created_event.get("hangoutLink")

# myapp/zoom_utils.py

import os
import requests
from requests.auth import HTTPBasicAuth

# Zoom’s Server-to-Server token URL
ZOOM_OAUTH_TOKEN_URL = "https://zoom.us/oauth/token"
ZOOM_API_BASE       = "https://api.zoom.us/v2"
ZOOM_HOST_USER      = "me"

# You must set this in your env alongside CLIENT_ID and CLIENT_SECRET
ZOOM_ACCOUNT_ID     = os.getenv("ZOOM_ACCOUNT_ID", "")


def get_zoom_access_token() -> str:
    """
    Fetch a Server-to-Server OAuth access token via account_credentials grant.
    """
    client_id     = os.getenv("ZOOM_CLIENT_ID")
    client_secret = os.getenv("ZOOM_CLIENT_SECRET")
    account_id    = ZOOM_ACCOUNT_ID

    if not all([client_id, client_secret, account_id]):
        raise RuntimeError(
            "Missing one of ZOOM_CLIENT_ID, ZOOM_CLIENT_SECRET or ZOOM_ACCOUNT_ID"
        )

    # Note grant_type=account_credentials & include your account_id
    url = (
        f"{ZOOM_OAUTH_TOKEN_URL}"
        f"?grant_type=account_credentials"
        f"&account_id={account_id}"
    )

    resp = requests.post(url, auth=HTTPBasicAuth(client_id, client_secret))
    resp.raise_for_status()
    return resp.json()["access_token"]


def schedule_zoom_meet(
    topic: str,
    start_time_iso: str,
    duration_minutes: int = 60,
    timezone: str = "Asia/Kolkata"
) -> str:
    """
    Create a scheduled Zoom meeting and return its join_url.
    """
    token = get_zoom_access_token()
    url   = f"{ZOOM_API_BASE}/users/{ZOOM_HOST_USER}/meetings"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type":  "application/json"
    }
    payload = {
        "topic":      topic,
        "type":       2,
        "start_time": start_time_iso,
        "duration":   duration_minutes,
        "timezone":   timezone,
        "settings": {
            "join_before_host": False,
            "waiting_room":     True,
            "approval_type":    0,
            "audio":            "both"
        }
    }

    resp = requests.post(url, headers=headers, json=payload)
    resp.raise_for_status()
    return resp.json().get("join_url")
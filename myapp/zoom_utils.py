# myapp/zoom_utils.py

import time
import threading
import requests
from requests.auth import HTTPBasicAuth
from decouple import config

# OAuth token & API endpoints
_TOKEN_URL = "https://zoom.us/oauth/token"
_API_BASE  = "https://api.zoom.us/v2"
_HOST_USER = "me"

# Simple in-process cache for the access token
_token_lock   = threading.Lock()
_token_value  = None
_token_expiry = 0


def _load_credentials():
    """
    Read Zoom credentials via python-decouple.
    Will raise a MissingOptionError if any var is absent.
    """
    client_id     = config("ZOOM_CLIENT_ID")
    client_secret = config("ZOOM_CLIENT_SECRET")
    account_id    = config("ZOOM_ACCOUNT_ID")
    return client_id, client_secret, account_id


def get_zoom_access_token() -> str:
    """
    Fetch (and cache) a Server-to-Server OAuth access token via account_credentials grant.
    """
    global _token_value, _token_expiry

    client_id, client_secret, account_id = _load_credentials()
    now = time.time()

    # Return cached token if still valid
    if _token_value and now < _token_expiry:
        return _token_value

    with _token_lock:
        if _token_value and now < _token_expiry:
            return _token_value

        # Build token‐request URL
        url = (
            f"{_TOKEN_URL}"
            f"?grant_type=account_credentials"
            f"&account_id={account_id}"
        )
        resp = requests.post(url, auth=HTTPBasicAuth(client_id, client_secret), timeout=10)
        resp.raise_for_status()

        data = resp.json()
        _token_value  = data["access_token"]
        # Zoom returns expires_in (seconds)
        _token_expiry = now + data.get("expires_in", 3600) - 30  # 30s safety buffer

        return _token_value


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
    url   = f"{_API_BASE}/users/{_HOST_USER}/meetings"
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

    resp = requests.post(url, headers=headers, json=payload, timeout=10)
    resp.raise_for_status()
    return resp.json().get("join_url")
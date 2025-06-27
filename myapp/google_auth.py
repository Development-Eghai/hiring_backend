# utils/google_auth.py
from google_auth_oauthlib.flow import InstalledAppFlow
from google.oauth2.credentials import Credentials

SCOPES = ['https://www.googleapis.com/auth/calendar']

def get_credentials():
    try:
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    except Exception:
        flow = InstalledAppFlow.from_client_secrets_file('credentials.json', SCOPES)
        # creds = flow.run_local_server(port=8080)
        creds = flow.run_local_server(port=8080, open_browser=False)
        with open('token.json', 'w') as token_file:
            token_file.write(creds.to_json())
    return creds
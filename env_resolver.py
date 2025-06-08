import os
import re
from dotenv import dotenv_values

def interpolate_env_vars(raw_env, system_env=os.environ):
    """Interpolates $VARS in .env values using system environment variables."""
    pattern = re.compile(r'\$(\w+)', re.UNICODE)
    resolved = {}

    for key, value in raw_env.items():
        if not value:
            resolved[key] = value
            continue

        def replacer(match):
            var = match.group(1)
            return system_env.get(var, '')

        resolved[key] = pattern.sub(replacer, value)

    return resolved

def load_env(dotenv_path=".env"):
    """Loads .env values, interpolates, and gives system env precedence."""
    raw_env = dotenv_values(dotenv_path)
    interpolated_env = interpolate_env_vars(raw_env)

    final_env = {}
    for key, value in interpolated_env.items():
        # Use system env if defined, else fallback to .env
        final_env[key] = os.environ.get(key, value)
        os.environ[key] = final_env[key]  # optionally export to os.environ

    return final_env

from rest_framework.response import Response
from functools import wraps
from rest_framework_simplejwt.tokens import AccessToken
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework import status

def api_json_response_format(status,message,error_code,data):
    result_json = {"success" : status,"message" : message,"error_code" : error_code,"data": data}
    return result_json

def jwt_required(func):
    @wraps(func)
    def wrapper(request, *args, **kwargs):
        auth_header = request.headers.get('Authorization')

        if not auth_header or not auth_header.startswith('Bearer '):
            return Response({'error': 'Authorization header missing or invalid'}, status=status.HTTP_401_UNAUTHORIZED)

        token_str = auth_header.split(' ')[1]

        try:
            token = AccessToken(token_str)          
            request.user_id = token['user_id']  # Optional: inject user_id into request
        except TokenError as e:
            print(e)
            return Response({'error': 'Invalid or expired token'}, status=status.HTTP_401_UNAUTHORIZED)

        return func(request, *args, **kwargs)

    return wrapper
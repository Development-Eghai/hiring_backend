from rest_framework import serializers
from .models import Candidates,UserDetails


class CandidatesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Candidates
        fields = '__all__'

    def validate_email(self, value):
        # Prevent duplicate email
        if Candidates.objects.filter(Email=value).exists():
            raise serializers.ValidationError("This email already exists.")
        return value

class UsersSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserDetails
        fields = '__all__'

# class BlogDetailsSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = BlogDetails
#         fields = '__all__'

# class BlogCommentsSerializer(serializers.ModelSerializer):
    

#     class Meta:
#         model = BlogComments
#         fields = '__all__'

# class PostJobsSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = PostJobs
#         fields = '__all__'

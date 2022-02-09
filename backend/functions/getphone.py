#function to get phone number from google
from email.policy import default
from firebase_admin import auth
def getphone(token):
    try:
        decoded_token=auth.verify_id_token(token)
        phone=str(decoded_token["phone_number"])
        return phone
    except:
        return "";
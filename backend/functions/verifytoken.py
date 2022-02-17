#function to check login from google
from firebase_admin import auth
def verifytoken(token):
    try:
        decoded_token=auth.verify_id_token(token)
        return True
    except:
        print("token failed")
        return False
    

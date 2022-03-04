from flask import Blueprint, request
from functions import verifytoken, getdatabaseurl, getphone
import sqlite3
from firebase_admin import messaging, exceptions
requestbloodclient = Blueprint("requestbloodclient", __name__)
# login page


@requestbloodclient.route('/request', methods=["POST"])
def requestBloodClient():
    data = request.form
    for a in ['token', 'bloodgroup', 'location','phone']:
        if a not in data.keys():
            return {
                "status": 0,
                "message": "please provide a token id."
            }
    token = str(data.get('token'))
    bloodgroup = str(data.get('bloodgroup'))
    location = str(data.get('location'))
    phone = str(data.get('phone'))
    isvalid = verifytoken.verifytoken(token)
    if not isvalid:
        return {
            "status": 0,
            "message": "invalid Token code"
        }
    phone = str(getphone.getphone(token))
    if phone == "":
        return {
            "status": 0,
            "message": "error getting phone number"
        }
    db = sqlite3.connect(getdatabaseurl.getdatabaseurl())
    rows = db.execute(
        "select * from userdetails where phone = ?", (phone,))
    datas = rows.fetchall()
    if len(datas) == 0:
        return {
            "status": 11,
            "message": "please register"
        }
    message_title = bloodgroup+" Blood Needed"
    message_body = datas[0][2]+" is requesting for blood group " + \
        bloodgroup + " at " + location
    try:
        topic=bloodgroup.replace("+","plus")
        topic=topic.replace("-","minus")
        message = messaging.Message(
            notification=messaging.Notification(
                title=message_title,
                body=message_body
            ),
            topic=str(topic),
            data={
                "blood_group": bloodgroup,
                "contact": phone,
                "location": location,
                "type": "client",
                "name":datas[0][2],
            }
        )
        messaging.send(message)
        return {
            "status": 1,
            "message": "request sent."
        }

    except exceptions.FirebaseError as e:
        print(e)
        return {
            "status": 0,
            "message": "failed to send notification"
        }

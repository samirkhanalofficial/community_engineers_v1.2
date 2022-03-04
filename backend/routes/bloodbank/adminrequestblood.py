import sqlite3
from flask import Blueprint, request
from functions import getdatabaseurl
from firebase_admin import messaging,exceptions
adminrequestblood = Blueprint("adminrequestblood", __name__)


@adminrequestblood.route("/admin/request", methods=["POST"])
def adminrequestBlood():
    for a in ['email', 'password', 'bloodgroup']:
        if a not in request.form:
            return {
                "status": 0,
                "message": "Invalid Request"
            }
    email = request.form.get("email")
    password = request.form.get("password").upper()
    bloodgroup = request.form.get("bloodgroup")
    if bloodgroup not in ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]:
        return {
            "status": 0,
            "message": "Invalid Request"
        }
    db = sqlite3.connect(getdatabaseurl.getdatabaseurl())
    rows = db.execute(
        "SELECT * FROM bloodbankdetails WHERE email=? AND password=?", (email, password,))
    datas = rows.fetchall()
    if len(datas) == 1:
        message_title = bloodgroup+" Blood Needed"
        topic=bloodgroup.replace("+","plus")
        topic=topic.replace("-","minus")
        print(topic)
        message_body = "The blood bank at " + datas[0][3]+" is requesting for blood."
        try:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=message_title,
                    body=message_body
                ),
                topic=str(topic),
                data={
                    "blood_group":bloodgroup,
                    "contact":datas[0][4],
                    "location":datas[0][3],
                    "type":"bloodbank"
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
    return {
        "status": 0,
        "message": "login error"
    }

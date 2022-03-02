import sqlite3
from flask import Blueprint, request
from pyfcm import FCMNotification
from functions import getdatabaseurl

push_service = FCMNotification(
    api_key="AAAAHtIN5UU:APA91bFWjdcP8OVzhRlPVAI434c8J7xm8D8htMuiURmY79H1SXq-fIgo3Zy4UZQLJTThkiej9_zTME3VE4CqELrA-muTxxwHR-hc1xioHiemhMxv01IYOFFCSR6XJO_LFaX4139B-h98")
adminrequestblood = Blueprint("adminrequestblood", __name__)


@adminrequestblood.route("/admin/request", methods=["POST"])
def adminrequestBlood():
    for a in ['email','password','bloodgroup']:
            if a not in request.form:
                return {
                    "status":0,
                    "message":"Invalid Request"
                }
    email = request.form.get("email")
    password = request.form.get("password").upper()
    bloodgroup = request.form.get("bloodgroup")
    if bloodgroup not in ["A+","A-","B+","B-","AB+","AB-","O+","O-"]:
        return {
                    "status":0,
                    "message":"Invalid Request"
                }
    db = sqlite3.connect(getdatabaseurl.getdatabaseurl())
    rows = db.execute(
        "SELECT * FROM bloodbankdetails WHERE email=? AND password=?", (email, password,))
    datas = rows.fetchall()
    if len(datas) == 1:
        registration_ids = ["np.com.samirk.donateplus", ]
        message_title = bloodgroup+" Blood Needed"
        message_body = "The blood bank at "+datas[0][3]+" needs blood. Please help if you can. Contact : "+datas[0][4]
        try:
            push_service.notify_multiple_devices(
                registration_ids=registration_ids, message_title=message_title, message_body=message_body)
            return {
                "status": 1,
                "message": "request sent."
            }

        except:
            return {
                "status": 0,
                "message": "failed to send notification"
            }
    return {
        "status": 0,
        "message": "login error"
    }

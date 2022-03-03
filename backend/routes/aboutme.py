from email.policy import default
from flask import Blueprint, request
from functions import verifytoken, getdatabaseurl, getphone
import sqlite3
aboutme = Blueprint("aboutme", __name__)
# login page


@aboutme.route('/aboutme', methods=["POST"])
def aboutMe():
    data = request.form
    if 'token' not in data.keys():
        return {
            "status": 0,
            "message": "please provide a token id."
        }
    token = str(data.get('token'))
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
    datas=rows.fetchall()
    if len(datas) == 0:
        return {
            "status": 11,
            "message": "please register"
        }
    return {
        "status": 1,
        "datas":datas[0]
    }

from hashlib import sha256
import sqlite3
from flask import request,Blueprint
from functions import getdatabaseurl
updatebloodcount=Blueprint("updatebloodcount",__name__)
updatebloodcount.route("/admin/update")
def updateBloodCount():
    data=request.form
    datas=[];
    for b in ["email","password"]:
        if a not in data:
            return {
                "status":0,
                "message":"Please login first"
            }
    email=data.email
    password=sha256(data.password.encode()).hexdigest().upper()
    datas.append(email)
    datas.append(password)
    for a in ["A+","A-","B+","B-","AB+","AB-","O+","O-"]:
        if a not in data:
            return {
                "status":0,
                "message":"invalid data"
            }
        else:
            if not data.get(a).isdigit :
                return {
                    "status":0,
                    "message":"bloodcount must not be string."
                }
            else:
                datas.append(int(a))
    try:
        db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
        db.execute("UPDATE INTO bloodbankdetails WHERE email=? AND password=? SET A+=? , A-=?, B+=? , B-=?, AB+=?, AB-=?, O+=?,O-=?')",tuple(datas))
        return {
            "status":1,
            "message":"data updated successfully"
        }
    except:
        return {
            "status":0,
            "message":"Updating failed"
        }
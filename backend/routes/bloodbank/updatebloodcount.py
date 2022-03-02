from hashlib import sha256
import sqlite3
from flask import request,Blueprint
from functions import getdatabaseurl
updatebloodcount=Blueprint("updatebloodcount",__name__)
@updatebloodcount.route("/admin/update",methods=["POST"])
def updateBloodCount():
    data=request.form
    datas=[];
    for b in ["email","password"]:
        if b not in data:
            return {
                "status":0,
                "message":"Please login first"
            }
    email=data.get("email")
    password=data.get("password").upper()
    
    for a in ["A+","A-","B+","B-","AB+","AB-","O+","O-"]:
        if a not in data:
            return {
                "status":0,
                "message":"invalid data"
            }
        else:
            if not data.get(a).isdigit() :
                return {
                    "status":0,
                    "message":"bloodcount must not be string."
                }
            else:
                datas.append(int(data.get(a)))
    try:
        datas.append(email)
        datas.append(password)
        db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
        try:
            print(tuple(datas))
            db.execute("UPDATE bloodbankdetails SET `A+`=? , `A-`=?, `B+`=? , `B-`=?, `AB+`=?, `AB-`=?, `O+`=?,`O-`=? WHERE email=? AND password=? ",tuple(datas))
            db.commit()
            return {
            "status":1,
            "message":"data updated successfully"
            }
        except sqlite3.Error as err:
            return {
            "status":0,
            "message":"error updating database"+err
        }
    except sqlite3.Error as err:
        return {
            "status":0,
            "message":str(err)
        }
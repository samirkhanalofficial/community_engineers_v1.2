import sqlite3
from flask import request,Blueprint
from functions import getdatabaseurl

getbloodcount=Blueprint("getbloodcount",__name__)
@getbloodcount.route("/admin/get",methods=["POST","GET"])
def getBloodCount():
    data=request.form
    for b in ["email","password"]:
        if b not in data:
            return {
                "status":0,
                "message":"Please login first"
            }
    email=data.get("email")
    password=data.get("password")
    try:
        db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
        rows=db.execute("SELECT * FROM bloodbankdetails WHERE email=? AND password=?",(email,password,)).fetchall()
        row_temp=[]
        blood_groups=["A+","A-","B+","B-","AB+","AB-","O+","O-"]
        for i in range(5,len(rows[0])):
            row_temp.append({
                "blood_group":blood_groups[(i-5)],
                "count":rows[0][i]
            })
        return {
            "status":1,
            "data":{
                "location":rows[0][3],
                "phone":rows[0][4],
                "datas":row_temp
            }
        }
    except:
        return {
            "status":0,
            "message":"Incorrect username or password."
        }
    
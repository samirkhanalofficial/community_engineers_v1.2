import sqlite3
from functions import getdatabaseurl
from flask import Blueprint,request
admindetails=Blueprint("admindetails",__name__)
@admindetails.route("/admin/details",methods=["POST"])
def adminDetails():
    db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
    if request.form.get("method")=="GET":
        for a in ['email','password']:
            if a not in request.form:
                return {
                    "status":0,
                    "message":"Invalid Request"
                }
        email=request.form.get("email")
        password=request.form.get("password")
        try:
            datas=db.execute("SELECT * FROM bloodbankdetails WHERE email=? AND password=?",(email,password,))
            tempdata=list(datas.fetchall()[0])
            tempdata2=[]
            tempdata2.append(tempdata[3])
            tempdata2.append(tempdata[4])
            return {
                "status":1,
                "datas":tempdata2
                }
        except:
            return {
                "status":0,
                "message":"Error retriving data"
                }
    else:
        for a in ['email','password','location','phone']:
            if a not in request.form:
                return {
                    "status":0,
                    "message":"Invalid Request"
                }
        email=request.form.get("email")
        password=request.form.get("password").upper()
        location=request.form.get("location")
        phone=request.form.get("phone")
        try:
            db.execute("UPDATE bloodbankdetails SET location=? , contact=? WHERE email=? AND password=?",(location,phone,email,password))
            db.commit()
            return {
                    "status":1,
                    "message":"Data saved"
                }
        except:
            return {
                    "status":0,
                    "message":"Error Saving data"
                }


import sqlite3
from functions import getdatabaseurl
from flask import Blueprint,request
admindetails=Blueprint("admindetails",__name__)
@admindetails.route("/admin/details",methods=["POST"])
def adminDetails():
    db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
    if request.form.get("method")=="GET":
        email=request.form.get("email")
        password=request.form.get("password")
        datas=db.execute("SELECT * FROM bloodbankdetails WHERE email=? AND password=?",(email,password,))
        tempdata=list(datas.fetchone())
        tempdata2=[]
        tempdata2.append(tempdata[3])
        tempdata2.append(tempdata[4])
        return {
            "status":1,
            "datas":tempdata2
        }
    else:
        email=request.form.get("email")
        password=request.form.get("password")

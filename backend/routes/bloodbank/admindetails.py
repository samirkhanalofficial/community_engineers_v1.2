import sqlite3
from functions import getdatabaseurl
from flask import Blueprint,request
admindetails=Blueprint("admindetails",__name__)
@admindetails.route("/admin/details",methods=["POST","GET"])
def adminDetails():
    db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
    if request.method=="GET":
        email=request.form.get("email")
        password=request.form.get("password")
        datas=db.execute("SELECT * FROM bloodbankdetails WHERE email=? AND password=?",(email,password,));
        return {
            "status":1,
            "datas":datas.fetchall()
        }
    else:
        email=request.form.get("email")
        password=request.form.get("password")

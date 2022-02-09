import sqlite3
from flask import Blueprint,request
from functions import getdatabaseurl
from hashlib import md5
adminlogin=Blueprint("adminlogin",__name__)

@adminlogin.route("/admin/login",methods=["POST"])
def adminLogin():
    #email , password 
    #check in database
    # md5
    # p="samir"
    #bloodbankdetails
    # password=md5(p)
    data=request.form 
    if "email" not in data.keys() or  "password" not in data.keys():
        return {
            "status":0,
            "message":"Invalid request."
        }
    email=data.get("email")
    password=data.get("password")
    password=md5(password.encode()).hexdigest()
    database=sqlite3.connect(getdatabaseurl.getdatabaseurl())
    rows=database.execute("SELECT * FROM bloodbankdetails WHERE email = ? AND password = ? ", (email, password,))
    if len(rows.fetchall()) ==0:
        return {
            "status":0,
            "message":"Incorrect email or password."
        }
    else:
        return {
        "status":1,
        "message":"login sucessful."
    }
    



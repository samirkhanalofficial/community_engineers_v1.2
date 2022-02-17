from hashlib import sha256
import sqlite3
from flask import request,Blueprint
from functions import getdatabaseurl
getbloodcount=Blueprint("getbloodcount",__name__)

getbloodcount.route("/admin/get",methods=["POST","GET"])
def getBloodCount():
    return "test"
    # data=request.form
    # datas=[];
    # for b in ["email","password"]:
    #     if b not in data:
    #         return {
    #             "status":0,
    #             "message":"Please login first"
    #         }
    # email=data.email
    # password=sha256(data.password.encode()).hexdigest().upper()
    # datas.append(email)
    # datas.append(password)
    # try:
    #     db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
    #     rows=db.execute("SELECT * FROM bloodbankdetails WHERE email=? AND password=?')",(email,password,)).fetchall()
    #     return {
    #         "status":1,
    #         "data":rows
    #     }
    # except:
    #     return {
    #         "status":0,
    #         "message":"Incorrect username or password."
    #     }
    
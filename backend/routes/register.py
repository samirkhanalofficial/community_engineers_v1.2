from datetime import datetime
from flask import Blueprint,request
import sqlite3
from functions import getphone,getdatabaseurl,verifytoken

#register page

register=Blueprint("register",__name__)
@register.route('/register',methods=["POST"])
def registerpage():
    data=request.form
    for key in ['location','name','weight','bloodgroup','disease','dob']:
        if(key not in data.keys()):
            return {
            "status":0,
            "message":"invalid information."
            }
    token=data.get('token')
    isvalid=verifytoken.verifytoken(token)
    phone=getphone.getphone(token)
    name=data.get("name")
    weighttemp=data.get("weight")
    dob=data.get("dob")
    bloodgroup=data.get("bloodgroup")
    disease=data.get("disease")
    location=data.get("location")
    if len(name)<3:
        return {
            "status":0,
            "message":"name must be at least 3 characters."
        }
    elif not weighttemp.isdigit():
       return {
            "status":0,
            "message":"Please enter your correct weight in number."
        }
    elif bloodgroup not in ["A+","A-","B+","B-","AB+","AB-","O+","O-"]:
        return  {
            "status":0,
            "message":"Please enter a valid blood group."
        }
    elif not datetime.strptime(dob,'%d/%m/%Y'):
        return {
            "status":0,
            "message":"Please enter a valid birthdate."
        }
    elif not isvalid:
        return {
            "status" : 0,
            "message":"Invalid login info."
        }
    elif len(location)<3:
        return {
            "status":0,
            "message":"Please enter a valid location."
        }
    weight=int(weighttemp)
    db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
    try:
        rows = db.execute(
        "select * from userdetails where phone = ?",(phone,))
        if len(rows.fetchall()) !=0:
            return {
            "status": 0,
            "message": "User Already Exists. Please login"
        }
        db.execute("INSERT INTO userdetails (phone,name,bloodgroup,weight,disease,dob,location) VALUES(?,?,?,?,?,?,?)",(phone,name,bloodgroup,weight,disease,dob,location,))
        db.commit()
        db.close()
        return {
            "status":1,
            "message":"User Registration Successful."
            }
    except:
        db.close()
        return {
            "status" : 0,
            "message":"Registration error."
        }
        

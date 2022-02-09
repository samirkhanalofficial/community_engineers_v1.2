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
    elif not datetime.strptime(dob,"%d/%m/%y"):
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
    bday=datetime.strptime(dob,"%d/%m/%y")
    weight=int(weighttemp)
    db=sqlite3.connect(getdatabaseurl.getdatabaseurl())
    try:
        db.execute("INSERT INTO userdetails (phone,name,bloodgroup,weight,disease,bday,location) VALUES(?,?,?,?,?,?,?)",(phone,name,bloodgroup,weight,disease,bday,location,))
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
            "message":"Someting went wrong."
        }
        

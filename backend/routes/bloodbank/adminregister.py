from hashlib import md5, sha256
from flask import Blueprint, request
import sqlite3
from functions import getdatabaseurl
adminregister = Blueprint('adminregister', __name__)


@adminregister.route('/admin/adminregister')
def adminRegister():
    # email,password,location,phone,adminemail,adminpass,
    data = request.form
    for key in ['email', 'location', 'phone', 'password', 'adminemail', 'adminpassword']:
        if(key not in data.keys()):
            return {
                "status": 0,
                "message": "Invalid information."

            }
    email = data.get('email')
    phone = data.get('phone')
    location = data.get("location")
    password = data.get('password')
    if len(location) < 3:
        return{"status": 0,
               "message": "Enter correct Location."
               }
    elif len(phone) < 5:
        return{"status": 0,
               "message": "Enter correct Phone number."
               }
    elif len(password) < 8:
        return{"status": 0,
               "message": "Password must be at least 8 character long."
               }
    password = sha256(password.encode()).hexdigest().upper()
    db = sqlite3.connect(getdatabaseurl.getdatabaseurl())
    adminemail = data.get('adminemail')
    adminpassword = sha256(data.get('adminpassword').encode()).hexdigest()
    admins = db.execute(
        "SELECT * FROM admin WHERE email=? AND password=?", (adminemail, adminpassword,))
    if len(admins.fetchall()) == 0:
        return {
            "status": 0,
            "message": "Incorrect admin login details."
        }
    try:
        db.execute("INSERT INTO bloodbankdetails (email,password,location,contact) VALUES(?,?,?,?)",
                   (email, password, location, phone,))
        db.commit()
        return {
            "status": 1,
            "message": password
        }
    except:
        return {
            "status": 0,
            "message": "Error adding blood bank user.."
        }
    db.close()
    # admin email , admin password databaseko admin vanne table maa xa ki xina
    # rows=select--> where email=admin and password=adminpassword

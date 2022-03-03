import sqlite3
from functions import getdatabaseurl
from flask import Blueprint, request
getbloodbanksdetails = Blueprint("getbloodbanksdetails", __name__)


@getbloodbanksdetails.route("/bloodbanks", methods=["GET"])
def getbloodbanksDetails():
    db = sqlite3.connect(getdatabaseurl.getdatabaseurl())
    datas = db.execute(
        "SELECT * FROM bloodbankdetails")
    tempdata = list(datas.fetchall())
    print(tempdata)
    datas2 = []
    for b in tempdata:
        a=list(b)
        a.pop(0)
        a.pop(0)
        a.pop(0)
        datas2.append(a)
    return {
                "status": 1,
                "datas": datas2
                }
    
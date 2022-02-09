from flask import Flask,render_template,Blueprint
index=Blueprint("index",__name__)
@index.route('/')
def indexpage():
    return render_template("index.html",name="gaurav")

import firebase_admin
from flask import Flask
from routes import login,register,index,getbloodbanksdetails,aboutme,requestbloodclient
from routes.bloodbank import adminregister,adminlogin,getbloodcount,updatebloodcount,admindetails,adminrequestblood
app = Flask(__name__)
host="127.0.0.1"
port=80
#initializing firebase
defaultapp = firebase_admin.initialize_app()

# make environment variable of name: GOOGLE_APPLICATION_CREDENTIALS
# choose the json file i provided in facebook (don't copy that file in the community
# engineer folder or working directory and dont share) 


#routes 

app.register_blueprint(index.index)
app.register_blueprint(login.login)
app.register_blueprint(register.register)
app.register_blueprint(getbloodbanksdetails.getbloodbanksdetails)
app.register_blueprint(aboutme.aboutme)
app.register_blueprint(requestbloodclient.requestbloodclient)
#admin routes
app.register_blueprint(adminregister.adminregister)
app.register_blueprint(adminlogin.adminlogin)
app.register_blueprint(getbloodcount.getbloodcount)
app.register_blueprint(updatebloodcount.updatebloodcount)
app.register_blueprint(admindetails.admindetails)
app.register_blueprint(adminrequestblood.adminrequestblood)
if __name__ == "__main__":
    app.run()


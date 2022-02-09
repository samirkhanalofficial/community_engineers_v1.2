import firebase_admin
from flask import Flask
from routes import login,register,index
from routes.bloodbank import adminregister,adminlogin
app = Flask(__name__)
#initializing firebase
defaultapp = firebase_admin.initialize_app()

# make environment variable of name: GOOGLE_APPLICATION_CREDENTIALS
# choose the json file i provided in facebook (don't copy that file in the community
# engineer folder or working directory and dont share) 


#routes 

app.register_blueprint(index.index)
app.register_blueprint(login.login)
app.register_blueprint(register.register)
#admin routes
app.register_blueprint(adminregister.adminregister)
app.register_blueprint(adminlogin.adminlogin)
app.run(port=80,debug=True)


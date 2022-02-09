# Donate +

<img src="./app/donateplus/assets/logo.png" width="300px"/>

## Requirements

1. **Git**
2. **Python 3** (with pip installed)
3. **Flutter sdk** (for app development)
4. **Android studio** (android sdk) (for app development)

## Installation

1. Open the terminal in desired directory.
2. clone this git repository with the command

    ```git clone https://github.com/samirlure161/community_engineers_v1.2.git```

## Setup

### Backend Setup

1. create a virtual environment  
    ```python -m venv .venv```
2. if you are in windows, you have to set execution policy to unrestricted.
   ```set-ExecutionPolicy Unrestricted -Scope Process```
3. After this, activate virtual environment
   + **windows** : ```.\backend\.venv\Scripts\activate.ps1```
   + **others** : ```.\backend\.venv\Scripts\activate.sh```
4. Use this command to install all the required package
    ```pip install -r requirements.txt```
5. Set enviroment variable of name `GOOGLE_APPLICATION_CREDENTIALS` with the path of the firebase admin config file (JSON) of our project.
6. now Run this command to run backend server
   ```python .\backend\main.py```

### App Setup

1. Move to the Requireq app folder
   + For Bloodbanks :
    ```cd .\app\bloodbank\```
   + For Clients :
    ```cd .\app\donateplus\```

    Place the firebase auth config file of the client app project in `<projectlocation>\app\android\app`
2. Get required packages
   ```flutter pub get```
3. Run in debug mode:
   ```flutter run```
For more Details on Flutter builds and more refer to [Flutter's official Documentation](https://flutter.dev)

### Git Commands

please do not write this symbol (<>) while using commands. directly enter the value. eg. `git branch samir/feature/app/donateplusclient`

+ **clone a repo**: `git clone <https-url-of-repo>`
+ **initialize git for a project**: `git init`
+ **create new branch**: `git branch <branchname>`
+ **adding all files**: `git add -A`
+ **commiting changes**: `git commit -am "<comment here>"`
+ **adding origin**: `git remote add origin <https-url-of-repo>`
+ **merging branches**: `git merge <where> <which-branch>`
+ **switch to branch**: `git checkout <branchname>`
+ **Pushing branch to github**: `git push -u origin <branch-name>`
    Note: Please do not push to main branch.
+ **deleting local branch**: `git branch -D <branch-name>`
+ **Pulling**: `git pull origin <branch-name>`
+ **fetching**: `git fetch origin <branch-name>`

## Required Files

+ **Firebase Config Files**
    Please ask for the project leader for this file. And donot share this file with anyone cause it is extremely dangarous for security of the app. and donot upload it either in github or any other platform.

+ **Database Browser (Sqlite Browser)**
    Click [here](https://sqlitebrowser.org/) to download the Database browser.

## Learning Resources

In this project we will be using python , sql and dart. Thus please refer to the following docs/videos for learning.

### Docs

+ Python: [python.org](https://python.org)
+ Python Packages: [pypi.org]((https://pypi.org/))
+ Flask: [Documentation](https://flask.palletsprojects.com/en/2.0.x/)
+ Flutter: [flutter.dev](https://flutter.dev)
+ Flutter packages: [pub.dev](https://pub.dev)

#### Videos

+ [Python in Hindi (Code with Harry)](https://www.youtube.com/watch?v=gfDE2a7MKjA)
+ [Flask in Hindi (Code with Harry)](https://www.youtube.com/watch?v=oA8brF3w5XQ)
+ [Harvard University (Python)](https://www.youtube.com/watch?v=ky-24RvI57s)
+ [Harvard University (Flask)](https://www.youtube.com/watch?v=CUIK3tKNH5E)
+ [Harvard University (sql)](https://www.youtube.com/watch?v=D-1kNFO568c)
+ [Managing Flask routes](https://www.youtube.com/watch?v=WteIH6J9v64)
+ [Flutter](https://www.youtube.com/watch?v=j-LOab_PzzU)

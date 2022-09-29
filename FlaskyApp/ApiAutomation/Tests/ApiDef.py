import os
import requests
import json

class ApiDef:
    #API paths
    host = "http://localhost:8080/api/"
    loginPath = "auth/token"
    users = "users"

    #Getting current working directory
    currentDirectory = os.getcwd()

    #Json file locations
    registerUserJsonLoc = currentDirectory+'\\FlaskyApp\\ApiAutomation\\Resources\\TestData\\registerUser.json'
    modifyUserJsonLoc = currentDirectory+'\\FlaskyApp\\ApiAutomation\\Resources\\TestData\\modifyUser.json'
    #Username in invalidUserData.json should be same as registerUser.json
    invalidUserDataLoc = currentDirectory+'\\FlaskyApp\\ApiAutomation\\Resources\\TestData\\invalidUserData.json'
  
    #Method of Login API
    def login(self, username, password):
        #Need to pass Username and Password for authentication
        apiPath = self.host+self.loginPath  #ApiPath for login
        response = requests.get(apiPath,auth=(username,password), headers={'Content-Type': 'application/json'})        
        json_response = response.json()
        #Getting token only when the call is success
        if response.status_code == 200:
            token = json_response['token']  #Extracting token from response
        else:
            token = 'none'
        return token, response

    def get_users(self,jsonfileLocation):
        #Need to pass payload file location used for registration to get the username for verifying it against response
        apiPath = self.host+self.users  #ApiPath for get registered users
        response = requests.get(apiPath, headers={'Content-Type': 'application/json'})
        getUserDetailsJson = self.read_json(jsonfileLocation)
        username = getUserDetailsJson['username'] #Getting username from payload which is used to register user
        json_response = response.json() 
        usernameInResponse = username in json_response['payload'] #Verifying whethe username in the payload is returned by API
        return response, usernameInResponse

    def register_user(self,jsonfileLocation):
        #Need to pass payload file location for registration
        apiPath = self.host+self.users  #ApiPath for registering user
        registerUserJsonFile = self.read_json(jsonfileLocation)
        response = requests.post(apiPath,json=registerUserJsonFile, headers={'Content-Type': 'application/json'})                
        return response

    def get_user_details(self,jsonfileLocation,isFileLocation):
        #Need to pass payload File location or payload object used for registration/modification. isFileLocation should be True if we pass file location or False if we pass object
        #Condition to tell the method the received jsonfileLocation is a filelocation or python object to make use of the same method in different test case
        if isFileLocation:
            getUserDetailsJson = self.read_json(jsonfileLocation)
        else:
            getUserDetailsJson = jsonfileLocation
        username = getUserDetailsJson['username']
        password = getUserDetailsJson['password']
        token, response = self.login(username, password)    #logging in to the application to get the token to pass it to GET users api
        apiPath = self.host+self.users+'/'+username
        response = requests.get(apiPath, headers={'Content-Type': 'application/json','Token': token})
        return response, getUserDetailsJson

    def modify_user_details(self,jsonfileLocation,modifyJsonfileLocation):
        #jsonfileLocation is the payload file location used for registration to get credentials and modifyJsonfileLocation is the payload file location which has modification data
        getUserDetailsJson = self.read_json(jsonfileLocation)
        username = getUserDetailsJson['username']
        password = getUserDetailsJson['password']
        modifyUserDetailsjsonFile = self.read_json(modifyJsonfileLocation)
        token, response = self.login(username, password)
        apiPath = self.host+self.users+'/'+username
        response = requests.put(apiPath, json=modifyUserDetailsjsonFile, headers={'Content-Type': 'application/json','Token': token})
        modifyUserDetailsjsonFile['username']=username  #Adding username to the object for further verification in the test case
        modifyUserDetailsjsonFile['password']=password  #Adding password to the object for further verification in the test case
        return response, modifyUserDetailsjsonFile
        
    def read_json(self,fileLocation):
        #Read the json file and returns as python object
        file = open(fileLocation,'r')
        jsonFile= file.read()
        jsonObj = json.loads(jsonFile)
        file.close()
        return jsonObj


import json
import pytest
from Tests.ApiDef import ApiDef


class Test_ApiFlaskyApp(ApiDef):
       
    #Tests
    @pytest.mark.dependency()
    def test_register_new_user(self):
        """
        GIVEN I need to register new user
        WHEN I POST the user payload to api/users path
        THEN New user is registered        
        """
        apiDef = ApiDef() 
        #Make POST request to register new user with input json
        response = apiDef.register_user(self.registerUserJsonLoc)
        #Parsing response content in jsonpath to validate the status and message
        json_response = response.json()
        #Validating response code
        assert response.status_code == 201 , "Status code is not 201"
        #Validating response
        assert json_response['message'] == "Created", "Message is not as expected as 'Created'"
        #Validating status
        assert json_response['status'] == "SUCCESS", "Status is not as expected as 'SUCCESS'"

    @pytest.mark.dependency(depends=['Test_ApiFlaskyApp::test_register_new_user'])    
    def test_get_user_details(self):
        """
        GIVEN User is already registered and need to verify registered user details
        WHEN I GET the user details from api/users/{username} path with Token from Login GET api
        THEN Registered user details is returned

        Pre-req - User should be registered as per registerUser.json
        """
        apiDef = ApiDef()         
        #GET request to api/users/{username} to get the details
        response_userinfo, requestRegisterUserJson = apiDef.get_user_details(self.registerUserJsonLoc, True)
        #Parsing response content in jsonpath to validate the details
        json_response_userInfo = response_userinfo.json()    
        #Validating response code
        assert response_userinfo.status_code == 200 , "Status code is not 200"
        #Validating user details
        assert json_response_userInfo['payload']['firstname'] == requestRegisterUserJson['firstname'] , "Firstname is not as expected"
        assert json_response_userInfo['payload']['lastname'] == requestRegisterUserJson['lastname'] , "Lastname is not as expected"
        assert json_response_userInfo['payload']['phone'] == requestRegisterUserJson['phone'] , "Phonenumber is not as expected"

    @pytest.mark.dependency(depends=['Test_ApiFlaskyApp::test_register_new_user'])
    def test_getUsers(self):
        """
        GIVEN Users are registered in the application
        WHEN I GET the users in the api/users
        THEN Registered users are returned in the response
        """
        apiDef = ApiDef()  
        #GET request to api/users to get the details
        response_users,usernameInResponse = apiDef.get_users(self.registerUserJsonLoc)
        #Parsing response content in jsonpath to validate the details
        json_response_users = response_users.json()    
        #Validating response code
        assert response_users.status_code == 200 , "Status code is not 200"
        #Validating registered user in the response
        assert usernameInResponse , "Expected user is not returned in the response"

    @pytest.mark.dependency(depends=['Test_ApiFlaskyApp::test_register_new_user'])
    def test_modifyUsers(self):
        """
        GIVEN Users are registered but need some modification
        WHEN I send the PUT request to api/users/{username} with modification details in Json
        THEN User gets updated
        AND I send the GET request to api/users/{username}
        AND I get the updated details of the user

        Pre-req - User should be registered as per registerUser.json
        """
        apiDef = ApiDef()
        #GET request to api/users/{username} to get the details
        response_modifyUserinfo, modifyUserJson = apiDef.modify_user_details(self.registerUserJsonLoc, self.modifyUserJsonLoc)
        #Validating response code
        assert response_modifyUserinfo.status_code == 201 , "Status code is not 201"
        #GET request to api/users/{username} to get the details
        response_userinfo, requestRegisterUserJson = apiDef.get_user_details(modifyUserJson, False)
        #Parsing response content in jsonpath to validate the details
        json_response_userInfo = response_userinfo.json()    
        #Validating response code
        assert response_userinfo.status_code == 200 , "Status code is not 200"
        #Validating user details
        assert json_response_userInfo['payload']['firstname'] == modifyUserJson['firstname'] , "Firstname is not as expected"
        assert json_response_userInfo['payload']['lastname'] == modifyUserJson['lastname'] , "Lastname is not as expected"
        assert json_response_userInfo['payload']['phone'] == modifyUserJson['phone'] , "Phonenumber is not as expected"

    @pytest.mark.dependency(depends=['Test_ApiFlaskyApp::test_register_new_user'])
    def test_register_new_user_excistingUsername(self):
        """
        GIVEN I need to register new user with existing username to verify the error
        WHEN I POST the user payload to api/users path with existing username
        THEN 'User exists' message return with failure status code        
        """
        apiDef = ApiDef() 
        #Make POST request to register new user with input json
        response = apiDef.register_user(self.invalidUserDataLoc)
        #Parsing response content in jsonpath to validate the status and message
        json_response = response.json()
        #Validating response code
        assert response.status_code == 400 , "Status code is not 400"
        #Validating response
        assert json_response['message'] == "User exists", "Message is not as expected as 'User exists'"
        #Validating status
        assert json_response['status'] == "FAILURE", "Status is not as expected as 'FAILURE'"

    
    @pytest.mark.dependency()
    def test_login_invalidCredentials(self):
        """
        GIVEN I need to login with invalid credentials to verify the error
        WHEN I GET the /api/auth/token with invalid credentials
        THEN 'Invalid Authentication' message return with failure status code        
        """
        apiDef = ApiDef() 
        #Reading username and password from invalidUserData.json
        invalidData = apiDef.read_json(self.invalidUserDataLoc)
        #Make GET request to Login with invalid credentials
        token, response = apiDef.login(invalidData['username'],invalidData['password'])
        #Parsing response content in jsonpath to validate the status and message
        json_response = response.json()
        #Validating response code
        assert response.status_code == 401 , "Status code is not 401"
        #Validating response
        assert json_response['message'] == "Invalid Authentication", "Message is not as expected as 'Invalid Authentication'"
        #Validating status
        assert json_response['status'] == "FAILURE", "Status is not as expected as 'FAILURE'"

    @pytest.mark.dependency()
    def test_modifyUsers_invalidData(self):
        """
        GIVEN Users are registered but need some modification with information not allowed to update such as username, password
        WHEN I send the PUT request to api/users/{username} with modification details in Json with username and password
        THEN User gets error message 'Field update not allowed'

        Pre-req - User should be registered as per registerUser.json
        """
        apiDef = ApiDef()
        #GET request to api/users/{username} to get the details
        response_modifyUserinfo, modifyUserJson = apiDef.modify_user_details(self.registerUserJsonLoc, self.invalidUserDataLoc)
        #Validating response code
        assert response_modifyUserinfo.status_code == 403 , "Status code is not 403"
        #Parsing response content in jsonpath to validate the status and message
        json_response = response_modifyUserinfo.json()
        #Validating response
        assert json_response['message'] == "Field update not allowed", "Message is not as expected as 'Field update not allowed'"
        #Validating status
        assert json_response['status'] == "FAILURE", "Status is not as expected as 'FAILURE'"









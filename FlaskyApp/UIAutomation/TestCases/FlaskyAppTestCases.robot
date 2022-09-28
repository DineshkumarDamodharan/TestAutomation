*** Settings ***
Documentation    This file has all the test cases of the Flasky application
Suite Setup    Generic Suite setup    ${screenshotDirectory}
Resource    ../Keywords/TestKeywords.robot
Resource    ../Resources/TestData.robot

*** Test Cases ***
1 Flasky App Smoke Test Case
    [Documentation]    GIVEN I want to verify that all the pages in the application loads correctly
    ...    WHEN I navigate to the application URL in browser,
    ...    THEN Index page opens AND I verify all the pages by navigating to each page
    [Tags]    SmokeTestCase

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Navigate to Login page
    Navigate to Index Page
    Close All Browsers
    [Teardown]    Generic TestCase teardown

2 Register User
    [Documentation]    GIVEN I want to register the new user in the application
    ...    WHEN I navigate to the registration page
    ...    AND I enter all the required Information AND I click Register button
    ...    Then The user gets registered in the application
    [Tags]    E2ETestCase

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Register User    Testuser    Test1234    Test    User    1234567890    
    Close All Browsers
    [Teardown]    Generic TestCase teardown

3 Login and Verify User Data
    [Documentation]    GIVEN I want to login to the application with credentials entered in test case '2 Register User'
    ...    WHEN I enter correct credentials AND Click Login button
    ...    THEN User logged in to the application AND User information entered during registration gets displayed
    ...
    ...    Dependency/Pre-req Test Case: 2 Register User
    [Tags]    E2ETestCase

    Open Application    ${Url}    ${browser}
    Navigate to Login Page
    Login to the application    Testuser    Test1234
    Verify User Information    Testuser    Test    User    1234567890
    Navigate to Index Page    True    Testuser
    Logout Application
    Close All Browsers
    [Teardown]    Generic TestCase teardown

4 Verify the mandaotry fields in Registration page 
    [Documentation]    GIVEN I want to verify the mandatory fields in the registration page
    ...    WHEN I leave one field empty AND filled other fields AND I click Register button
    ...    THEN Error message displayed over the empty field
    ...    AND I repeat this scenario for all the fields in the registration page
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Verify Mandatory fields in the page    Register
    Close All Browsers
    [Teardown]    Generic TestCase teardown

5 Verify the mandaotry fields in Login page 
    [Documentation]    GIVEN I want to verify the mandatory fields in the login page
    ...    WHEN I leave one field empty AND filled other field AND I click Login button
    ...    THEN Error message displayed over the empty field
    ...    AND I repeat this scenario for all the fields in the login page
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Verify Mandatory fields in the page    Login
    Close All Browsers
    [Teardown]    Generic TestCase teardown

6 Registering with the same username to verify the Error
    [Documentation]    GIVEN I want to test that appropriate error message gets displayed on registering with already registered username
    ...    WHEN I eneter already registered user name during registration AND fill other fields in the registration page AND click Register button
    ...    THEN I should see the error message stating the username is already registered
    ...
    ...    Dependency/Pre-req Test Case: 2 Register User    
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Register User    Testuser    Test1234    Test    User    abcdefghij    True    User Testuser is already registered.  
    Close All Browsers
    [Teardown]    Generic TestCase teardown

7 Login with Invalid Username
    [Documentation]    GIVEN I want to test the login error message on entering the invalid username
    ...    WHEN I enter invalid username AND correct password AND I click login button    
    ...    THEN I should get the error message stating Invalid credentials
    ...
    ...    Dependency/Pre-req Test Case: 2 Register User  
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Login to the application    Testuserabc    Test1234    True    You provided incorrect login details
    Close All Browsers
    [Teardown]    Generic TestCase teardown

8 Login with Invalid Password
    [Documentation]    GIVEN I want to test the login error message on entering the invalid password
    ...    WHEN I enter invalid password AND correct username AND I click login button    
    ...    THEN I should get the error message stating Invalid credentials
    ...
    ...    Dependency/Pre-req Test Case: 2 Register User    
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Login to the application    Testuser    Test123456    True    You provided incorrect login details
    Close All Browsers
    [Teardown]    Generic TestCase teardown

9 Verfiy that the username field is case sensitive
    [Documentation]    GIVEN I want to test that username field is case sensitive
    ...     WHEN I enter the username in login page with first character in lower case (Were the User registered with first letter as upper case in the username )
    ...    AND I enter correct password AND I click login button
    ...    THEN I should get the error message stating Invalid credentials
    ...
    ...    Dependency/Pre-req Test Case: 2 Register User 
    ...    Assumption: There is no acceptance criteria on username case sensitive scenario but the application is developed as such the username field in login screen is case sensitive and assumed it as acceptance criteria   
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Login to the application    testuser    Test1234    True    You provided incorrect login details
    Close All Browsers
    [Teardown]    Generic TestCase teardown

10 Verify that Phonenumber fields do not accpet Alphabets
    [Documentation]    GIVEN I want to verify that phone number field in the registration page accepts only numbers
    ...    WHEN I enter alphabets in the phone number field in the registration page AND fills other fields AND click Register button
    ...    THEN I should see the error message stating phone number field accepts only number
    ...
    ...    Known issue: Current version accepts alphabets in the phone number field which causes this test case failure
    ...    Assumption: As there is not requirementm assumed the error message as 'Alphabets not allowed in Phone Number field'
    [Tags]    NegativeFlow    knownIssue

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Register User    Testuser1    Test1234    Test    User    abcdefghij    True    Alphabets not allowed in Phone Number field   
    Close All Browsers
    [Teardown]    Generic TestCase teardown



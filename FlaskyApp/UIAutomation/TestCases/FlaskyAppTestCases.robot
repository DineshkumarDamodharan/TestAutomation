*** Settings ***
Documentation    This file has all the test cases of the Flasky application
Suite Setup    Generic Suite setup    ${screenshotDirectory}
Resource    ../Keywords/TestKeywords.robot
Resource    ../Resources/TestData.robot

*** Test Cases ***
1 Flasky App Smoke Test Case
    [Documentation]    This test case verifies all the pages in the application and its elements
    [Tags]    SmokeTestCase

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Navigate to Login page
    Navigate to Index Page
    Close All Browsers
    [Teardown]    Generic TestCase teardown

2 Register User
    [Documentation]    This test case registers the user with the given parameters.
    [Tags]    E2ETestCase

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Register User    Testuser    Test1234    Test    User    1234567890    
    Close All Browsers
    [Teardown]    Generic TestCase teardown

3 Login and Verify User Data
    [Documentation]    This test case registers the user with the given parameters.
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
    [Documentation]    This test case verifies the mandatory fiels in registration page
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Verify Mandatory fields in the page    Register
    Close All Browsers
    [Teardown]    Generic TestCase teardown

5 Verify the mandaotry fields in Login page 
    [Documentation]    This test case verifies the mandatory fiels in Login page
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Verify Mandatory fields in the page    Login
    Close All Browsers
    [Teardown]    Generic TestCase teardown

6 Registering with the same username to verify the Error
    [Documentation]    This test case verifies whether error message is displayed on registering the user with already registered username. 
    ...    Dependency/Pre-req Test Case: 2 Register User    
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Register User    Testuser    Test1234    Test    User    abcdefghij    True    User Testuser is already registered.  
    Close All Browsers
    [Teardown]    Generic TestCase teardown

7 Login with Invalid Username
    [Documentation]    This test case will login with invalid username and verifies the error message displayed. 
    ...    Dependency/Pre-req Test Case: 2 Register User    
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Login to the application    Testuserabc    Test1234    True    You provided incorrect login details
    Close All Browsers
    [Teardown]    Generic TestCase teardown

8 Login with Invalid Password
    [Documentation]    This test case will login with invalid password and verifies the error message displayed. 
    ...    Dependency/Pre-req Test Case: 2 Register User    
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Login to the application    Testuser    Test123456    True    You provided incorrect login details
    Close All Browsers
    [Teardown]    Generic TestCase teardown

9 Verfiy that the username field is case sensitive
    [Documentation]    This test case will login with username with first character as lower case (Registered the username with first character in uppe case) and verifies the error message displayed. 
    ...    Dependency/Pre-req Test Case: 2 Register User 
    ...    Assumption: There is no acceptance criteria on username case sensitive scenario but the application is developed as such the username field in login screen is case sensitive and assumed it as acceptance criteria   
    [Tags]    NegativeFlow

    Open Application    ${Url}    ${browser}
    Navigate to Login page
    Login to the application    testuser    Test1234    True    You provided incorrect login details
    Close All Browsers
    [Teardown]    Generic TestCase teardown

10 Verify that Phonenumber fields do not accpet Alphabets
    [Documentation]    This test case verifies that the phone number fields do not accept alphabets. We enter only alphabets
    ...    in the phonenumber field and verify registration throws error
    ...    Known issue: Current version accepts alphabets in the phone number field which causes this test case failure
    ...    Assumption: As there is not requirementm assumed the error message as 'Alphabets not allowed in Phone Number field'
    [Tags]    NegativeFlow    knownIssue

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Register User    Testuser1    Test1234    Test    User    abcdefghij    True    Alphabets not allowed in Phone Number field   
    Close All Browsers
    [Teardown]    Generic TestCase teardown



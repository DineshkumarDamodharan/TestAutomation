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
    Close All Browsers
    [Teardown]    Generic TestCase teardown

2 Register User
    [Documentation]    This test case registers the user with the given parameters.
    [Tags]    E2ETestCase

    Open Application    ${Url}    ${browser}
    Navigate to Registration page
    Register User    Username    Test1234    Test    User    1234567890    
    Close All Browsers
    [Teardown]    Generic TestCase teardown

3 Login and Verify User Data
    [Documentation]    This test case registers the user with the given parameters.
    ...    Dependency/Pre-req Test Case: 2 
    [Tags]    E2ETestCase

    Open Application    ${Url}    ${browser}
    Navigate to Login Page
    Login to the application    Username    Test1234
    Verify User Information    Username    Test    User    1234567890
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
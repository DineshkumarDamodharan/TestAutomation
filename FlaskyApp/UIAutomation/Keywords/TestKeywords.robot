*** Settings ***
Library    SeleniumLibrary
Resource    ../Resources/PageObjects/HomePage.robot
Resource    ../Resources/PageObjects/RegisterPage.robot
Resource    ../Resources/PageObjects/LoginPage.robot
Resource    ../Resources/PageObjects/UserInformationPage.robot
Resource    CommonKeywords.robot


*** keywords ***
Open Application
    [Arguments]    ${Url}    ${browser}
    [Documentation]    Purpose: Open the given ${Url} in given ${browser} and verify that the opened webpage contains all the texts and links
    ...    Arguments: ${Url} - Url of the test application, ${browser} - Tests will performed in the given browser

    Open Browser    ${Url}    ${browser}
    Maximize Browser Window
    Wait Until Page Contains    Demo app    timeout=30s
    Page Should Contain    index page
    @{homePageLoc}    Create List    ${link_Register}      ${link_Login}
    Page Should Contain Element List    ${homePageLoc}
    [Teardown]    Generic Keyword teardown    Open Application

Navigate to Registration page
    [Documentation]    This keywords navigates to Registration page by clicking Register link in navigation bar

    Click Element    ${link_Register}
    Wait Until Page Contains    Username    timeout=30s
    Page Should Contain    Register
    @{registrationPageLoc}    Create List    ${input_register_username}    ${input_register_password}    ${input_register_firstName}    ${input_register_lastName}    ${input_register_phoneNumber}    ${button_register}
    Page Should Contain Element List    @{registrationPageLoc}
    [Teardown]    Generic Keyword teardown    Navigate to Registration page

Register User
    [Arguments]    ${userName}    ${password}    ${firstName}    ${lastName}    ${phoneNumber}    ${expectError}=False    ${errorMessage}=None
    [Documentation]    This keyword inputs given parameters in the registration screen. If ${expectError}=True then keyword expects ${errorMessage}
    ...    And verifies whether page contains ${errorMessage}

    Input Text    ${input_register_username}    ${userName}
    Input Password    ${input_register_password}     ${password}
    Input Text     ${input_register_firstName}    ${firstName}
    Input Text    ${input_register_lastName}    ${lastName}
    Input Text    ${input_register_phoneNumber}    ${phoneNumber}
    Click Element    ${button_register}
    Run keyword if    ${expectError}    Wait Until Page Contains    ${errorMessage}    timeout=30s    ELSE    Wait Until Page Contains    Log In   timeout=30s    
    [Teardown]    Generic Keyword teardown    User Registration    

Navigate to Login page
    [Documentation]    This keyword navigates to Login page by clicking Login link in navigation bar

    Click Element    ${link_Login}
    Wait Until Page Contains    Username    timeout=30s
    Page Should Contain    Log In
    @{loginPageLoc}    Create List    ${input_login_username}    ${input_login_password}    ${button_login}
    Page Should Contain Element List    @{loginPageLoc}
    [Teardown]    Generic Keyword teardown    Navigate to Login page

Login to the Application
    [Arguments]    ${username}    ${password}    ${expectError}=False    ${errorMessage}=None
    [Documentation]    This keyword logins to the application with the given credentials. If ${expectError}=True then keyword expects ${errorMessage}
    ...    And verifies whether page contains ${errorMessage}

    Input Text    ${input_login_username}    ${username}
    Input Password    ${input_login_password}    ${password}
    Click Element    ${button_login}
    Run keyword if    ${expectError}    Page should Contain    ${errorMessage}    ELSE    Wait Until Page Contains    User Information    timeout=30s
    [Teardown]    Generic Keyword teardown    Login to the application

Verify User Information
    [Arguments]    ${username}    ${firstName}    ${lastName}    ${phoneNumber}
    [Documentation]    This keyword verfies the data displayed in the user information page against the arguments passed
    
    ${nav_username}    Get Text    ${text_userinfo_nav_username}
    Should be equal    ${username}    ${nav_username}
    ${actual_username}    Get Text    ${text_userInfo_username}
    Should be equal    ${username}    ${actual_username}
    ${actual_firstName}    Get Text    ${text_userInfo_firstName}
    Should be equal    ${firstName}    ${actual_firstName}
    ${actual_lastName}    Get Text    ${text_userInfo_lastName}
    Should be equal    ${lastName}    ${actual_lastName}
    ${actual_phoneNumber}    Get Text    ${text_userInfo_phoneNumber}
    Should be equal    ${phoneNumber}    ${actual_phoneNumber}
    [Teardown]    Generic Keyword teardown    Verify User Information

Logout Application
    [Documentation]    This keyword logsout from the application

    Click Element    ${link_logout}
    Wait until page contains    index page    timeout=30s
    [Teardown]    Generic Keyword teardown    Logout Application

Verify Mandatory fields in the page
    [Arguments]    ${page}
    [Documentation]    Argument ${page} = Register or Login. This keyword verifies the mandatory fields in the page accordung to the ${page}

    @{registrationPageFields}    CreateList    ${input_register_username}    ${input_register_password}    ${input_register_firstName}    ${input_register_lastName}    ${input_register_phoneNumber}
    @{loginPageFields}    CreateList    ${input_login_username}    ${input_login_password}
    Run keyword if    '${page}'=='Register'    Verify required in Forms    1    ${button_register}    Please fill out this field.        @{registrationPageFields}
    Run keyword if    '${page}'=='Login'    Verify required in Forms    0    ${button_login}    Please fill out this field.    @{loginPageFields}
    [Teardown]    Generic Keyword teardown    Verify mandatory fields in the page

Navigate to Index Page
    [Arguments]    ${loggedIn}=False    ${userName}=None
    
    Click Element    //a[text()='Demo app']
    Wait Until Page Contains    index page    timeout=30s
    Page should contain    Demo app
    Run keyword If    ${loggedIn}    Page should contain    ${userName}    ELSE    Page should contain element    ${link_register}
    Run keyword If    ${loggedIn}    Page should contain element    ${link_logout}    ELSE    Page should contain element    ${link_login}
    [Teardown]    Generic Keyword teardown    Navigate to Index Page


    
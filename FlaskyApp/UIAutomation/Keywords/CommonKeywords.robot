*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String

*** Keywords ***
Generic Keyword teardown
    [Arguments]    ${keyword_name}
    Log to console    Keyword Teardown: ${keyword_name}, Status: ${KEYWORD STATUS}
    Set Test Variable    ${keyword_name}

Generic Suite setup
    [Arguments]    ${screenshotDirectory}

    Log to Console    Setting up suite
    ${status}    Run Keyword And Return Status    Directory Should Exist    ${screenshotDirectory}
    Run Keyword If    ${status}    Remove Directory    ${screenshotDirectory}    recursive=True
    Create Directory    ${screenshotDirectory}
    Set Screenshot Directory    ${screenshotDirectory}

Generic TestCase teardown
    Log to console    Inside Test Case Teardown
    Run Keyword If Test Passed    Test Case Finally
    Run Keyword If Test Failed    Test Case Catch    ${keyword_name}

    
Page Should Contain Element list
    [Arguments]    @{elementList}
    [Documentation]    This Keyword verifies that page contains all the element locators passed in the list ${ElementList}.

    FOR    ${elementLoc}    IN    @{elementList}
        Page Should Contain Element    ${elementLoc}
    END

Test Case Finally
    Log to console    Sucessfull..............

Test Case Catch
    [Arguments]    ${keyword_name}
    Log to console    Looks like there is something wrong...........
    Log to console    Keyword ${keyword_name} failed........
    Capture Page Screenshot    ${TEST NAME}_${keyword_name}

Verify required in Forms
    [Arguments]    ${numberFields}    ${button}    ${message}    @{inputFields}
    [Documentation]    This keyword pass the Empty String to test each locator and check the validation ${message} on clicking the ${button}
    ...    ${numberFields} defines the number of NumberFields in the array and Last N(${numberFields}) elements in @{inputFields} considered as NumberFields

    ${listLength}    Get Length    ${inputFields}
    
    FOR    ${x}    IN RANGE    ${listLength}
        ${text}    Generate Random String    5
        ${number}    Generate random string    10    0123456789
        FOR    ${y}    IN RANGE    ${listLength}-${numberFields}
            Input Text    ${inputFields}[${y}]    ${text}
        END
        ${numberFields}    Run keyword If    ${numberFields} == 0    Set Variable    ${listLength}    ELSE    Set Variable    ${numberFields}
        FOR    ${z}    IN RANGE    ${listLength}-${numberFields}    ${listLength}
            Input Text    ${inputFields}[${z}]    ${number}
        END
        Clear Element Text    ${inputFields}[${x}]
        Click Element    ${button}
        Sleep    1s
        ${actual_message}    Get Element Attribute  ${inputFields}[${x}]    validationMessage
        Log    Test mandatory field for ${inputFields}[${x}]
        Should be equal       ${message}    ${actual_message}
    END


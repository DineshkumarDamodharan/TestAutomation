# TestAutomation
This repository is used have the code of my assignments of Flasky Demo App.

After deploying the app from https://github.com/sh-rdtaci/Flasky, Assign the correct URL in the tests.

## UI Automation
- Robot Framework is used for UI automation.
- Everytime need the fresh build to execute the test cases otherwise 'Username' already exists error will happen as username is not handled dynamicaly in the script
### Test Data
All the data such as browser, URL, Screenshot Directory are defined in /FlaskyApp/UIAutomation/Resources/TestData.robot
### Page Objects
Locators of each element used in the test cases mentioned in its respective *page.robot file under /FlaskyApp/UIAutomation/Resources/PageObjects/
### Keywords
All the keywords used in this test automation are defined in this folder /FlaskyApp/UIAutomation/Keywords/
#### CommonKeywords.robot
All the generic keywords are defined in this file. (These keywords are not application specific and can be used across applications)
#### TestKeywords.robot
All the keywords specific to this application are defined here 
### Test Cases
  - UI automation test cases are in the single robot file FlaskyAppTestCases.robot under /FlaskyApp/UIAutomation/TestCases/
  - In total there are 10 UI Automation test cases 
#### Tags
- SmokeTestCase - By executing this tag, test will navigate to all the pages accessible without login to verify whether the pages are loaded properly
- E2ETestCase - By executing this tag, we can test the positive end to end flow
- NegativeFlow - By executing this tag, we can test all the error messages displayed in the app
- knownIssue - The test case which has this tag will defenitely fail as we have known issue here. Details of the issue is mentioned in the test case description. This tag is introduced so that we can exclude this test case during execution to avoid build failure
#### Screenshots
Screenshots will be saved in the directory /Screenshots

Execution: Terminal/Cmd
```
robot #from the TestAutomation folder
```

*** Settings ***
Documentation    This script automate the use cases of Todoist Application
Library          AppiumLibrary
Library          Collections
Library          Selenium2Library
Library          HttpLibrary.HTTP
Library	         Collections
Library	         RequestsLibrary
Library          JSONLibrary
Library          BuiltIn
#Resource        file.py


*** Variables ***

${base_URL}                           https://api.todoist.com/rest
${Post_headers}                       Create Dictionary  Content-Type: application/json  X-Request-Id: $(uuidgen)  Authorization: 4d7946409e6df1c69585372679eeed02a3cd706a
${Post_body}                          Create dictionary  name="NewProject"
${Get_headers}                        Create Dictionary  Authorization:4d7946409e6df1c69585372679eeed02a3cd706a

${APPIUM_SERVER}                     http://localhost:4723/wd/hub
${Email}                             lekshmim90@gmail.com
${Password}                          123456@slatestudio
${Btn_welcome_continue_with_email}   id=com.todoist:id/btn_welcome_continue_with_email
${Email_exists_input}                id=com.todoist:id/email_exists_input
${Btn_continue_with_email}           id=com.todoist:id/btn_continue_with_email
${NavigationBarBackground}           id=android:id/navigationBarBackground
${Log_in_password}                   id=com.todoist:id/log_in_password
${btn_log_in}                        id=com.todoist:id/btn_log_in
${Menu_bar}                          accessibility id=Change the current view
${Projects_List}                     accessibility id=No tasks
${Add_task}                          com.todoist:id/fab
${Input_task_name}                   id=android:id/message
${Btn_add_task}                      id=android:id/button1


*** Keywords ***

Login into the Mobile Application

    ${androiddriver1}=    Open Application    ${APPIUM_SERVER}    platformName=Android      deviceName=emulator-5554
    ...    appPackage=com.todoist    newCommandTimeout=2500    appActivity=.activity.HomeActivity
    Set Suite Variable    ${androiddriver1}
    # id=com.todoist:id/btn_welcome_continue_with_email
    AppiumLibrary.Click Element   ${Btn_welcome_continue_with_email}
    # id=com.todoist:id/email_exists_input
    AppiumLibrary.Click Element    ${Email_exists_input}
    # Input Email text
    AppiumLibrary.Input Text       ${Email_exists_input}   ${Email}
    # id=com.todoist:id/btn_continue_with_email
    AppiumLibrary.Click Element    ${Btn_continue_with_email}
    # id=android:id/navigationBarBackground
     AppiumLibrary.wait until element is visible  ${NavigationBarBackground}
     AppiumLibrary.Click Element    ${NavigationBarBackground}
    # id=com.todoist:id/log_in_password
     AppiumLibrary.Input Text    ${Log_in_password}     ${Password}
    # id=com.todoist:id/btn_log_in
     AppiumLibrary.Click Element    ${btn_log_in}
     sleep   10s
# Challenge1 : Took time to Bypass New version Update alert
Create test project via API
    create session  Post_New_Project_details   ${base_URL} headers=${Post_headers}  cookies=None
    log to console  ${Post_headers}
    ${response}=  RequestsLibrary.Post Request  alias=Post_New_Project_details  uri=${base_URL}/v1/projects/ data=${Post_body} headers=${Post_headers}  params=None
    log to console   ${response.status_code}
    log to console    ${response.content}
# Challenge2 : Took time to resolve the script errors(Positional Arguments,Library support  etc)
Verify on mobile that project is created
    # accessibility id=Change the current view
    AppiumLibrary.Click Element    ${Menu_bar}
    # accessibility id=No tasks
    AppiumLibrary.Click Element    ${Projects_List}
    #Assertion: Check the Project has been created succesfully
    AppiumLibrary.page should contain text   NewProject
    Close application
# Challenge3 : Took time to resolve Script errors
Create Task via mobile application in your test project
      # Id add task
      AppiumLibrary.Click Element  ${Add_task}
      # id=android:id/message
     AppiumLibrary.Click Element   ${Input_task_name}
     AppiumLibrary.Input Text    ${Input_task_name}     Test_newtask
    # id=android:id/button1
     AppiumLibrary.Click Element    ${Btn_add_task}
     Go Back

Verify that task created succesfully through API

    create session  Get_Project_details   ${base_URL} headers=${Get_headers}  cookies=None
    log to console  ${Get_headers}
    ${response}=  RequestsLibrary.Get Request  alias=Get_Project_details  uri=${base_URL}/v1/tasks/  headers=${Get_headers}  params="2216798303"
    log to console   ${response.status_code}
    log to console  ${response.content}
    #Assertion:Checking Json content has matching value for new task name,otherwise Test Fails
    ${response.content}  should contain match  Test_newtask
# Challenge4 : Took time to resolve Script errors on SSL
Open test Project

    # Go to the Mobile app


Create Test task
   # Go to the test complete test task


Complete test task
   # Complete the test task by clicking


Mobile:Verify that test task apperas in your project
   # Open mobile app and verify test case

Reopen test task via Api
*** Test Cases ***
Test1:Create Project
    Create test project via API
    Login into the Mobile Application
    Verify on mobile that project is created

Test2:Create Task via Mobile app
   Login into the Mobile Application
   Create Task via mobile application in your test project
   Verify that task created succesfully through API

#Test3:Reopen Task (InComplete)
    Login into the Mobile Application
    Open test Project
    Create Test task
    Complete test task
    Reopen test task via Api
    Mobile:Verify that test task apperas in your project



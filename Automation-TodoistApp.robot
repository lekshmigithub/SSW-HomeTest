*** Settings ***
Documentation    This script automate the use cases of Todoist Application
Library          AppiumLibrary
Library          Collections
#Library          Selenium2Library
Library          HttpLibrary.HTTP
Library	         Collections
Library	         RequestsLibrary
Library          JSONLibrary
Library          BuiltIn
Library          String
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
${Xpath_Expand_Project}              xpath=(//android.widget.ImageButton[@content-desc="Add"])[1]
${Add_Project}                       xpath=(//android.widget.ImageButton[@content-desc="Add"])[1]
${Input_project_name}                id=com.todoist:id/name
${Btn_done}                          accessibility id=Done
${Choose_task}                       id=com.todoist:id/item
${Complete_task}                     accessibility id=Complete


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
#    Create a project with Post request
    create session  Post_New_Project_details   ${base_URL} headers=${post_headers}  cookies=None
    log to console  ${post_headers}
    ${data}=    Create Dictionary  {"name"="New projectrobot"}
    ${response}=  Post Request   Post_New_Project_details   ${base_URL}rest/v1/projects  data=${data}  headers=${post_headers}
    log to console  ${response.status_code}
    Should Be Equal As Strings  ${response.status_code}  200
    log to console  ${response.content}
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
    # accessibility id=Change the current view
      Click Element    ${Menu_bar}
    # xpath=(//android.widget.ImageButton[@content-desc="Add"])[1]
      Click Element    ${Add_Project}
# id=com.todoist:id/name
      Click Element    ${Input_project_name}
      Input Text       ${Input_project_name}    Test Project
# accessibility id=Done
      Click Element    ${Btn_done}


Create Test task
   # Go to the test complete test task

   # accessibility id=Change the current view
     Click Element    ${Menu_bar}
   # xpath=(//android.widget.ImageView[@content-desc="Expand/collapse"])[1] Projects expand button
     Click Element    ${Xpath_Expand_Project}
   # xpath=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.support.v4.widget.DrawerLayout/android.widget.FrameLayout/android.support.v7.widget.RecyclerView/android.widget.RelativeLayout[7]
     open test project
   # id=com.todoist:id/fab -->Add a Test Task
     Click Element    ${Add_task}
     # id=android:id/message
     Click Element    ${Input_task_name}
     Input Text      ${Input_task_name}    Test Task
    # id=android:id/button1
     Click Element    ${Btn_add_task}
     Click Element    ${Btn_add_task}     #Task will be succesfully added

Complete test task
   # Complete the test task by clicking
     # id=com.todoist:id/item
      Click Element    ${Choose_task}
# accessibility id=Complete
      Click Element    ${Complete_task}

Reopen test task via Api

    create session  ReopenTask   ${base_URL} headers=${Get_headers}  cookies=None
    ${response}=  Post Request   Post_New_Project_details   ${base_URL}/rest/v1/tasks/3386989057/reopen   headers=${post_headers}
    log to console  ${response.status_code}
    Should Be Equal As Strings  ${response.status_code}  200
    log to console  ${response.content}

Mobile:Verify that test task appears in your projects
    #Verification of test task in test project
    Login into the Mobile Application
    # accessibility id=Change the current view
     Click Element    ${Menu_bar}
   # xpath=(//android.widget.ImageView[@content-desc="Expand/collapse"])[1] Projects expand button
     Click Element    ${Xpath_Expand_Project}
   # xpath=/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.support.v4.widget.DrawerLayout/android.widget.FrameLayout/android.support.v7.widget.RecyclerView/android.widget.RelativeLayout[7]
     open test project
     text should be visible  test task
# Test case will fail if the page doesnot contain reopened task name

*** Test Cases ***
Test1:Create Project
    Create test project via API
    Login into the Mobile Application
    Verify on mobile that project is created

Test2:Create Task via Mobile app
   Login into the Mobile Application
   Create Task via mobile application in your test project
   Verify that task created succesfully through API

Test3:Reopen Task (InComplete)
    Login into the Mobile Application
    Open test Project
    Create Test task
    Complete test task
    Reopen test task via Api
    Mobile:Verify that test task appears in your projects



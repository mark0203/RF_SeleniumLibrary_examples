** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary
Library    DateTime     # see birthday and age part
Library    OperatingSystem   # needed to create a file
Suite Setup    Setup and navigation   #see keywords
Suite Teardown    Close All Browsers    # Will close all browsers at the end of all tests

*** Variables ***
${file_name}    robotframework_example.txt

*** Keywords ***
Setup and navigation
    Open Browser    http://a.testaddressbook.com   chrome
    Maximize Browser Window 

*** Test Cases ***
Scenario: Google Example
    # Authenticate and Navigate to the Form 
    Wait Until Page Contains Element  id:sign-in
    Click Element  id:sign-in
    # SeleniumLibrary has a limitation that make it more difficult than needed
    # There are some basic attributes you can use, for the rest you're stuck to CSS/XPATH
    # http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Locating%20elements
    # For this element I could use the ID locator, but I want to do a fair compare with Watir
    Wait Until Page Contains Element  css: input[data-test="email"] 
    Input Text  css: input[data-test="email"]    watir_example@example.com
    Input Password  css: input[data-test="password"]  password
    Submit Form
    Wait Until Page Contains Element  css: a[data-test="addresses"]
    Click Link  Addresses   #you can use full text of a link (not preferred solution but often used to it seems)
    Wait Until Page Contains Element   css: a[data-test="create"]
    Click Link  /addresses/new
    
    # This uses the Faker Library to give us Random Data.
    # Read more about FakerLibrary here: https://pypi.org/project/robotframework-faker/

    Wait Until Page Contains Element  id:address_first_name
    ${first_name}=  First Name
    Input Text  id:address_first_name  ${first_name} 
    ${last_name}=  Last Name
    Input Text  id:address_last_name  ${last_name}
    ${street_address}=  Street Address
    Input Text  id:address_street_address  ${street_address}
    ${secondary_address}=  Secondary Address
    Input Text  id:address_secondary_address  ${secondary_address}
    ${city}=  City
    Input Text  id:address_city  ${city}

    # select list elements by 'index', 'label' or 'value' locators
    ${state_abbr}=  State Abbr 
    Select From List By Value  id:address_state  ${state_abbr}

    ${postcode}=  Postcode
    Input Text  id:address_zip_code  ${postcode} 

    # radio buttons can be found by name and selected with 'id' or 'value' locators
    Select Radio Button  address[country]  canada

    # Date field elements need to be used as normal input field, no special treathment here
    # We actually need to use 'Date Time' instead of 'Date' to substract the years below
    ${birthday}=  Date Time
    Input Text  id:address_birthday  ${birthday.month}${birthday.day}${birthday.year}

    ${current_date}=  Get Current Date  result_format=datetime 
    ${age}=  Evaluate  ${current_date.year}-${birthday.year}
    Input Text  id:address_age  ${age}

    ${url}=  Url
    Input Text  id:address_website  ${url}

    # Create a file and add the path to the upload files element
    Create File  ${EXECDIR}/${file_name}    #for filename, see variables at the top
    Input Text  id:address_picture  ${EXECDIR}/${filename}

    # Checkboxes This is not as advanced as Watir's way of selecting checkboxes
    # I have not found a way to do this in a similar way.
    # Below I show you two ways to click on this element with Robotframework.
    # The first one is to click on the label element
    Click Element  xpath: //label[contains(text(),'Dancing')]
    # The second option is to click on the checkbox, you you can only use the locators of the checkbox, not the one from the label
    # This will only select the checkbox is it has not been selected yet
    Select Checkbox  css: #address_interest_dance

    Input Text  id:address_note  See, filling out a form with Robotframework is not as easy as Watir!
    # Click button Match based on id, name or value.
    Click Button  name:commit

    Sleep  3
  


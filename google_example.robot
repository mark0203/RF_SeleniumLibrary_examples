*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Scenario: Google Example
    # Open the browser object
    Open Browser    http://www.google.com    chrome
    Maximize Browser Window  

    # Enter a Search query
    Input Text  name:q  allesisvoormark.nl
    Submit Form

    # Click on the first searchlink
    Click Element  css: #search a

    Sleep   2
    Log Title  

    Close All Browsers    
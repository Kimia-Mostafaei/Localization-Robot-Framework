*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${LOGIN URL}                https://135.121.146.249
${BROWSER}                  chrome
${CHROMEDRIVER_PATH}        C:/bin/chromedriver.exe
${prefix_for_test}          fr_

*** Keywords ***
Open Browser to NSP UI
    Open Browser    ${LOGIN URL}    ${BROWSER}    executable_path=${CHROMEDRIVER_PATH}
    ...    options=add_argument("--ignore-certificate-errors");add_argument("--start-maximized");add_argument("--disable-gpu")
    Title Should Be    Log in to Nokia NSP

Input Username
    [Arguments]    ${username}
    Wait Until Element Is Visible    id=username    timeout=10s
    Input Text    username    ${username}

Input Password
    [Arguments]    ${password}
    Wait Until Element Is Visible    id=password    timeout=10s
    Input Text    password    ${password}

Submit Credentials
    Wait Until Element Is Visible    name=login    timeout=10s
    Click Button    login
    Wait Until Page Contains    Dashboard    timeout=20s  # Adjust based on the expected landing page

Hover Over Interactive Elements
    [Documentation]    Loops through interactive elements and hovers over each one
    ${buttons}=    Get WebElements    xpath=//button | //a[@role='button'] | //div[@role='button'] | //*[contains(@class, 'interactive-element-class')] | //div[@data-component-id='nokia-react-components-chipwithdropdown-label']

    Log     ${buttons}
    # Log how many interactive elements were found
    ${count}=    Get Length    ${buttons}
    Log    Found ${count} interactive elements to hover over

    # Loop through each element and perform the hover action
    FOR    ${element}    IN    @{buttons}
        # Check if the element is visible
        ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        ${location}=    Run Keyword And Return Status    Get Element Attribute    ${element}    location
        ${size}=    Run Keyword And Return Status    Get Element Attribute    ${element}    size

        # Use Set Variable to create flags
        ${has_location}=    Set Variable If    '${location}' != 'None'    True    False
        ${has_size}=    Set Variable If    '${size}' != 'None'    True    False

        # Ensure the variable conditions are evaluated correctly
        IF    ${is_visible}
           # IF    ${has_location}
        #        IF    ${has_size}
                    Scroll Element Into View    ${element}
                    Log    Hovering over element
                    Mouse Over    ${element}
                    Sleep    0.5s
                #ELSE
                 #   Log    Skipping element: No size
              #  END
            #ELSE
            #    Log    Skipping element: No location
          #  END
        ELSE
            Log    Skipping element: Invisible
        END
    END

Check Hover Text
    [Arguments]    ${textValue}    ${element}
    Mouse Over    ${element}
    Sleep    1s
    Page Should Contain    ${textValue}

*** Test Cases ***
Test NSP Login and Hover
    Open Browser to NSP UI
    Input Username    admin
    Input Password    NokiaNsp1!
    Submit Credentials
    Sleep    5s

    # Now hover over all interactive elements
    Hover Over Interactive Elements

Close Browser
    Sleep   2s
    Close Browser

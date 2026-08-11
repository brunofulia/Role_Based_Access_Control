*** Settings ***
Library         Browser
Variables       ../config/env_config.py

*** Keywords ***
Login To OrangeHRM As
    [Arguments]    ${role}
    
    IF    ${MOCK_ENVIRONMENT}
        Log    [MOCK MODE] Skipping real browser login for ${role}
        RETURN
    END

    ${username}=   Set Variable    ${CREDENTIALS}[${role}][username]
    ${password}=   Set Variable    ${CREDENTIALS}[${role}][password]
    
    New Browser    headless=True
    New Context    viewport={'width': 1280, 'height': 720}
    New Page       ${LOGIN_URL}
    
    Fill Text      xpath=//input[@name='username']    ${username}
    Fill Text      xpath=//input[@name='password']    ${password}
    Click          xpath=//button[@type='submit']
    
    ${status}    ${error}=    Run Keyword And Ignore Error    Wait For Elements State    css=.oxd-topbar-header-title    visible    timeout=10s
    Run Keyword If    '${status}' == 'FAIL'    Fail    Authentication Failed: Could not reach the dashboard for role '${role}'. Verify credentials in env_config.py.

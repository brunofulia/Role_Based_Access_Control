*** Settings ***
Documentation     Data-driven authorization suite across API and UI layers.
Library           DataDriver    file=../../data/roles_permissions.csv    separator=;
Resource          ../../resources/api_authorization_keywords.resource
Resource          ../../resources/ui_authorization_keywords.resource

Test Template     Validate Role Based Access Control Policy

*** Test Cases ***
Validate Policy For ${role} Accessing ${resource} Via ${layer}
    [Tags]    DataDriven

*** Keywords ***
Validate Role Based Access Control Policy
    [Arguments]    ${role}    ${resource}    ${action}    ${expected_status}    ${layer}    ${security_rule}
    
    IF    '${layer}' == 'api'
        Verify API Authorization    ${role}    ${resource}    ${action}    ${expected_status}    ${security_rule}
    ELSE IF    '${layer}' == 'ui'
        Verify UI Authorization     ${role}    ${resource}    ${action}    ${expected_status}    ${security_rule}
    ELSE
        Fail    Configuration error: Layer '${layer}' is not supported.
    END

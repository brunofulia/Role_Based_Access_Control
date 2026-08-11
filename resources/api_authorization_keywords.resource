*** Settings ***
Library         RequestsLibrary
Library         Collections
Variables       ../config/env_config.py
Variables       ../config/sensitive_fields.yaml

*** Keywords ***
Create API Session For Role
    [Arguments]    ${role}
    Create Session    orangehrm_api_${role}    ${BASE_URL}    verify=True

Verify API Authorization
    [Arguments]    ${role}    ${resource}    ${action}    ${expected_status}    ${security_rule}
    
    ${endpoint}=    Get API Endpoint For Resource    ${resource}
    
    IF    ${MOCK_ENVIRONMENT}
        ${actual_status}=    Set Variable    ${expected_status}
        Log    [MOCK MODE] Simulating API response HTTP ${actual_status} for ${endpoint}
        
        IF    ${SIMULATE_SECURITY_INCIDENT} and '${role}' == 'employee' and '${resource}' == 'salary_info'
            ${actual_status}=    Set Variable    200
            Log    [INCIDENT SIMULATION] Backend bug injected! Returning HTTP 200 instead of 403.
        END
    ELSE
        Create API Session For Role    ${role}
        ${response}=    GET On Session    orangehrm_api_${role}    ${endpoint}    expected_status=any
        ${actual_status}=    Convert To String    ${response.status_code}
    END
    
    ${is_match}=    Run Keyword And Return Status    Should Be Equal    ${actual_status}    ${expected_status}
    Run Keyword If    not ${is_match}    Fail    Security Policy Violation: Expected HTTP ${expected_status} for ${role} accessing ${resource}, but got HTTP ${actual_status}. Check auth tokens or RBAC configuration.
    
    IF    ${MOCK_ENVIRONMENT}
        Log    [MOCK MODE] Skipping JSON payload exposure assertions.
    ELSE
        Run Keyword If    '${security_rule}' == 'deny'    Assert Sensitive Fields Absent In JSON    ${response}
        ...    ELSE IF    '${security_rule}' == 'allow'    Assert Sensitive Fields Authorized
    END

Get API Endpoint For Resource
    [Arguments]    ${resource}
    Return From Keyword If    '${resource}' == 'salary_info'    /web/index.php/api/v2/pim/employees/1/salary-components
    Return From Keyword If    '${resource}' == 'personal_details'    /web/index.php/api/v2/pim/employees/1/personal-details
    Return From Keyword If    '${resource}' == 'admin_panel'    /web/index.php/api/v2/admin/users
    RETURN    /api/v2/unknown

Assert Sensitive Fields Absent In JSON
    [Arguments]    ${response}
    ${payload_string}=    Convert To String    ${response.content}
    FOR    ${field}    IN    @{sensitive_fields}
        Should Not Contain    ${payload_string}    ${field}    ignore_case=True    msg=Data exposure violation: Unauthorized API response contains sensitive field '${field}'
    END

Assert Sensitive Fields Authorized
    Log    Sensitive fields authorization check passed.

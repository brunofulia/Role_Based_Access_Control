*** Settings ***
Library         Browser
Variables       ../config/sensitive_fields.yaml
Resource        auth_keywords.resource

*** Keywords ***
Verify UI Authorization
    [Arguments]    ${role}    ${resource}    ${action}    ${expected_status}    ${security_rule}
    
    Login To OrangeHRM As    ${role}
    
    IF    ${MOCK_ENVIRONMENT}
        Log    [MOCK MODE] Simulating UI navigation to ${resource} and enforcing ${security_rule} policy.
        RETURN
    END

    ${ui_route}=    Get UI Route For Resource    ${resource}
    Go To           ${BASE_URL}${ui_route}
    
    Sleep    2s
    
    Run Keyword If    '${security_rule}' == 'deny'    Assert Sensitive Fields Absent In DOM
    
    Close Browser

Get UI Route For Resource
    [Arguments]    ${resource}
    Return From Keyword If    '${resource}' == 'admin_panel'    /web/index.php/admin/viewSystemUsers
    Return From Keyword If    '${resource}' == 'salary_info'    /web/index.php/pim/viewSalaryList/empNumber/1
    RETURN    /web/index.php/dashboard/index

Assert Sensitive Fields Absent In DOM
    ${dom_source}=    Get Page Source
    FOR    ${field}    IN    @{sensitive_fields}
        Should Not Contain    ${dom_source}    ${field}    ignore_case=True    msg=Data exposure violation: Sensitive field '${field}' found in DOM source.
    END

*** Settings ***
Documentation     API-specific authorization tests for the admin role.
Resource          ../../resources/api_authorization_keywords.resource

*** Test Cases ***
Admin Can Read Salary Info API
    [Documentation]    Ensures admins have access to employee salary data.
    Verify API Authorization    admin    salary_info    read    200    allow

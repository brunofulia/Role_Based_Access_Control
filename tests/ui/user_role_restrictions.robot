*** Settings ***
Documentation     UI-specific boundary control and data exposure tests.
Resource          ../../resources/ui_authorization_keywords.resource

*** Test Cases ***
Admin Should Be Able To Access Admin Panel
    [Documentation]    Verifies that the admin role is authorized to view the admin panel without data exposure violations.
    Verify UI Authorization    admin    admin_panel    view    200    allow

Employee Should Be Denied Access To Admin Panel
    [Documentation]    Verifies that standard employees are denied access to the admin panel and no sensitive data is exposed.
    Verify UI Authorization    employee    admin_panel    view    403    deny

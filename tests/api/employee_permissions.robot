*** Settings ***
Documentation     API-specific authorization tests for the employee role.
Resource          ../../resources/api_authorization_keywords.resource

*** Test Cases ***
Employee Cannot Read Salary Info API
    [Documentation]    Ensures employees cannot access sensitive salary component APIs.
    Verify API Authorization    employee    salary_info    read    403    deny

Employee Can Read Own Personal Details API
    [Documentation]    Ensures employees can access their own base profile without restriction.
    Verify API Authorization    employee    personal_details    read    200    allow

# CI/CD Governance: Controlled Authorization Failure Simulation
# 
# Employee Should Not Read Executive Data (Simulated Regression)
#    [Documentation]    Demonstrates a policy violation detection for the CI/CD Security Gate.
#    ...                By expecting a 200 when a 403 should be enforced, the framework will fail
#    ...                and trigger a pipeline block. Uncomment to simulate security regression.
#    Verify API Authorization    employee    salary_info    read    200    allow

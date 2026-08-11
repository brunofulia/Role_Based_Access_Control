BASE_URL = "https://opensource-demo.orangehrmlive.com"
LOGIN_URL = f"{BASE_URL}/web/index.php/auth/login"

# Portfolio Demo Configuration
MOCK_ENVIRONMENT = True
SIMULATE_SECURITY_INCIDENT = False

CREDENTIALS = {
    "admin": {
        "username": "Admin",
        "password": "admin123"
    },
    "employee": {
        "username": "employee",
        "password": "employee123"
    }
}

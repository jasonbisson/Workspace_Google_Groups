## Purpose 

This repository will provide a method to create multiple Google Groups to force a conflicting account for former employees who created personal Google Identities with their corporate email address. The benefit of creating a Google group rather than a Google user identity is the following:  

1. Creating an identity for former employee will create policy issues for most organizations.
1. Avoids using a license (Cloud Identity or Workspace) for a former employee.

If you have no idea what a conflict account is the best guide is found [here](https://www.goldyarora.com/google-conflicting-accounts-guide/).

## Prerequisites

### Install Google Client Library
```
pip install --upgrade google-api-python-client google-auth-oauthlib
```
### Create Oauth Client secret

This [document](https://googleapis.github.io/google-api-python-client/docs/oauth.html) describes OAuth 2.0, when to use it, how to acquire client IDs, and how to use it with the Google APIs Client Library for Python.

### Create a data file with the list of groups 
```
teraminated_employee@example.com,Group to force conflict account for terminated employee
```
## Run Script
```
python3 create_google_groups.py
```



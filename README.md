## Group Management Utility for Conflicting Accounts 🛡️

This repository provides a method to **bulk-manage Google Groups** with the primary goal of enforcing a **conflicting account** state for former employees who created personal Google Identities using their corporate email address.

This strategy offers significant benefits over maintaining a user license:

1.  **Policy Compliance**: Avoids the internal policy issues often associated with maintaining an active user identity for a former employee.
2.  **Cost Efficiency**: Eliminates the need to consume a paid license (Google Workspace or Cloud Identity) for a non-active user.

If you are unfamiliar with what a conflicting account is, the best guide is found [here](https://www.goldyarora.com/google-conflicting-accounts-guide/).

---

## Prerequisites

### 1. Enable Cloud Identity API
The script uses the `gcloud identity groups` commands, which rely on the Cloud Identity API. Enable it using the following command:

```
gcloud services enable cloudidentity.googleapis.com --project <project_id_for_execution>
```
*Note: Replace `<project_id_for_execution>` with the project you are running the script from.*

### 2. Set up Application Default Credentials (ADC)
The script needs proper authentication to run the `gcloud` commands. This [document](https://cloud.google.com/docs/authentication/provide-credentials-adc) provides options on how to authenticate the execution environment (e.g., as a human user or a service account).

### 3. Authorization for Identity (IAM Permissions)
The service account or user executing the script requires the following minimum permissions in the Identity and Access Management (IAM) policy at the organization level:

| Operation | Required Permissions |
| :--- | :--- |
| **CREATE** | `cloudidentity.groups.update` |
| **CREATE** | `cloudidentity.membership.update` |
| **DELETE** | `cloudidentity.groups.update` |

### 4. Create a Data File
The script requires a data file named **`former_employees.csv`** in the same directory. This file must contain the list of former employee corporate email addresses, with one email per line:

# former_employees.csv example
user.one@example.com
user.two@example.com

### 5. Run script

The script uses long-form flags (`--organization-id`, `--action`) for clear, order-independent execution.

| Action | Command | Description |
| :--- | :--- | :--- |
| **CREATE** | `./bulk_group_update.sh --organization-id 123456789012 --action create` | Creates an empty Google Group for each email in the CSV file. |
| **DELETE** | `./bulk_group_update.sh --organization-id 123456789012 --action delete` | Deletes the Google Group for each email in the CSV file. |


## Review Audit Logging

The operations are recorded in Cloud Audit Logs. You can monitor the success or failure of the bulk operations by searching at the **Organizational level** with the following log filter:

```
protoPayload.authorizationInfo.permission="cloudidentity.groups.update" OR protoPayload.authorizationInfo.permission="cloudidentity.membership.update"
```



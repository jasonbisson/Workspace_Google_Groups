# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import print_function
import csv
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/admin.directory.group']

def main():
    creds = None
    flow = InstalledAppFlow.from_client_secrets_file('client_secret.json', SCOPES)
    creds = flow.run_local_server(port=0)
    service = build('admin', 'directory_v1', credentials=creds)
    
    with open('groups.csv', "r") as csv_file:
        csv_reader = csv.reader(csv_file)
        for row in csv_reader:
            group = { "name": row[0], "email": row[0], "adminCreated": True, "description": row[1]}
            results = service.groups().insert(body=group).execute()
            print(results["email"])

if __name__ == '__main__':
    main()
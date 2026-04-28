**Exchange ECP OU Picker Blank Issue - Automated Fix**

**Problem:**
When linking mailboxes or creating users in Exchange Control Panel (ECP), the Organizational Unit (OU) picker displays blank or shows "There are no items to show in this view" when the Active Directory environment contains more than 500 OUs. This occurs because Exchange Server has a hardcoded 500 OU display limit in the ECP web.config file.

**Solution:**
This PowerShell script automatically checks the ECP web.config file for the GetListDefaultResultSize key, adds it if missing, updates the value if too low, and restarts the MSExchangeECPAppPool to apply changes. A timestamped backup is created before any modifications.

**Why This Is Needed:**
Exchange cumulative updates (CUs) overwrite the web.config file and remove custom settings. The included scheduled task runs daily to detect and restore the configuration automatically, eliminating the need for manual intervention after each CU installation.

**Deployment:**
Works on Exchange Server 2013, 2016, 2019, and 2025

Must be deployed to all Exchange servers with the Mailbox role, as ECP requests can be redirected to any server in the environment

Runs as SYSTEM account with highest privileges

Creates automatic backups before making changes

Safe for production use - only modifies the specific GetListDefaultResultSize key while preserving all other web.config settings

# EC2-UpdateRoute53
Updates A route53 record upon EC2 Startup

Paste the below code snippet into InstanceSettings - View/Change User Data
Update the variables at the top of updateRoute53.sh to there correpsonding values for your use case.
Copy the contents of the shell script and replace the "PASTE HERE" line inside View/Change User Data

Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

```
--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
 ===============================PASTE HERE============================
--//
```
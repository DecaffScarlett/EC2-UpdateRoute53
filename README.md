# EC2-UpdateRoute53

EC2-UpdateRoute53 is a simple project that allows an EC2 instance to update a specific Route53 record set to point to the instances container on every startup. This stops the need of an elastic ip if a Route53 Domain is owned. Which can save money due the cost of an Elastic IP if the instance is not currently running.

## How to install

### Step 1

Ensure that the awscli is installed on the Instance.

### Step 2

Create a new EC2 IAM role and give it the permission **AmazonRoute53FullAccess**

### Step 3

Under the instances actions select InstanceSettings-Attach/Replace IAM Role and attach the IAM role made above to the instance.

### Step 4

Under the instances actions select InstanceSettings-View/Change User Data and paste the below code snippet into the box that appears.

### Step 5

Update the variables at the top of the bash section in the code you pasted in the step above. The 2 variables that need changing are.

- HOSTED_ZONE_ID - This is the unique id for the domain
- RECORD_SET_NAME - This is the URL

```
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

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
HOSTED_ZONE_ID=REPLACE THIS
RECORD_SET_NAME=example.url.co.uk

IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

TMPFILE=$(mktemp /tmp/temporary-file.XXXXXXXX)
cat > ${TMPFILE} << EOF
        {
          "Comment": "Updating Value in route53 recordset",
          "Changes": [
            {
              "Action": "UPSERT",
              "ResourceRecordSet": {
                "Name": "$RECORD_SET_NAME",
                "Type": "A",
                "TTL":60,
                "ResourceRecords": [
                  {
                    "Value": "$IP"
                  }
                ]
              }
            }
          ]
        }
EOF

aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://"$TMPFILE"

rm $TMPFILE
--//
```

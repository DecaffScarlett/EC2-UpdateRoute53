HOSTED_ZONE_ID=REPLACE
RECORD_SET_NAME=REPLACE

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

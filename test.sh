echo '[ { "PrivateIpAddress": "192.168.0.1" }, { "PrivateIpAddress": "192.168.0.2" }, { "PrivateIpAddress": "192.168.0.3" } ]' > temp.json

EC2_PARSED=($(jq .[].PrivateIpAddress temp.json))

EC2_IP=${EC2_PARSED[$RANDOM % ${#EC2_PARSED[@]} ]}

rm -f temp.json

echo ${EC2_IP}

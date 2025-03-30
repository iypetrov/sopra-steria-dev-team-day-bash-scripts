#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "3 args are required: notification title, notification description, notification status"
    exit 1
fi

if [[ "$3" != "create" && "$3" != "destroy" ]]; then
    echo "arg 3 is notification status, allowed values are create/destroy"
    exit 4
fi

TITLE=$1
DESCRIPTION=$2
STATUS=$3
DISCORD_DEPLOYMENTS_WEBHOOK_URL=""

if [[ "${STATUS}" = "create" ]]; then
    COLOR=3066993 # Green
    ICON="🚀"
elif [[ "${STATUS}" = "destroy" ]]; then
    COLOR=15158332 # Red
    ICON="🚨"
fi

JSON_PAYLOAD=$(cat <<EOF
{
  "embeds": [
    {
      "title": "${TITLE}",
      "description": "${DESCRIPTION}",
      "color": ${COLOR},
      "footer": {"text":"${ICON}"},
      "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    }
  ]
}
EOF
)

response=$(curl -X POST -s -o /dev/null -w "%{http_code}" -H "Content-Type: application/json" -d "${JSON_PAYLOAD}" "${DISCORD_DEPLOYMENTS_WEBHOOK_URL}")
if [[ "$response" != "204" ]]; then
  echo "Failed to send notification. HTTP response: $response"
  exit 1
else
  echo "Notification sent successfully."
fi

#!/bin/bash

set -e

PR_NUMBER=$(jq -r ".issue.number" "$GITHUB_EVENT_PATH")
REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

echo "Collecting information about PR #$PR_NUMBER of $REPO_FULLNAME..."

if [[ -z "$TOKEN" ]]; then
	echo "Set the TOKEN env variable."
	exit 1
fi

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $TOKEN"

user_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/user")
user_id=$(echo ${user_resp} | jq '.id')

pr_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" \
          "${URI}/repos/$REPO_FULLNAME/pulls/$PR_NUMBER/reviews")

times_approved_by_user=$(echo ${pr_resp} | jq  "[.[] | select(.user.id == $user_id)] | length")

if (($times_approved_by_user == 0)); then
  curl -X POST -s -H "${AUTH_HEADER}" -H "${API_HEADER}" \
    -d "{\"event\":\"APPROVE\"}" \
    "${URI}/repos/$REPO_FULLNAME/pulls/$PR_NUMBER/reviews" &>/dev/null
  echo "Approved"
else
  echo "Already approved"
fi

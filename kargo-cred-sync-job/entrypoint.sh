#!/bin/bash



kargo login https://kargo.akpdemoapps.link/ --admin --password $KARGO_PASSWORD

project=$KARGO_PROJECT
echo -e "\n\nPublishing git credentials for project: $project"


cat <<EOF > ghcr.yaml
apiVersion: v1
kind: Secret
metadata:
  name: ghcr-token
  namespace: $project
  labels:
    kargo.akuity.io/cred-type: image
stringData:
  username: ${GITHUB_USER}
  password: ${GITHUB_PAT}
  repoURL: ghcr.io/akuity
EOF

kargo apply -f ghcr.yaml

cat <<EOF > repo.yaml
apiVersion: v1
kind: Secret
metadata:
  name: repo-token
  namespace: $project
  labels:
    kargo.akuity.io/cred-type: git
stringData:
  username: ${GITHUB_USER}
  password: ${GITHUB_PAT}
  repoURL: https://github.com/akuity/
EOF

kargo apply -f repo.yaml

cat <<EOF > slack.yaml
apiVersion: v1
kind: Secret
metadata:
  name: slack-token
  namespace: $project
  labels:
    kargo.akuity.io/cred-type: generic
stringData:
  apiKey: $SLACK_TOKEN
EOF

kargo apply -f slack.yaml
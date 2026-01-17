#!/bin/bash



kargo login https://kargo.akpdemoapps.link/ --admin --password $KARGO_PASSWORD

project=$KARGO_PROJECT
echo -e "\n\nPublishing git credentials for project: $project"

# Get repo URL for project. (the funk items[]? // allows list and single item support)
repo_urls=$(kargo get warehouses -p $project -o json | jq -r '.items[]?.spec // .spec | .subscriptions[] | select(.git !=null).git.repoURL')
image_url=$(kargo get warehouses -p $project -o json | jq -r '.items[]?.spec // .spec | .subscriptions[] | select(.image !=null).image.repoURL')

let i=0
for repo_url in $repo_urls; do
    echo -e "\tUsing repo URL: $repo_url"
    #echo -e "\tUsing GH PAT var name: $gITHUB_pat_var_name"
    # Publish git credentials to Kargo secrets
    kargo create credentials github-creds${i} \
    --project $project --git \
    --username ${GITHUB_USER} --password ${GITHUB_PAT} \
    --repo-url $repo_url 2>/dev/null || \
    kargo update credentials github-creds${i} \
    --project $project --git \
    --username ${GITHUB_USER} --password ${GITHUB_PAT} \
    --repo-url $repo_url
    let i=i+1
done

if [[ "$image_url" =~ "ghcr.io/akuity" ]]; then
    echo -e "\t adding creds for image URL ${image_url}"
    kargo create credentials ghcr-creds \
    --project $project --image \
    --username ${GITHUB_USER} --password ${GITHUB_PAT} \
    --repo-url $image_url 2>/dev/null || \
    kargo update credentials ghcr-creds \
    --project $project --image \
    --username ${GITHUB_USER} --password ${GITHUB_PAT} \
    --repo-url $image_url
else
    echo -e "\t skipping image creds for image URL ${image_url} because not ghcr.io/akuity"
fi


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
#!/usr/bin/env bash

# this script requires `gcloud` and `jq` to be present
[ -x "gcloud" ] && echo "Command 'gcloud' not found" >&2 && exit 1
[ -x "jq" ] && echo "Command 'jq' not found" >&2 && exit 1

GCLOUD_LOCATION=$(command -v gcloud)
echo "Using gcloud from $GCLOUD_LOCATION"

create_resource() {
    echo "Creating ${resource_id}"

    # ensure we select the right quota project
    gcloud config set billing/quota_project ${project_id}

    # *not sure if this is necessary, but will pause to allow config change above to sync
    sleep 10

    # create the resource
    gcloud beta ai model-garden models deploy \
        --model=${model} \
        --machine-type=${machine_type} \
        --accelerator-type=${accelerator_type} \
        --project=${project_id} \
        --region=${region} \
        --endpoint-display-name=${resource_id} \
        --accept-eula
}

delete_resource() {
    echo "Destroying ${resource_id}"
    endpoint_json=$(gcloud beta ai endpoints list --list-model-garden-endpoints-only --region=${region} --project=${project_id} --format=json | jq --arg RESOURCE_ID "${resource_id}" -r '.[] | select(.displayName | contains($RESOURCE_ID))')
    model_id=$(echo ${endpoint_json} | jq -r '.deployedModels[0].id')
    endpoint=$(echo ${endpoint_json} | jq -r '.name')

    # echo ${resource_id}
    # echo ${model_id}
    # echo ${endpoint}
    # echo ${endpoint_json}

    if [ -n "${endpoint}" ]; then
        (gcloud ai endpoints undeploy-model ${endpoint} --deployed-model-id=${model_id} --region=${region} &&
            gcloud ai endpoints delete ${endpoint} --quiet)
    fi
}

# parameters we're expecting
command=$1
project_id=$2
region=$3
resource_id=$4
model=$5
machine_type=$6
accelerator_type=$7

case "${command}" in
create)
    create_resource
    ;;
*)
    delete_resource
    ;;
esac

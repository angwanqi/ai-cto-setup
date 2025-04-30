#!/usr/bin/env bash

# this script requires `gcloud` and `jq` to be present
[ -x "gcloud" ] && echo "Command 'gcloud' not found" >&2 && exit 1
[ -x "jq" ] && echo "Command 'jq' not found" >&2 && exit 1

GCLOUD_LOCATION=$(command -v gcloud)
echo "Using gcloud from $GCLOUD_LOCATION"

# change these for different model/machine/accelerator config
MACHINE_TYPE="a2-ultragpu-1g"
ACCELERATOR_TYPE="NVIDIA_A100_80GB"
MODEL="deepseek-ai/DeepSeek-R1-Distill-Llama-8B"

create_resource() {
    # ensure we select the right quota project
    gcloud config set billing/quota_project ${project_id}

    # create the resource
    gcloud beta ai model-garden models deploy \
        --model=${MODEL} \
        --machine-type=${MACHINE_TYPE} \
        --accelerator-type=${ACCELERATOR_TYPE} \
        --project=${project_id} \
        --region=${region} \
        --endpoint-display-name=${resource_id}
}

delete_resource() {
    echo ${resource_id}
    endpoint_json=$(gcloud beta ai endpoints list --list-model-garden-endpoints-only --region=${region} --project=${project_id} --format=json | jq --arg RESOURCE_ID "$resource_id" -r '.[] | select(.displayName | contains($RESOURCE_ID))')
    model_id=$(echo ${endpoint_json} | jq -r '.deployedModels[0].id')
    endpoint=$(echo ${endpoint_json} | jq -r '.name')

    # echo ${resource_id}
    # echo ${model_id}
    # echo ${endpoint}
    # echo ${endpoint_json}

    (gcloud ai endpoints undeploy-model ${endpoint} --deployed-model-id=${model_id} --region=${region} &&
        gcloud ai endpoints delete ${endpoint} --quiet)
}

command=$1
project_id=$2
region=$3
resource_id=$4

case "${command}" in
create)
    create_resource
    ;;
*)
    delete_resource
    ;;
esac

#!/usr/bin/env bash

# this script requires `gcloud` and `jq` to be present
[ -x "gcloud" ] && echo "Command 'gcloud' not found" >&2 && exit 1
[ -x "jq" ] && echo "Command 'jq' not found" >&2 && exit 1

GCLOUD_LOCATION=$(command -v gcloud)
echo "Using gcloud from $GCLOUD_LOCATION"

RESOURCE_POOL_SPEC="replica-count=3,machine-type=a2-ultragpu-1g,accelerator-type=NVIDIA_A100_80GB,accelerator-count=4,disk-type=pd-ssd,disk-size=500"
# L4
#	RESOURCE_POOL_SPEC="replica-count=3,machine-type=g2-standard-8,accelerator-type=NVIDIA_L4,accelerator-count=1,disk-type=pd-ssd,disk-size=100" \
# for testing
#   RESOURCE_POOL_SPEC="replica-count=1,min-replica-count=1,max-replica-count=3,machine-type=n1-standard-4,disk-type=pd-ssd,disk-size=100" \

create_resource() {
    gcloud ai persistent-resources create \
        --persistent-resource-id=${resource_id} \
        --display-name=${resource_id} \
        --project=${project_id} \
        --region=${region} \
        --enable-custom-service-account \
        --resource-pool-spec=${RESOURCE_POOL_SPEC}

    while [ "${result}" != "RUNNING" ]; do
        sleep 10
        result=$(gcloud ai persistent-resources describe ${resource_id} --project=${project_id} --region=${region} --format=json | jq -r '.state')
        if [ "${result}" = "ERROR" ]; then
            exit 1
        fi
    done
}

delete_resource() {
    gcloud ai persistent-resources delete ${resource_id} \
        --project=${project_id} \
        --region=${region}
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

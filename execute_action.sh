#!/bin/bash

BOT_NAME=$1
PATH=$2
IMG=$3
EVENT_TYPE=$4

function kustomize_set_image {
    git config --global user.name "${BOT_NAME}"
    pushd ${PATH}
    kustomize edit set image ${IMG}:'${EVENT_TYPE}'
    popd
    git add .
    git commit -m "Image updated"
    git push
}

kustomize_set_image

# if test "$#" -ne 1; then
#     echo "Invalid number of Arguments, plesase specify the correct number of arguments"
#     echo "Please refer https://github.com/arunalakmal/kustomize_actions#readme for more information."
#     exit 1
# else
#     kustomize_set_image
# fi
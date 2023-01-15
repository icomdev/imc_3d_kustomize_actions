#!/bin/bash

BOT_NAME=$1
FOLDER_PATH=$2
IMG=$3
EVENT_TYPE=$4
VERSION=$5   #v4.5.7

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$(pwd)

function kustomize_set_image {
    git config --global user.name "${BOT_NAME}"
    git config --global user.email "${BOT_NAME}@email.com"
    pushd ${FOLDER_PATH}
    kustomize edit set image ${IMG}:${EVENT_TYPE}
    popd
    git add .
    git commit -m "Image updated"
    git push
}

function setup_kustomize {
    case $(uname -m) in
    x86_64)
        ARCH=amd64
        ;;
    arm64|aarch64)
        ARCH=arm64
        ;;
    ppc64le)
        ARCH=ppc64le
        ;;
    s390x)
        ARCH=s390x
        ;;
    *)
        ARCH=amd64
        ;;
    esac

    OPSYS=windows
    if [[ "$OSTYPE" == linux* ]]; then
    OPSYS=linux
    elif [[ "$OSTYPE" == darwin* ]]; then
    OPSYS=darwin
    fi

    curl -sLO "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${VERSION}/kustomize_${VERSION}_${OPSYS}_${ARCH}.tar.gz"
    tar xzf ./kustomize_v*_${opsys}_${arch}.tar.gz
    $(pwd)/kustomize
}

if test "$#" -ne 5; then
    echo "Invalid number of Arguments, plesase specify the correct number of arguments"
    echo "Please refer https://github.com/arunalakmal/kustomize_actions#readme for more information."
    exit 1
elif [[ $(pwd)/kustomize  ]]; then
    echo "kustomize already installed"
    kustomize_set_image
else
    echo "kustomize not installed"
    setup_kustomize
    kustomize_set_image
fi
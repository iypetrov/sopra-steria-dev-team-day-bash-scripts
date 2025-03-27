#!/bin/bash

CONTAINERS_TARGET_STATE="containers.csv"
BABY_K8S_LOGS="baby-k8s.logs"

create_docker_container() {
    local CONTAINER_NAME="$1"

    local IMAGE_NAME=$(grep -E "^${CONTAINER_NAME}.*" "${CONTAINERS_TARGET_STATE}" | cut -d, -f2)
    local IMAGE_TAG=$(grep -E "^${CONTAINER_NAME}.*" "${CONTAINERS_TARGET_STATE}" | cut -d, -f3)
    local TEAM=$(grep -E "^${CONTAINER_NAME}.*" "${CONTAINERS_TARGET_STATE}" | cut -d, -f4)
    local PORT=$(grep -E "^${CONTAINER_NAME}.*" "${CONTAINERS_TARGET_STATE}" | cut -d, -f5)
    local CPU=$(grep -E "^${CONTAINER_NAME}.*" "${CONTAINERS_TARGET_STATE}" | cut -d, -f6)
    local MEMORY_GB=$(grep -E "^${CONTAINER_NAME}.*" "${CONTAINERS_TARGET_STATE}" | cut -d, -f7)

    docker run --name "${CONTAINER_NAME}" \
        -p "${PORT}:${PORT}" \
        -d \
        --label owner="baby-k8s" \
        --label team="${TEAM}" \
        --cpus="${CPU}" \
        --memory="${MEMORY_GB}g" \
        "${IMAGE_NAME}:${IMAGE_TAG}"
}

delete_docker_container() {
    local CONTAINER_NAME="$1"

    docker rm -f "${CONTAINER_NAME}"
}

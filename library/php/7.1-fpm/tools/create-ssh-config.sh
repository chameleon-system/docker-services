#!/usr/bin/env bash

if [ ! -z "${SSH_CONFIG}" ] && [ -f "${SSH_CONFIG}" ] && [ ! -f "/home/${SERVICE_USER_NAME}/.ssh/config" ]; then
    if [ ! -d "/home/${SERVICE_USER_NAME}/.ssh" ]; then
        mkdir -p "/home/${SERVICE_USER_NAME}/.ssh"
        chown -R ${SERVICE_USER_ID}:${SERVICE_USER_ID} "/home/${SERVICE_USER_NAME}/.ssh"
    fi
    cp "${SSH_CONFIG}" "/home/${SERVICE_USER_NAME}/.ssh/config"
    chown ${SERVICE_USER_ID}:${SERVICE_USER_ID} "/home/${SERVICE_USER_NAME}/.ssh/config"
fi
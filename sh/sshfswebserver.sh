#!/bin/bash
echo sshfs ${WEB_SERVER_USER}@${WEB_SERVER}:/ ${MNT_ROOT}/webserver
sshfs ${WEB_SERVER_USER}@${WEB_SERVER}:/ ${MNT_ROOT}/webserver

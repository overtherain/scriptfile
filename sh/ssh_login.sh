#!/bin/bash
LANG=C ssh -o PubkeyAuthentication=no ${BUILD_SERVER} -l ${BUILD_SERVER_USER} -v

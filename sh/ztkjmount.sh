#!/bin/bash
read -p "input your username:" name
read -p "input your password:" password
sudo mount -t cifs -o username=${name},password=${password} ${STORE_SERVER_URL} ${STORE_SERVER_POINT}

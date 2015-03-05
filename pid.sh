#!/bin/bash
ps -ef | grep java | grep {SERVICE_NAME} | awk '{printf $2}'
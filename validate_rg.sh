#!/bin/bash
az group list  --output table | grep "$1" | awk '{print $1}'
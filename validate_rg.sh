#!/bin/bash
az group list  --output table | grep kubeadm | awk '{print $1}'
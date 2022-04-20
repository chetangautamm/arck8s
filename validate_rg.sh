#!/bin/bash
az group list  --output table | grep kubeadm_new | awk '{print $1}'
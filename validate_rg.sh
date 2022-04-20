#!/bin/bash
az group list  -o table | grep AzureArcTest | awk '{print $1}'
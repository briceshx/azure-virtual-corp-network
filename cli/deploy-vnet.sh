#!/usr/bin/env bash
set -e

RG_NAME="rg-corp-network-lab"
LOCATION="canadacentral"
VNET_NAME="vnet-corp"

echo "Creating resource group: $RG_NAME in $LOCATION..."
az group create \
  --name "$RG_NAME" \
  --location "$LOCATION"

echo "Creating virtual network ($VNET_NAME) and app subnet..."
az network vnet create \
  --resource-group "$RG_NAME" \
  --name "$VNET_NAME" \
  --address-prefix 10.0.0.0/16 \
  --subnet-name subnet-app \
  --subnet-prefix 10.0.1.0/24

echo "Creating DB subnet..."
az network vnet subnet create \
  --resource-group "$RG_NAME" \
  --vnet-name "$VNET_NAME" \
  --name subnet-db \
  --address-prefixes 10.0.2.0/24

echo "Creating Gateway subnet..."
az network vnet subnet create \
  --resource-group "$RG_NAME" \
  --vnet-name "$VNET_NAME" \
  --name GatewaySubnet \
  --address-prefixes 10.0.10.0/24

echo "Listing all subnets:"
az network vnet show \
  --resource-group "$RG_NAME" \
  --name "$VNET_NAME" \
  --query "subnets[].{name:name, address:addressPrefix}" \
  --output table

echo "Deployment completed successfully!"


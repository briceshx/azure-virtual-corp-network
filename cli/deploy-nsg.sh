#!/usr/bin/env bash
set -e

RG_NAME="rg-corp-network-lab"
LOCATION="canadacentral"
VNET_NAME="vnet-corp"

NSG_APP="nsg-app"
NSG_DB="nsg-db"

echo "Creating NSG for app subnet: $NSG_APP..."
az network nsg create \
  --resource-group "$RG_NAME" \
  --name "$NSG_APP" \
  --location "$LOCATION"

echo "Creating NSG for db subnet: $NSG_DB..."
az network nsg create \
  --resource-group "$RG_NAME" \
  --name "$NSG_DB" \
  --location "$LOCATION"

echo "Adding rule: allow HTTP/HTTPS from Internet to app subnet..."
az network nsg rule create \
  --resource-group "$RG_NAME" \
  --nsg-name "$NSG_APP" \
  --name allow-web-in \
  --priority 100 \
  --access Allow \
  --direction Inbound \
  --protocol Tcp \
  --source-address-prefixes Internet \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 80 443

echo "Adding rule: allow RDP from GatewaySubnet (10.0.10.0/24) to app subnet..."
az network nsg rule create \
  --resource-group "$RG_NAME" \
  --nsg-name "$NSG_APP" \
  --name allow-rdp-from-gateway \
  --priority 200 \
  --access Allow \
  --direction Inbound \
  --protocol Tcp \
  --source-address-prefixes 10.0.10.0/24 \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 3389

echo "Adding rule: allow SQL (1433) from app subnet (10.0.1.0/24) to DB subnet..."
az network nsg rule create \
  --resource-group "$RG_NAME" \
  --nsg-name "$NSG_DB" \
  --name allow-sql-from-app \
  --priority 100 \
  --access Allow \
  --direction Inbound \
  --protocol Tcp \
  --source-address-prefixes 10.0.1.0/24 \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 1433

echo "Associating NSG $NSG_APP with subnet-app..."
az network vnet subnet update \
  --resource-group "$RG_NAME" \
  --vnet-name "$VNET_NAME" \
  --name subnet-app \
  --network-security-group "$NSG_APP"

echo "Associating NSG $NSG_DB with subnet-db..."
az network vnet subnet update \
  --resource-group "$RG_NAME" \
  --vnet-name "$VNET_NAME" \
  --name subnet-db \
  --network-security-group "$NSG_DB"

echo "Listing subnets with attached NSGs..."
az network vnet subnet list \
  --resource-group "$RG_NAME" \
  --vnet-name "$VNET_NAME" \
  --query "[].{name:name, nsg:networkSecurityGroup.id}" \
  --output table

echo "NSG deployment completed successfully!"


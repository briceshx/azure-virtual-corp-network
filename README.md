Virtual Corporate Network
# Azure Virtual Corporate Network 

This project simulates a small corporate network in Microsoft Azure.  
It is designed as a portfolio / learning lab for Azure networking, security, and automation.

## Architecture

Resource Group:
- **rg-corp-network-lab** (region: canadacentral)

Virtual Network:
- **vnet-corp** — address space: `10.0.0.0/16`

Subnets:
- **subnet-app** — `10.0.1.0/24` (application servers)
- **subnet-db** — `10.0.2.0/24` (database servers, more restricted)
- **GatewaySubnet** — `10.0.10.0/24` 

## What this lab demonstrates

- Creation of a virtual network and subnets
- Network security groups (NSGs) and firewall-style rules
- VPN gateway integration
- Documentation and diagram of the network

## Repository Structure

- `cli/` — Azure CLI scripts to deploy the lab
- `bicep/` — Infrastructure as Code (Bicep templates) 
- `docs/` — Architecture notes, diagrams, screenshots

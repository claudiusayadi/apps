# Self-Hosted Applications Stack

A collection of self-hosted applications deployed using Docker Compose, providing secure and private alternatives to cloud-based services.

## Overview

This repository contains Docker Compose configurations for various self-hosted applications including password management, VPN services, and database solutions. Each service is containerized for easy deployment and management.

## Services

## Services

- admin:
- - none yet
- db
- - pg
- - pgadmin
- media
- - bazarr
- - flaresolverr
- - jellyfin
- - prowlarr
- - qbittorrent
- - radarr
- - sonarr
- vaults
- - vaultwarden
- vpn
- - wg-easy

## Prerequisites

- Docker Engine 20.10.0 or later
- Docker Compose 2.0.0 or later
- Domain name with SSL certificate (for production deployment)
- Minimum 1GB RAM and 10GB storage space

## Quick Start

## Deploying Services

Use the deployer script to deploy any service:

```bash
bash deployer.sh <service> up -d
```

```

```

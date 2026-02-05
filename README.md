# Self-Hosted Applications Stack

A collection of self-hosted applications deployed using Docker Compose, providing secure and private alternatives to cloud-based services.

## Overview

This repository contains Docker Compose configurations for various self-hosted applications including password management, VPN services, and database solutions. Each service is containerized for easy deployment and management.

## Services

- admin:
- - none yet
- db
- - pg
- - pgadmin
- - mssql
- media
- - bazarr
- - flaresolverr
- - jellyfin
- - jellyseer
- - prowlarr
- - qbittorrent
- - radarr
- - sonarr

## Prerequisites

- Docker Engine 20.10.0 or later
- Docker Compose 2.0.0 or later
- Domain name with SSL certificate (for production deployment) - I have my setup for production, this is 100% local setup repo.

## Quick Start

## Deploying Services

Use the deployer script to deploy any service:

```bash
bash scripts/deployer.sh <service> up
```

```

```

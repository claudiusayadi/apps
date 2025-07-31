# Self-Hosted Applications Stack

A collection of self-hosted applications deployed using Docker Compose, providing secure and private alternatives to cloud-based services.

## Overview

This repository contains Docker Compose configurations for various self-hosted applications including password management, VPN services, and database solutions. Each service is containerized for easy deployment and management.

## Services

### Vaultwarden (Password Manager)

A lightweight, self-hosted implementation of the Bitwarden server API written in Rust. Provides secure password management with web vault access and mobile/desktop client compatibility.

**Features:**

- Compatible with official Bitwarden clients
- Lightweight and resource-efficient
- Self-hosted for complete data control
- Admin panel for user management
- HTTPS encryption support

**Location:** `vault/`

## Prerequisites

- Docker Engine 20.10.0 or later
- Docker Compose 2.0.0 or later
- Domain name with SSL certificate (for production deployment)
- Minimum 1GB RAM and 10GB storage space

## Quick Start

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd apps
   ```

2. **Environment Configuration:**

   ```bash
   cp .env.example .env
   ```

   Edit the `.env` file with your specific configuration:

   ```env
   DOMAIN=your-domain.com
   ADMIN_TOKEN=your-secure-admin-token
   ```

3. **Generate Admin Token (for Vaultwarden):**

   ```bash
   echo -n “YourVeryStrongPassword” | argon2 “$(openssl rand -base64 32)” -e -id -k 65540 -t 3 -p 4
   ```

4. **Deploy Services:**

   ```bash
   # Deploy Vaultwarden
   cd vault
   docker compose up -d
   ```

## Configuration

### Environment Variables

The following environment variables are required for proper operation:

| Variable      | Description                    | Required | Example                     |
| ------------- | ------------------------------ | -------- | --------------------------- |
| `DOMAIN`      | Your domain name with protocol | Yes      | `https://vault.example.com` |
| `ADMIN_TOKEN` | Secure token for admin access  | Yes      | `generated-secure-token`    |

### Security Considerations

- **Admin Token:** Generate a strong, random token for admin panel access
- **Domain:** Use HTTPS in production with valid SSL certificates
- **Firewall:** Configure appropriate firewall rules for exposed ports
- **Backups:** Implement regular backup strategies for data volumes
- **Updates:** Keep container images updated for security patches

## Service Details

### Vaultwarden

**Port:** `127.0.0.1:8000:80` (localhost only)
**Data Location:** `./vault/data`
**Logs Location:** `./vault/logs`

**Admin Panel:** Access via `https://your-domain.com/admin`

**Configuration:**

- Container restart policy: `unless-stopped`
- Security: `no-new-privileges` enabled
- Volume persistence for data and logs
- Bound to localhost for security

## Data Management

### Backup Strategy

1. **Data Volumes:**

   ```bash
   # Backup Vaultwarden data
   tar -czf vaultwarden-backup-$(date +%Y%m%d).tar.gz vault/data/
   ```

2. **Configuration Files:**

   ```bash
   # Backup compose configurations
   tar -czf config-backup-$(date +%Y%m%d).tar.gz vault/compose.yml .env
   ```

### Restore Process

1. **Stop Services:**

   ```bash
   docker compose down
   ```

2. **Restore Data:**

   ```bash
   tar -xzf vaultwarden-backup-YYYYMMDD.tar.gz
   ```

3. **Restart Services:**

   ```bash
   docker compose up -d
   ```

## Monitoring and Maintenance

### Health Checks

Monitor service status:

```bash
docker compose ps
docker compose logs -f
```

### Log Management

View service logs:

```bash
# View all logs
docker compose logs

# Follow logs in real-time
docker compose logs -f vaultwarden

# View logs with timestamps
docker compose logs -t vaultwarden
```

### Updates

Update services to latest versions:

```bash
# Pull latest images
docker compose pull

# Restart with new images
docker compose up -d
```

## Network Configuration

### Reverse Proxy Integration

For production deployments, configure a reverse proxy (nginx, Traefik, or Caddy) to handle:

- SSL termination
- Domain routing
- Rate limiting
- Security headers

Example nginx configuration:

```nginx
server {
    listen 443 ssl http2;
    server_name vault.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Troubleshooting

### Common Issues

1. **Container Won't Start:**

   - Check Docker daemon status
   - Verify environment variables
   - Review container logs: `docker compose logs`

2. **Access Issues:**

   - Verify port bindings: `docker compose ps`
   - Check firewall configuration
   - Validate domain/DNS settings

3. **Data Persistence:**
   - Ensure volume directories exist
   - Check file permissions
   - Verify volume mount paths

### Support Commands

```bash
# Check container status
docker compose ps

# View detailed logs
docker compose logs --details

# Restart specific service
docker compose restart vaultwarden

# Remove and recreate containers
docker compose down && docker compose up -d
```

## Security Best Practices

1. **Regular Updates:** Keep all container images updated
2. **Strong Passwords:** Use complex admin tokens and passwords
3. **Network Security:** Bind services to localhost when possible
4. **SSL/TLS:** Always use HTTPS in production
5. **Backups:** Implement automated backup solutions
6. **Monitoring:** Set up log monitoring and alerting
7. **Access Control:** Limit admin panel access to trusted networks

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

For issues and questions:

- Check the troubleshooting section
- Review service-specific documentation
- Open an issue in the repository

## Acknowledgments

- [Vaultwarden Project](https://github.com/dani-garcia/vaultwarden)
- [Bitwarden](https://bitwarden.com/)
- [Docker](https://www.docker.com/)

# DevOps Challenge

DevOps Challenge with IaC design, monitoring and application example.

## Arhcitecture and Documents

The component document and architecture

- [Terraform](./terraform/README.md)
- [Application](./application/README.md)
- [Monitoring](./monitoring/README.md)

## Pre-requiresite

- Docker

## Start local stack

```bash
docker compose up -d
docker compose logs -f
```

### Component Endpoint

- Application (Script to test on `application/scripts`)
    - [Swagger API doc](http://localhost:3000/swagger)
    - [Healthcheck](http://localhost:3000/health)
- Grafana
    - [Grafana](http://localhost:3001) - admin/admin (default password)
- Prometheus
    - [Prometheus](http://localhost:9090)

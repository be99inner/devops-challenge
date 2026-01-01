# Prometheus

Prometheus is metrics tool to monitor the metrics of the resources by scraping the metrics from target host.

> [!NOTE]
> This node exporter (docker machine host)

## Architecture

```mermaid
graph TD
    A[Targets<br/>Applications, Nodes, Services] -->|Expose Metrics| B[Prometheus Server]
    B -->|Scrape Metrics| B
    B --> C[Alertmanager<br/>Handles Alerts]
    B --> D[Grafana<br/>Visualization & Dashboards]
    D -->|Query Metrics| B
    E[Pushgateway<br/>For Batch Jobs] -->|Push Metrics| B
```

> ![NOTE]
> Improvement of production setup and kubernetes integration.

## Improvements

### Deploying Prometheus on Kubernetes
Deploy Prometheus as a Kubernetes deployment for scalability and reliability. Use Helm charts like kube-prometheus-stack for easy setup, including Prometheus Operator for managing Prometheus instances.

### Using Kubernetes Service Discovery
Leverage Kubernetes service discovery to automatically find and scrape metrics from pods, services, and endpoints. Configure Prometheus with kubernetes_sd_configs to monitor dynamic workloads without manual target configuration.

### Centralized Prometheus with Federation
Use Prometheus federation to aggregate metrics from multiple Prometheus instances across clusters. A central Prometheus pulls metrics from regional instances, enabling global monitoring while reducing load on individual clusters.

### Federated Architecture Diagram
```mermaid
graph TD
    C[Central Prometheus] -->|Federate Metrics| P1[Prometheus Cluster A]
    C -->|Federate Metrics| P2[Prometheus Cluster B]
    P1 -->|Scrape| T1[Targets in Cluster A]
    P2 -->|Scrape| T2[Targets in Cluster B]
    C --> G[Grafana]
    G -->|Query| C
```

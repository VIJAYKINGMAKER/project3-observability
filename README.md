# Project 3  Observability and Infrastructure Automation

## 1. Project Overview

This project builds a local observability platform and prepares the repository for infrastructure automation using Terraform, Ansible, and GitHub Actions.

The monitoring stack currently includes:
- Prometheus  scrapes monitoring targets and evaluates alert rules.
- Grafana  visualizes Prometheus metrics through dashboards.
- Node Exporter  exposes Linux environment metrics from its container.
- OpenTelemetry Collector  receives OTLP metrics, traces, and logs and currently exports received telemetry to debug output.

## 2. Current Architecture

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000
- Node Exporter: http://localhost:9100
- OpenTelemetry OTLP/gRPC receiver: localhost:4317
- OpenTelemetry OTLP/HTTP receiver: http://localhost:4318

Ports are bound to localhost by Docker Compose to avoid exposing these services to the network.

## 3. Prerequisites

- Windows with PowerShell
- Docker Desktop with a working Docker engine
- Git
- Terraform (for the infrastructure automation stages)

Ansible execution environment will be configured during the Ansible stage.

## 4. Start and Stop the Monitoring Stack

From the project root:

```powershell
docker compose up -d
docker compose ps
docker compose down
```

`docker compose down` stops and removes the Compose containers and network. It normally preserves the named Grafana data volume.

To view service logs:

```powershell
docker compose logs --tail 100
docker logs --since 5m p3-otel-collector
```

## 5. Prometheus Configuration

Configuration files:
- `prometheus/prometheus.yml`  scrape configuration and rule-file reference.
- `prometheus/alerts.yml`  monitoring-target availability alert.

The `MonitoringTargetDown` alert evaluates `up == 0` and waits for one minute before firing.

## 6. Grafana

Grafana is configured to use Prometheus as a data source.

The current dashboard includes monitoring target health and a Prometheus process CPU metric. The CPU query is:

```promql
rate(process_cpu_seconds_total[5m])
```

This measures Prometheus process CPU usage rate, not total Windows host CPU usage. Node Exporter runs inside a Linux container, so its metrics describe that environment rather than the full Windows host.

## 7. OpenTelemetry

The Collector accepts OTLP telemetry over gRPC and HTTP.

Current configuration uses the debug exporter. Received telemetry is printed in Collector logs; it is not yet persisted or connected to a separate telemetry backend.

A test metric was submitted to `/v1/metrics` and the Collector returned HTTP 200 and logged one metric with one data point.

## 8. Incident Exercise Completed

A monitoring-target failure was simulated by stopping the Node Exporter container:

```powershell
docker stop p3-node-exporter
```

Prometheus detected that the target was unavailable. The target was recovered with:

```powershell
docker start p3-node-exporter
```

Prometheus subsequently reported the target as up again. This demonstrated the failure, detection, recovery, and verification workflow.

## 9. Planned Infrastructure Automation

The next stages will add and validate:
- Terraform configuration, variables, outputs, and infrastructure definitions
- IAM and least-privilege access design
- Ansible inventory and configuration playbooks
- GitHub Actions validation workflow
- CloudWatch integration and alerting
- Expanded OpenTelemetry integration
- Datadog concepts and comparison
- Incident investigation, documentation, and cost review

Infrastructure deployment is not considered complete until it is implemented and verified. AWS resources will not be created without reviewing the Terraform plan and obtaining explicit approval.

## 10. Git Workflow

Use a feature branch for each meaningful change, run relevant checks, review the diff, and commit the change.

Example:

```powershell
git switch -c feature/terraform-foundation
git status --short
git diff --check
```

Do not commit credentials, private keys, Terraform state, or plan files.

## 11. Project Acceptance Criteria

- Monitoring services start and operate locally.
- Prometheus scrapes configured targets and evaluates alert rules.
- Grafana can query Prometheus.
- A monitoring failure can be detected and recovered.
- OpenTelemetry can receive test telemetry.
- Infrastructure configuration is version-controlled and validated.
- Security, deployment, troubleshooting, and cleanup procedures are documented.

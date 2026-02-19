# MSP-Stack

## v0.7.0 - 2026-02-19

### Added
- Added Zabbix monitoring stack (server, web, database)
- Initial support for infrastructure and SNMP monitoring
- Prepared Grafana integration with Zabbix datasource

### Notes
- Zabbix complements Prometheus and Loki, not replacing them


## v0.3.0 - 2026-02-18

### Added
- Loki central com retenção de 3 dias
- Alloy como DaemonSet no Kubernetes
- RBAC para leitura de logs de pods
- Labels multi-cliente (cliente, ambiente, cluster)
- Integração Grafana ↔ Loki
- Arquitetura separada VM-MONITORING / VM-CLUSTER

### Validated
- Ingestão de logs Kubernetes
- Persistência de dados Loki
- Consulta via Grafana

# Changelog

## [v0.2.0] - 2026-02-18

### Added
- Prometheus central via Docker Compose
- Persistência de dados estruturada
- Estrutura /opt/msp-stack
- Multi-client architecture using file_sd_configs
- Modular client configuration directory (/prometheus/clients)

### Changed
- Migration from docker run to docker compose
- Prometheus configuration refactored for dynamic client onboarding
- Formalization of MSP Model B architecture

### Fixed
- Volume permission issue (UID 65534) for Prometheus data directory

### Architecture
- Prometheus now supports dynamic multi-client onboarding
- Client isolation via labels (cliente, ambiente, tipo)

---

## [v0.1.0] 2026-02-18

### Changed
- Arquitetura oficial alterada para Modelo B (Monitoramento Externo MSP)

### Removed
- kube-prometheus-stack interno ao cluster

### Reason
- Alinhamento com modelo corporativo de monitoramento centralizado

### Impact
- Stack de observabilidade será instalada exclusivamente na VM-MONITORING

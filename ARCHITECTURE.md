# LABORATÓRIO DE HOMOLOGAÇÃO – OBSERVABILIDADE E MONITORAMENTO

## 1. Objetivo

Criar um ambiente de homologação profissional para desenvolvimento,
validação e testes de soluções de observabilidade e monitoramento
destinadas a clientes corporativos.

O laboratório segue o modelo MSP (Managed Service Provider),
com monitoramento centralizado externo ao ambiente cliente.

---

## 2. Arquitetura Oficial – Modelo B (Monitoramento Externo)

Separação clara entre:

- Ambiente do Cliente
- Plataforma MSP de Monitoramento

---

## 3. Ambiente Físico (Host)

Sistema Operacional: Ubuntu Desktop  
Memória RAM: 16 GB  
CPU: 3 vCPU  
Hypervisor: KVM (libvirt)

---

## 4. Topologia de Virtualização

### VM-CLUSTER (Ambiente Cliente)

- Ubuntu Server 22.04 LTS
- 8GB RAM
- 2 vCPU
- 60GB Disco
- Kubernetes: k3s
- Runtime: containerd

Função:
- Execução de aplicações do cliente
- Exposição de métricas, logs e traces
- NÃO processa monitoramento

---

### VM-MONITORING (Plataforma MSP)

- Ubuntu Server 22.04 LTS
- 6GB RAM
- 1 vCPU
- 40GB Disco
- Docker Engine

Função:
- Prometheus (central)
- Grafana (central)
- Loki (central)
- Tempo (central)
- Zabbix Server
- Portainer
- Alloy Receivers

---

## 5. Modelo de Containerização

VM-CLUSTER:
- Kubernetes (k3s)
- Runtime: containerd
- Agentes de coleta apenas

VM-MONITORING:
- Docker Engine
- Processamento e armazenamento centralizado

---

## 6. Fluxo de Observabilidade

Aplicação Cliente
        ↓
Agente (Alloy / Exporters)
        ↓
VM-MONITORING (Plataforma MSP)
        ↓
Grafana (Correlação)
        ↓
Alertas (Prometheus / Zabbix)

---

## 7. Estratégia Multi-Cliente

A arquitetura permite:

- Adicionar múltiplas VMs-CLUSTER
- Segregação por labels
- Segregação por job no Prometheus
- Segregação por tenant no Grafana

---

## 8. Justificativa Arquitetural

- Separação de responsabilidade
- Modelo compatível com ambientes corporativos
- Escalável
- Alinhado a modelo MSP
- Facilita expansão futura

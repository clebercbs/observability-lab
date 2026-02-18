# BUILD GUIDE
Laboratório de Homologação – Observabilidade e Monitoramento

Este documento descreve o passo a passo para reproduzir o ambiente completo
em um novo host Ubuntu.

---------------------------------------------------------------------

# 1. PRÉ-REQUISITOS DO HOST

Hardware mínimo recomendado:

- 16GB RAM
- 3 vCPU
- 150GB disco livre

Sistema Operacional:
- Ubuntu Desktop 22.04 LTS ou superior

---------------------------------------------------------------------

# 2. INSTALAÇÃO DO KVM NO HOST

Atualizar sistema:

sudo apt update && sudo apt upgrade -y

Instalar pacotes necessários:

sudo apt install -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virt-manager \
  cpu-checker

Verificar suporte a virtualização:

egrep -c '(vmx|svm)' /proc/cpuinfo

Instalar verificador:

sudo apt install cpu-checker -y
kvm-ok

Adicionar usuário aos grupos:

sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

Reiniciar sessão (logout/login) ou reboot.

Verificar grupos:

groups

---------------------------------------------------------------------

# 3. VERIFICAR SERVIÇOS DO LIBVIRT

sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd

Verificar rede default:

virsh net-list --all

Se necessário:

sudo virsh net-start default
sudo virsh net-autostart default

---------------------------------------------------------------------

# 4. CRIAÇÃO DAS VMs

Utilizar virt-manager.

-------------------------------------------------
VM-CLUSTER
-------------------------------------------------

SO: Ubuntu Server 22.04 LTS
RAM: 8192 MB
vCPU: 2
Disco: 60GB
Rede: Virtual network 'default' (NAT)
Instalar OpenSSH durante setup

-------------------------------------------------
VM-MONITORING
-------------------------------------------------

SO: Ubuntu Server 22.04 LTS
RAM: 6144 MB
vCPU: 1
Disco: 40GB
Rede: Virtual network 'default' (NAT)
Instalar OpenSSH

---------------------------------------------------------------------

# 5. CONFIGURAÇÃO BASE NAS VMs

Em ambas as VMs:

sudo apt update && sudo apt upgrade -y
sudo apt install qemu-guest-agent curl git -y
sudo systemctl enable --now qemu-guest-agent

---------------------------------------------------------------------

# 6. INSTALAÇÃO DO DOCKER (APENAS VM-MONITORING)

Instalar dependências:

sudo apt install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings

Adicionar chave:

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

Adicionar repositório:

echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

Instalar Docker:

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

Adicionar usuário ao grupo docker:

sudo usermod -aG docker $USER

Logout/login após execução.

---------------------------------------------------------------------

# 7. INSTALAÇÃO DO KUBERNETES (VM-CLUSTER)

Instalar k3s:

curl -sfL https://get.k3s.io | sh -

Verificar serviço:

sudo systemctl status k3s

Verificar cluster:

sudo kubectl get nodes

---------------------------------------------------------------------

# 8. CONFIGURAÇÃO DO KUBECONFIG

Permitir uso sem sudo:

sudo chmod 644 /etc/rancher/k3s/k3s.yaml

OU (boa prática):

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

Testar:

kubectl get nodes

Resultado esperado:

vm-cluster   Ready

---------------------------------------------------------------------

# 9. INSTALAÇÃO DO HELM (VM-CLUSTER)

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

Verificar:

helm version

Adicionar repositórios:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

---------------------------------------------------------------------

# 10. INSTALAÇÃO DA STACK DE OBSERVABILIDADE

Criar namespace:

kubectl create namespace monitoring

Instalar kube-prometheus-stack:

helm install observability prometheus-community/kube-prometheus-stack \
  --namespace monitoring

Verificar pods:

kubectl get pods -n monitoring

Aguardar todos ficarem Running.

---------------------------------------------------------------------

# 11. ACESSO AO GRAFANA

Descobrir serviço:

kubectl get svc -n monitoring

Port-forward:

kubectl port-forward svc/observability-grafana 3000:80 -n monitoring

Acessar via navegador:

http://IP_DA_VM:3000

Obter senha admin:

kubectl get secret observability-grafana -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 -d ; echo

---------------------------------------------------------------------

# 12. MODELO DE CONTAINERIZAÇÃO

VM-CLUSTER:
- Kubernetes (k3s)
- Runtime: containerd

VM-MONITORING:
- Docker Engine
- Portainer
- Zabbix (futuro)

---------------------------------------------------------------------

# STATUS ATUAL DO AMBIENTE

✔ KVM instalado
✔ VMs criadas
✔ k3s operacional
✔ Helm instalado
✔ kube-prometheus-stack instalado
✔ Grafana acessível

---------------------------------------------------------------------

# 13. REMOÇÃO DA STACK INTERNA (TRANSIÇÃO PARA MODELO B)

Caso kube-prometheus-stack tenha sido instalado no cluster:

Listar releases:

helm list -n monitoring

Remover:

helm uninstall observability -n monitoring

Excluir namespace:

kubectl delete namespace monitoring

Objetivo:
Garantir que o cluster atue apenas como ambiente cliente,
sem processamento interno de observabilidade.

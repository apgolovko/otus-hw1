#!/bin/bash
source .bashrc

YC_VM_NAME=dataproc-proxy

# Установка переменных
YC_ZONE=ru-central1-b
YC_SUBNET_NAME=ap-golovko-dataproc-subnet
YC_SA_NAME=sa-dataproc-hw3
YC_USER=admin

# Создание виртуальной машины
log "Creating virtual machine..."
yc compute instance create \
    --preemptible \
    --name ${YC_VM_NAME} \
    --hostname ${YC_VM_NAME} \
    --zone ${YC_ZONE} \
    --memory=16 \
    --cores=2 \
    --create-boot-disk `
        `image-folder-id=standard-images,`
        `image-family=ubuntu-2004-lts,`
        `type=network-hdd,`
        `size=30 \
    --network-interface subnet-name=${YC_SUBNET_NAME},nat-ip-version=ipv4 \
    --service-account-name ${YC_SA_NAME} \
    --metadata serial-port-enable=1 \
    --metadata-from-file user-data=metadata.yaml

log "Virtual machine created successfully!"

# Ожидание завершения создания виртуальной машины

# Получение публичного IP-адреса виртуальной машины
log "Getting public IP address of the proxy VM..."
YC_PROXY_VM_PUBLIC_IP=$(
    yc compute instance get ${YC_VM_NAME} \
        --format json | jq -r .network_interfaces[0].primary_v4_address.one_to_one_nat.address
)
log "Proxy VM public IP: $YC_PROXY_VM_PUBLIC_IP"

# Копирование SSH-ключа на виртуальную машину
scp ~/.ssh/id_ed25519 $YC_USER@$YC_PROXY_VM_PUBLIC_IP:~/.ssh/id_ed25519
log "INFO": "SSH private key copied to proxy VM successfully!"
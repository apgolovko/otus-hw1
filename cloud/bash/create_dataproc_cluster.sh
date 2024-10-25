#! /bin/sh
source .bashrc

SSH_PUBLIC_KEY_PATH=~/.ssh/id_ed25519.pub
YC_CLUSTER=ap-golovko-dataproc-cluster
YC_VERSION=2.0
YC_ZONE=ru-central1-b
YC_SUBNET_NAME=ap-golovko-dataproc-subnet
YC_BUCKET=ap-golovko-dataproc-bucket
YC_SA_NAME=sa-dataproc-hw3
YC_SECURITY_GROUP=ap-golovko-dataproc-security-group
YC_SECURITY_GROUP_ID=$(yc vpc security-group get ${YC_SECURITY_GROUP} --format json | jq -r .id)

# Создание кластера
log "Creating DataProc cluster..."
yc dataproc cluster create ${YC_CLUSTER} \
    --zone ${YC_ZONE} \
    --service-account-name ${YC_SA_NAME} \
    --version ${YC_VERSION} \
    --ui-proxy \
    --services yarn,spark,hdfs \
    --bucket ${YC_BUCKET} \
    --security-group-ids ${YC_SECURITY_GROUP_ID} \
    --ssh-public-keys-file $SSH_PUBLIC_KEY_PATH \
    --subcluster `
        `name='master',`
        `role=masternode,`
        `preemptible=true,`
        `hosts-count=1,`
        `resource-preset='s3-c4-m16',`
        `disk-type='network-ssd',`
        `disk-size=40,`
        `subnet-name=${YC_SUBNET_NAME} \
    --subcluster `
        `name='compute',`
        `role=computenode,`
        `preemptible=true,`
        `hosts-count=1,`
        `resource-preset='s3-c4-m16',`
        `disk-type='network-hdd',`
        `disk-size=200,`
        `subnet-name=${YC_SUBNET_NAME} \
    --subcluster `
        `name='data',`
        `role=datanode,`
        `preemptible=true,`
        `hosts-count=1,`
        `resource-preset='s3-c4-m16',`
        `disk-type='network-ssd',`
        `disk-size=160,`
        `subnet-name=${YC_SUBNET_NAME} \
    --async

log "DataProc cluster created successfully!"
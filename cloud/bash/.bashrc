export SSH_PUBLIC_KEY_PATH=~/.ssh/id_ed25519.pub
export YC_CLUSTER=ap-golovko-dataproc-cluster
export YC_VERSION=2.0
export YC_ZONE=ru-central1-b
export YC_SUBNET_NAME=ap-golovko-dataproc-subnet
export YC_BUCKET=ap-golovko-otus-hw3-bucket
export YC_SA_NAME=sa-dataproc-hw3
export YC_SECURITY_GROUP=ap-golovko-dataproc-security-group

function log() {
    echo $(date) "| INFO:" $@
}
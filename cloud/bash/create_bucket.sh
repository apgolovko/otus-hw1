#!/bin/bash
source .bashrc

# Установка переменных
YC_BUCKET=ap-golovko-otus-hw3-bucket

# Создание бакета
log "Creating bucket $YC_BUCKET..."
yc storage bucket create $YC_BUCKET --async

cd cloud/bash/
bash create_dataproc_cluster.sh 
bash create_virtual_machine.sh 

cd ../..

yc compute instance get dataproc-proxy --format json | jq -r .network_interfaces[0].primary_v4_address.one_to_one_nat.address
scp ~/.ssh/id_ed25519 admin@89.169.164.247:~/.ssh/id_ed25519

ssh -L 8888:localhost:8888 admin@89.169.164.247
ssh -L 8888:localhost:8888 ubuntu@10.0.0.13

hadoop distcp s3a://ap-golovko-otus-hw-bucket/ ./data
hadoop distcp s3a://ap-golovko-otus-hw3-bucket/preprocessed ./preprocessed


scp /home/admin/projects/otus-hw1/src/data_processing.py  admin@89.169.164.247:~/data_processing.py
ssh admin@89.169.164.247
scp ~/data_processing.py ubuntu@10.0.0.13:~/data_processing.py

python data_processing.py --input_filepath preprocessed/ --output_filepath dataset/
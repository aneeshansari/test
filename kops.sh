echo "Enter AWS Access Key:"
read awsaccess

echo "Enter AWS Secret Key:"
read awssecret

echo "Enter Cluster Name:"
read clname

echo "Enter an Defualt Region for the cluster:"
read defaultregion

echo "Enter an AZ for the cluster:"
read az

sudo apt update && sudo apt install awscli -y

ssh-keygen -N "" -f $HOME/.ssh/id_rsa

aws configure set aws_access_key_id $awsaccess
aws configure set aws_secret_access_key $awssecret
aws configure set default.region $defaultregion

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.4/bin/linux/amd64/kubectl

sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

curl -LO https://github.com/kubernetes/kops/releases/download/v1.23.4/kops-linux-amd64


sudo mv kops-linux-amd64 kops
sudo chmod +x kops
sudo mv kops /usr/local/bin/

aws s3 mb s3://$clname

kops create cluster --name=$clname --state=s3://$clname --node-count=2 --node-size=t2.medium --master-size=t2.medium --master-volume-size=30 --node-volume-size=30 --zones=$az --ssh-public-key ~/.ssh/id_rsa.pub --yes

# factorio-server
Templated factorio server using terraform with an AWS provider and ansible configuration.

Uses this role: https://github.com/bplower/ansible-factorio

# Prerequisites
You will need an existing EBS volume in AWS with a tag `Name=factorio_saves`.  This is where your save games will be stored.  This infrastructure is designed to expect an existing EBS resource to ensure that terraform will never try to regenerate it.

# Setup environment
Instructions are written using Ubuntu as localhost.  You will need terraform, python3, and pip3 installed locally.

### Get this repo

    $ git clone git@github.com:jonathonball/factorio-server.git
    $ cd factorio-server

### Get dependencies

    $ mkdir -p ~/.ansible/factorio-tmp
    $ wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py -O ec2.py
    $ virtualenv -p /usr/bin/python3 venv
    $ source venv/bin/activate
    [venv] $ pip3 install ansible boto
    [venv] $ ansible-galaxy install bplower.factorio

### Setup your AWS credentials file

    [venv] $ cp aws-creds.example.sh aws-creds.sh
    [venv] $ vim aws-creds.sh
    # Add you secrets
    [venv] $ source aws-creds.sh

### Build infrastructure and configure server

    [venv] $ terraform init # if needed
    [venv] $ terraform plan -out infra.plan
    [venv] $ terraform apply "infra.plan"
    [venv] $ ansible-playbook -i ec2.py playbooks/factorio-server.yaml

# factorio-server
Templated factorio server using terraform with an AWS provider and ansible configuration.

# Setup environment
Instructions are written using Ubuntu as localhost.  You will need terraform,
python3, and pip3 installed locally.

### Get this repo

    $ git clone git@github.com:jonathonball/factorio-server.git
    $ cd factorio-server

### Get dependencies

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

    [venv] $ terraform plan -out infra.plan
    [venv] $ terraform apply "infra.plan"
    [venv] $ ansible-playbook -i ec2.py factorio-server.yaml

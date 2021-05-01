Ansible code to provision and deploy The Point's website (https://github.com/thepointchurch/thepoint).

To set up a deployment environment:

1. [Install poetry](https://python-poetry.org/docs/#installation)

2. Clone the Ansible repository:

    ```
    git clone https://github.com/thepointchurch/thepoint-ansible.git
    cd thepoint-ansible
    ```

3. Set up the poetry environment:

    ```
    poetry install
    poetry run pre-commit install
    poetry shell
    ```

4. Configure Mitogen:

    ```
    echo strategy_plugins = $(ls -d $(poetry env info -p)/lib/python*/site-packages/ansible_mitogen/plugins/strategy) >>ansible.cfg
    ```

5. Install Ansible collections:

    ```
    ansible-galaxy collection install -r requirements.yml
    ```

## Provisioning in AWS

To provision compute and storage resources in Amazon cloud:

    ansible-playbook aws_provision.yml

## Deploying in AWS

To deploy the site to the EC2 host:

    ansible-playbook -i all.aws_ec2.yml aws_deploy.yml

Ansible code to provision and deploy The Point's website (https://github.com/thepointchurch/thepoint).

To set up a deployment environment:

1. [Install uv](https://docs.astral.sh/uv/getting-started/installation/)

2. Clone the Ansible repository:

    ```
    git clone https://github.com/thepointchurch/thepoint-ansible.git
    cd thepoint-ansible
    ```

3. Set up the virtual environment:

    ```
    uv sync --locked --dev
    uv run pre-commit install
    ```

4. Install Ansible collections:

    ```
    uv run ansible-galaxy collection install -r requirements.yml
    ```

5. Set AWS environment variables in `.env`.

## Provisioning in AWS

To provision compute and storage resources in Amazon cloud:

    uv run --env-file .env ansible-playbook aws_provision.yml

## Deploying in AWS

To deploy the site to the EC2 host:

    uv run --env-file .env ansible-playbook -i all.aws_ec2.yml aws_deploy.yml

Ansible code to provision and deploy The Point's website (https://github.com/thepointchurch/thepoint).

To provision compute and storage resources in Amazon cloud:

    ansible-playbook aws_provision.yml

To deploy the site to the EC2 host:

    ansible-playbook -i all.aws_ec2.yml aws_deploy.yml

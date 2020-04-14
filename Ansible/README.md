# Ansible

<https://www.youtube.com/watch?v=s8XVp3tdpas&list=PLtGnc4I6s8dvMkOS0ecQQADV8qJLwlwH9&index=2>

## Installation

```bash
sudo pacman -S ansible
```

## Dockerized linux with SSH access

```bash
# password access - linuxserver.io:pass
docker run --name linux1 --rm -e SUDO_ACCESS=true PASSWORD_ACCESS=true -e USER_PASSWORD=pass linuxserver/openssh-server
ssh linuxserver.io@172.17.0.8 -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

OR

```bash
# ssh-keys access
docker run --name linux1 --rm -e SUDO_ACCESS=true -e PUBLIC_KEY="`cat $HOME/.ssh/id_rsa.pub`" linuxserver/openssh-server
ssh linuxserver.io@172.17.0.8 -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

### Run ansible-playbook

```bash
ansible-playbook -i inventory.ini prepare.yaml
```

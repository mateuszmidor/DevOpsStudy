# Role as reusable code

## Creating role from template

Create ansible role with:

```bash
ansible-galaxy init adduser
```

Added users:

- andrzej:andrzej1
- marian:marian1
- tadek:tadek1

For actual worker code see: ```./roles/adduser/tasks/main.yml```

## Docker image linuxserver/openssh-server weirdness

Seems it's sshd server has problems accepting newly added users.
But if you run new sshd:

```bash
sudo /usr/sbin/sshd -p 22
```

, you will be able to ssh with new users:

```bash
ssh andrzej@172.17.0.8 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
ssh tadek@172.17.0.8 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
ssh marian@172.17.0.8 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

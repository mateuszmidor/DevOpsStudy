# Terraform with DigitalOcean

## Prepare

- add your public ssh key ~/.ssh/id_rsa.pub to DigitalOcean account (Settings -> Security -> SSH keys)

- remember the added key's fingerprint (like 29:e8:64:59:06:b6:3c:2e:d9:4c:a4:87:89:28:c5:e0) into env variable: DO_FINGERPRINT

- create API token (API -> Personal access tokens) and remember it into env variable: DO_TOKEN
  The token only shows up upon creation, so REMEMBER IT.  
  <https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/>

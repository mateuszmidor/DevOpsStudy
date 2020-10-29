# Terraform with AWS

For terraform to work with AWS cloud, you need PEM key, installed and configured aws cli and aws iam authenticator.
See below.

## Prepare

- create AWS key "terraform-key" and save under ~/Downloads/terraform-key.pem. Set permissions to 600
  <https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#KeyPairs:>

- install and configure aws console and iam authenticator:

```bash
./install_awscli_iamauthenticator.sh
```

# EKS - wdrażanie kubernetes na AWS

<https://www.youtube.com/watch?v=N7jMLVC69F8&list=PLC2hWv6J_iIzt3140dXL-Ts31Owodl7lB&index=11>

## Instalacja i konfiguracja awscli i eksctl

```bash
./install_awscli_eksctl.sh
```

Zostaniesz zapytany o klucze do konta AWS, znajdziesz je w konsoli AWS:
<https://console.aws.amazon.com/iam/home?region=eu-central-1#/security_credentials>

```text
AWS Access Key ID [****************RWRQ]:
AWS Secret Access Key [****************V0xr]:
Default region name [eu-central-1]:
Default output format [json]:
```

## Tworzymy klaster na AWS (trwa 15 minut!)

```bash
./eks-create-cluster.sh
```

## Odpalamy dany przykład

```bash
./run_all.sh
```

## Kasujemy klaster na AWS (raportuje koniec szybko, ale też trwa 15 minut)

```bash
./eks-delete-cluster.sh
```

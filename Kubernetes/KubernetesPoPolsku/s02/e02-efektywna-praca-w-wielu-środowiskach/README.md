# Efektywna praca na wielu środowiskach (na przykładzie DigitalOcean )

<https:///www.youtube.com/watch?v=W9p4xz2RP_g&list=PLC2hWv6J_iIzt3140dXL-Ts31Owodl7lB&index=15>

## Zakładamy konto na DigitalOcena z 100$ za free

<https://cloudowski.com/digitalocean> (03.2020 - Revolut nie akceptują)

## Instalujemy i konfigurujemy doctl

```bash
pamac build doctl-bin
doctl auth init # will ask for API Token; create it here: https://cloud.digitalocean.com/account/api/tokens
```

## Tworzymy klaster na DigitalOcean (trwa kilka minut)

```bash
./do-create-cluster.sh
```

## Odpalamy dany przykład

```bash
./run_all.sh
```

## Odpalamy dashboard

```bash
./show-dashboard.sh
```

## Kasujemy klaster na DigitalOcean (trwa króciutko)

```bash
./do-delete-cluster.sh
```

## Warto też zainstalować k9s do monitorowania PODów

```bash
sudo pacman -S k9s
k9s
```

# Custom terraform provider - fibbonaci provider; what cooler can you get :)

Based on terraform example but changed server to fibb provider:
<https://www.terraform.io/docs/extend/writing-custom-providers.html>

## Resource

- Name:  
```fibb```

- In-param:  
```n [int]```

- Out-param:  
```result [int]```

## Build provider, run terraform to create fibb(10) resource

```bash
./run_all.sh
```

## Notice

The "go.mod" is not mentioned by terraform but is necessary for go build to download dependencies.
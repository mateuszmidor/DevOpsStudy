# Custom terraform provider - fibbonaci provider; what cooler can you get :)

<https://www.terraform.io/docs/extend/writing-custom-providers.html>


## Provider

- Name:  
```fibbonacci```

## Resource

- Name:  
```fibbonacci-value```

- In-param:  
```n [int]```

- Out-param:  
```result [int]```

## Building the provider

```bash
./build_all.sh
```

The "go.mod" is not mentioned by terraform but is necessary for go build to download dependencies.

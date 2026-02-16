# Green Siren Services

## nixos.gss
Install on node to run services

## homeManager.gss
Install on user to install `docker-compose.yaml` in `~/service/gss` for `podman compose` commands to work

## gss/secret.env
The secret env file, update it with

```sh
clan vars get <host> gss/secret-env >> .env
cat .env | clan vars set <host> gss/secret-env
```

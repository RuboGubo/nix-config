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

## NixOS nginx frontend

The host owns public TCP ports 80 and 443. HTTP requests default to Compose
nginx at `127.0.0.1:8081`, preserving the Host header and forwarding legacy
Certbot challenges. HTTPS uses SNI passthrough: every hostname except
`firefly.greensiren.co.uk` and `firefly-importer.greensiren.co.uk` goes to
Compose nginx at `127.0.0.1:8444`.
Compose keeps its existing TLS certificates, routes, Nextcloud FPM setup, and
WebSocket handling. Connections without SNI also go to Compose.

Firefly uses the host's PHP-FPM and nginx, with a local TLS listener at
`127.0.0.1:8443`. The data importer shares that listener, and NixOS ACME manages
both certificates. Firefly starts with SQLite in `/var/lib/firefly-iii`; its persistent application key comes
from the Clan `firefly/app-key` generator. Back up both its data and key.

Initial deployment:

1. Point `firefly.greensiren.co.uk` DNS at node1 (including IPv6 if an AAAA
   record exists).
2. Add the new `nginx.nixos.nix` and `firefly.nixos.nix` files to Git so normal
   Git-based flake commands include them.
3. Generate the application key with
   `nix develop -c clan vars generate node1 --generator firefly`.
4. Build the configuration before the cutover. Stop the old Compose nginx
   immediately before activating the new configuration, so ports 80/443 are
   free. Recreate Compose nginx with the new localhost port mappings as part
   of the deployment; merely restarting the old container retains its old
   mappings. Keep the existing volumes and Certbot service.
5. Verify HTTP redirects, HTTPS, a legacy WebSocket route, Nextcloud, and
   Firefly. Check both the legacy Certbot challenge path and Firefly's ACME
   issuance. The one-time cutover briefly interrupts connections.

TLS passthrough currently presents the frontend's address to the legacy
nginx, rather than the original client IP. Firefly's local TLS listener also
sees the frontend address. Preserving client IPs would require coordinated
PROXY protocol configuration on both ends.

## Firefly data importer

The NixOS module runs the importer at
`https://firefly-importer.greensiren.co.uk`. Add an A record for
`firefly-importer` pointing to node1 (`178.79.150.220`) before deploying so ACME
can issue its certificate. Its state lives in `/var/lib/firefly-iii-data-importer`.

In Firefly's OAuth settings, create a client with callback URL
`https://firefly-importer.greensiren.co.uk/callback` and uncheck **Confidential**.
Open the importer, enter the client ID, and authorize access. The importer
already has Firefly's HTTPS URL configured; no access token needs to be stored
in Nix. See the [upstream OAuth instructions](https://docs.firefly-iii.org/how-to/firefly-iii/features/api/).

## How to migrate

export using:

1. `docker exec node1_db_1 mysqldump -u nextcloud -p'password' nextcloud > nextcloud-db.sql`

2. rsync files over, including the nextcloud folder (/var/www/html in the docker container)
`rsync -Aavx root@80.85.84.19:/home/service/basikdocker/docker-data/nextcloud/nextcloud/ nextcloud-dirbkp/`

import using:

1. Just copy nextcloud-html files strait in, make sure server is in maintanence mode and same version as old server
2. `sudo podman exec green_siren_services_db_1 mysql -u nextcloud -p'password' -e "DROP DATABASE nextcloud"`
2. `sudo podman exec green_siren_services_db_1 mysql -u nextcloud -p'password' -e "CREATE DATABASE nextcloud"`
2. `cat nextcloud-db.sql | sudo podman exec -i green_siren_services_db_1 mysql -u nextcloud -p'password' nextcloud`
    - Verify it worked `sudo podman exec green_siren_services_db_1 mysql -u nextcloud -p'password' -e "SHOW TABLES;"`


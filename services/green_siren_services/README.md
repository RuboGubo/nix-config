# Green Siren Services (GSS)

This is the documentation for using this module

1. Using clan, deploy to the correct machine
2. Use the ssh module to give yourself ssh access
3. ssh in, navigate to the Programs file, and run `podman compose up` to start, etc.
  - I might make this happen automatically at some point, for now this will do.
  
  
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



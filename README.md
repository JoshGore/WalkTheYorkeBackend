# WalkTheYorkeBackend
configures and exposes postgis database, attaches tegola tile server and hasura graphql server behind caddy with ssl
add variables to .env:
```
POSTGRES_PASSWORD=password
HASURA_SECRET=secret
API_HOSTNAME=api.hostname.com
TILES_HOSTNAME=tiles.hostname.com
```
start postgres database:
```
docker-compose up --build postgres
```
import data using pg_restore -d "postgres://postgres:password@localhost:5432/gis" dump
docker-compose up
import hasura metadata

## Optional Cockpit Installation
```
apt install cockpit
ufw allow 9090
apt install cockpit/bionic-backports
apt install cockpit-bridge/bionic-backports
apt install cockpit-ws/bionic-backports
apt install cockpit-system/bionic-backports
apt install cockpit-pcp/bionic-backports
systemctl restart cockpit
```

#!/bin/bash

apt-get update
apt-get install -y postgis-doc postgis
apt-get install -y libgdal-dev binutils gdal-bin redis-server

export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
pip3 install -r /support/requirements.txt

# Postgres setup
# Allow local connections to 'postgres' and 'cornerwise' roles.
sed -i '75 a\
local postgres all trust\
local cornerwise all trust' /etc/postgresql/*/main/pg_hba.conf

service postgresql start
createdb -U postgres cornerwise
psql -U postgres -q -f /support/pg_setup.sql

sh /support/export_parcels.sh
rm -r /shapefiles

# Postgres 15 install has different privileges than prior installs,
# or was installed incorrectly. I tried many things to fix it, and bailed. 
# To get around it, we copy files to be executed by psql to the postgres 
# directory:
# /var/lib/postgresql:
sudo cp -r ./upgrade/db.16 /var/lib/postgresql/upgrade/db.16
sudo -i -u postgres psql -d vpatlas -f /var/lib/postgresql/upgrade/db.16/16_01_*.sql
sudo -i -u postgres psql -d vpatlas -f /var/lib/postgresql/upgrade/db.16/16_02_*.sql
sudo -i -u postgres psql -d vpatlas -f /var/lib/postgresql/upgrade/db.16/16_03_*.sql
sudo -i -u postgres psql -d vpatlas -f /var/lib/postgresql/upgrade/db.16/16_04_*.sql

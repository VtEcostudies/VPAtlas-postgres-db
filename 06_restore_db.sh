# use the -i option to avoid privs errors
sudo -i -u postgres psql -c "DROP DATABASE IF EXISTS vpatlas"
sudo -i -u postgres psql -c "CREATE DATABASE vpatlas"
sudo -i -u postgres psql -c "CREATE ROLE vpatlas WITH SUPERUSER LOGIN PASSWORD 'EatArugula'"
# this apparrently worked before, but for our new install of pg15, cold not fix privs to use local dir
#sudo -i -u postgres pg_restore --dbname=vpatlas --create --verbose ./restore/vpatlas.backup
# I was able to make this work:
sudo cp ./restore/vpatlas.backup /var/lib/postgresql
sudo -i -u postgres pg_restore --dbname=vpatlas --create --verbose /var/lib/postgresql/vpatlas.backup

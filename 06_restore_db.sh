sudo -u postgres psql -c "CREATE DATABASE vpatlas"
sudo -u postgres psql -c "CREATE ROLE vpatlas WITH SUPERUSER LOGIN PASSWORD 'EatArugula'"
sudo -u postgres pg_restore --dbname=vpatlas --create --verbose ./restore/vpatlas.backup

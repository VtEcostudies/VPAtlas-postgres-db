#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_000_create_table_db_upgrade.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_00_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_01_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_02_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_03_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_04_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_05_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_06_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_07_*.sql
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_08_*.sql

sudo -u postgres psql -d vpatlas -c "BEGIN TRANSACTION;"
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_*.sql
sudo -u postgres psql -d vpatlas -c "COMMIT TRANSACTION;"

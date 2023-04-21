sudo -u postgres psql -d vpatlas -c "BEGIN TRANSACTION"
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_000_create_table_db_upgrade.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_00_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_01_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_02_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_03_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_04_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_05_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_06_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_07_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_08_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_09_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_10_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_11_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_12_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_13_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_14_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_15_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_16_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_17_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_18_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_19_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_20_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_21_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_22_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_23_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_24_*.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_fix_vpmapped_text_fields.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_fix_vpvisit_text_fields.sql
sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_fix_vpreview_text_fields.sql
sudo -u postgres psql -d vpatlas -c "INSERT INTO db_upgrade (db_version) VALUES (15)"
sudo -u postgres psql -d vpatlas -c "COMMIT TRANSACTION;"

#sudo -u postgres psql -d vpatlas -c "BEGIN TRANSACTION;"
#sudo -u postgres psql -d vpatlas -f ./upgrade/db.15/15_*.sql
#sudo -u postgres psql -d vpatlas -c "COMMIT TRANSACTION;"

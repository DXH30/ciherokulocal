# ciherokulocal
Menggunakan bash untuk melakukan switching env dari heroku ke local

# Cara installasi
git clone repo ini, lalu copy file install.sh ke project folder ci isikan application/config/database.php dengan
```php
# BEGIN LOCAL
setting database local...
# END LOCAL
# BEGIN HEROKU
setting database heroku...
# END HEROKU
```

# Cara pakai
```bash
./install command # Untuk petunjuk
# Dengan ketentuan command
# h2l : mengubah konfig ke local
# l2h : mengubah konfig ke heroku
# i   : melihat init
# q   : keluar
```

# Contoh
Untuk mengubah env heroku ke local
```bash
./install h2l
```
Untuk mengubah env local ke heroku
```bash
./install l2h
```



```bash
$ docker compose up -d

$ # connect local mysql, password is "rootpassword"
$ docker exec -it hello_spring_boot_mysql mysql -u root -p
$ # or instead, access directly
$ mysql -h 127.0.0.1 -u root -p 

$ # migration
$ ./gradlew flywayMigrate
```
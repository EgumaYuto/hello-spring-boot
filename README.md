## Local development

```bash
$ docker compose up -d

$ # connect local mysql, password is "rootpassword"
$ docker exec -it hello_spring_boot_mysql mysql -u root -p
$ # or instead, access directly
$ mysql -h 127.0.0.1 -u root -p 

$ # migration
$ ./gradlew flywayMigrate

$ # Generate Code
$ ./gradlew generateHellodbJooq
```

## Dev environment on AWS (ECS + ALB + Aurora MySQL)

The full dev environment can be deployed / torn down with one command each.

Prerequisites:
- AWS profile `sandbox` is valid (AssumeRole into the SANDBOX-SAMPLE account). See `scripts/lib.sh` for the defaults you can override (`AWS_PROFILE`, `REGION`, `WORKSPACE`).
- Docker daemon running (for `deploy.sh`, which builds & pushes the image).

```bash
$ ./scripts/deploy.sh     # platform -> build & push image -> application, prints the ALB URL
$ ./scripts/teardown.sh   # destroys everything to stop charges
```

After `deploy.sh` finishes (ECS rollout / Aurora take a few minutes to be healthy):

```bash
$ curl http://<alb-dns>/        # -> Hello World!
$ curl http://<alb-dns>/user    # -> [] (reads the Aurora users table)
```
# accds
Assetto Corsa Competizione Docker Server

```
// some commands

// create ec2
$ docker-machine create --driver amazonec2 --amazonec2-region sa-east-1 --amazonec2-instance-type c5.large steamaccds2

// connect to EC2
$ eval $(docker-machine env steamaccds2)

// attach to container console
$ docker attach 099e7abb432e

// connect to container bash
$ docker exec -it 099e7abb432e bash
```

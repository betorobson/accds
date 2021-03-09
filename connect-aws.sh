 #!/bin/bash
docker-machine regenerate-certs steamaccds3 -f
eval $(docker-machine env steamaccds3)

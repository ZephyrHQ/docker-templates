# Options
PROJECT := zephyrsignature
DOCKER_COMPOSE_FILES_OPTIONS := -f docker-compose.yaml
DOCKER_COMPOSE_OPTIONS := $(DOCKER_COMPOSE_FILES_OPTIONS) -p $(PROJECT)

################################################################################

# Build 
build:	
	docker-compose $(DOCKER_COMPOSE_OPTIONS) build

# Rebuild 
build-no-cache:
	docker-compose $(DOCKER_COMPOSE_OPTIONS) build --no-cache

# Create containers, all modifications are lost
up:
	docker-compose $(DOCKER_COMPOSE_OPTIONS) up -d

create:
	make build
	make up

# Start containers
start:
	docker-compose $(DOCKER_COMPOSE_OPTIONS) start

# Stop containers
stop:
	docker-compose $(DOCKER_COMPOSE_OPTIONS) stop

# Go to console
cli:
	docker exec -it $(PROJECT)_cli_1 bash

# Connect to mysql console
mysql:
	docker exec -it $(PROJECT)_mysql_1 mysql -pe444tG7P4vpBMk

# Create a root user with large connexions capacities
mysql-create-root-for-all:
	docker exec -it $(PROJECT)_mysql_1 mysql -pe444tG7P4vpBMk -e \
	    "DELETE FROM mysql.user ; \
	    CREATE USER 'root'@'%' IDENTIFIED BY 'e444tG7P4vpBMk'; \
	    GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ; \
	    CREATE USER 'root'@'localhost' IDENTIFIED BY 'e444tG7P4vpBMk'; \
	    GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ; \
	    DROP DATABASE IF EXISTS test ;"
	'
	docker exec -it $(PROJECT)_mysql_1 mysql -pe444tG7P4vpBMk -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;'
	

clean:
	docker-compose $(DOCKER_COMPOSE_OPTIONS) stop
	docker rm $(shell docker ps -a | egrep $(PROJECT) | awk '{print $$1}' )

clean-all:
	docker-compose $(DOCKER_COMPOSE_OPTIONS) stop
	docker rm $(shell docker ps -a | egrep $(PROJECT) | awk '{print $$1}' )
	docker rmi $(shell docker images | egrep $(PROJECT) | awk '{print $$3}')	

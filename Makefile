SERVICE_NAME=base 
# TODO - Add the service name here - must be same in docker-compose.yml

build:
	docker-compose up --build -d --remove-orphans

down:
	docker-compose down

down-v:
	docker-compose down -v

up:
	docker-compose up -d

remove:
	docker-compose down -v
	docker-compose rm -f
	docker rmi $(SERVICE_NAME)
	

prune:
	docker image prune --force

# GIT functions

push-all:
	git add .
	git commit -m 'edits'
	git push origin -u main

push:
	git push origin -u main

commit:
	git add .
	git commit
	git push origin -u main
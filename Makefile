EDITOR=vim

all: regconfig build

build:
	docker build -t tableau-server .

run:
	docker-compose up -d

clean:
	docker ps -aq --no-trunc | xargs docker rm

exec:
	docker exec -ti `docker ps | grep tableau-server |head -1 | awk -e '{print $$1}'` /bin/bash


config/registration_file.json: 
	cp config/registration_file.json.templ config/registration_file.json
	$(EDITOR) config/registration_file.json

regconfig: config/registration_file.json

stop:
	docker stop `docker ps | grep tableau-server |head -1| awk -e '{print $$1}'`


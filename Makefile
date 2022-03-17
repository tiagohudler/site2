.PHONY: all start

all: .docker-build

start: .docker-build
	docker start site_eits 2> /dev/null || docker run -e NODE_ENV=production -d -p 127.0.0.1:3000:3000 --name site_eits site_eits

dev: .docker-build
	docker run -it -v ${CURDIR}/site:/srv/site -p 127.0.0.1:3000:3000 --name site_eits site_eits

stop:
	docker stop site_eits

remove: stop
	docker rm -v site_eits

.docker-build: site/ Dockerfile
	(docker images | tail -n +2 | awk '{print $1}' | sort | uniq | grep site_eits && docker rmi site_eits) || true
	docker build -t site_eits .
	touch $@

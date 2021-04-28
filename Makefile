VERSION := 1.0.0
-include local.mk

all: build push

build: 
	./build.sh $(EIDAS_BUILD_ARGS) --version $(VERSION) -i signservice-integration-rest --tag $(VERSION)

push:
	docker tag signservice-integration-rest:$(VERSION) docker.sunet.se/signservice-integration-rest:$(VERSION)
	docker push docker.sunet.se/signservice-integration-rest:$(VERSION)

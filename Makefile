PACK_CMD?=$(shell which pack)
ifeq ($(PACK_CMD),)
ifeq ($(GITHUB_TOKEN),)
	_PACK_VERSION=$(shell curl -s https://api.github.com/repos/buildpack/pack/releases/latest | jq -r '.tag_name' | sed -e 's/^v//')
else
	_PACK_VERSION=$(shell curl -s -H "Authorization: token $(GITHUB_TOKEN)" https://api.github.com/repos/buildpack/pack/releases/latest | jq -r '.tag_name' | sed -e 's/^v//')
endif
PACK_CMD=./out/pack
PACK_VERSION:=$(_PACK_VERSION)
endif

build: ./out/pack stacks builders apps

./out/pack:
	@echo "> Using pack binary '$(PACK_CMD)'"  
ifdef PACK_VERSION
	echo "> Downloading $(PACK_VERSION)"
	mkdir -p ./out/
	curl -s -L -o out/pack.tgz https://github.com/buildpack/pack/releases/download/v$(PACK_VERSION)/pack-v$(PACK_VERSION)-linux.tgz
	tar xvzf out/pack.tgz -C out/
endif

stacks:
	@echo "> Building 'bionic' stack..."
	./stacks/build-stack.sh stacks/bionic

builders: ./out/pack
	@echo "> Building 'bionic' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:bionic --builder-config builders/bionic/builder.toml

apps: ./out/pack
	@echo "> Creating 'java-maven' app using 'bionic' builder..."
	$(PACK_CMD) build sample-java-maven-app --builder cnbs/sample-builder:bionic --path apps/java-maven
	
	@echo "> Creating 'kotlin-gradle' app using 'bionic' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app --builder cnbs/sample-builder:bionic --path apps/kotlin-gradle
	
	@echo "> Creating 'ruby-bundler' app using 'bionic' builder..."
	$(PACK_CMD) build sample-ruby-bundler-app --builder cnbs/sample-builder:bionic --path apps/ruby-bundler

docker-login:
	@echo "> Logging in to docker hub..."
ifeq ($(DOCKER_USERNAME),)
	@echo "No docker login information provided. Expecting DOCKER_USERNAME and DOCKER_PASSWORD envars."
	exit 1
else
	@echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
endif 

deploy-stacks: docker-login
	docker push cnbs/sample-stack-base:bionic
	docker push cnbs/sample-stack-run:bionic
	docker push cnbs/sample-stack-build:bionic
	
deploy-builders:
	docker push cnbs/sample-builder:bionic
	
deploy: deploy-stacks deploy-builders

clean:
	rm -f ./out/*
	docker rmi cnbs/sample-stack-base:bionic || true
	docker rmi cnbs/sample-stack-run:bionic || true
	docker rmi cnbs/sample-stack-build:bionic || true
	docker rmi cnbs/sample-builder:bionic || true
	docker rmi sample-java-maven-app || true
	docker rmi sample-kotlin-gradle-app || true
	docker rmi sample-ruby-bundler-app || true
	
.PHONY: stacks builders apps cleanup
PACK_FLAGS?=--no-pull
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

build: ./out/pack build-stacks build-builders build-buildpacks

build-alpine: build-stack-alpine build-builder-alpine build-buildpacks-alpine

build-bionic: build-stack-bionic build-builder-bionic build-buildpacks-bionic

build-stacks: build-stack-alpine build-stack-bionic

build-stack-alpine:
	@echo "> Building 'alpine' stack..."
	./stacks/build-stack.sh stacks/alpine

build-stack-bionic:
	@echo "> Building 'bionic' stack..."
	./stacks/build-stack.sh stacks/bionic

build-builders: build-builder-alpine build-builder-bionic

build-builder-alpine: ./out/pack
	@echo "> Building 'alpine' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:alpine --builder-config builders/alpine/builder.toml $(PACK_FLAGS)

build-builder-bionic: ./out/pack
	@echo "> Building 'bionic' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:bionic --builder-config builders/bionic/builder.toml $(PACK_FLAGS)

build-buildpacks: build-buildpacks-alpine build-buildpacks-bionic

build-buildpacks-alpine: ./out/pack
	@echo "> Creating 'hello-moon' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-moon-app:alpine --builder cnbs/sample-builder:alpine --buildpack buildpacks/hello-world --buildpack buildpacks/hello-moon $(PACK_FLAGS)

	@echo "> Creating 'hello-world' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-world-app:alpine --builder cnbs/sample-builder:alpine --buildpack buildpacks/hello-world $(PACK_FLAGS)

	@echo "> Creating 'java-maven' app using 'alpine' builder..."
	$(PACK_CMD) build sample-java-maven-app:alpine --builder cnbs/sample-builder:alpine --path apps/java-maven $(PACK_FLAGS)
	
	@echo "> Creating 'kotlin-gradle' app using 'alpine' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:alpine --builder cnbs/sample-builder:alpine --path apps/kotlin-gradle $(PACK_FLAGS)
	
build-buildpacks-bionic: ./out/pack
	@echo "> Creating 'hello-moon' app using 'bionic' builder..."
	$(PACK_CMD) build sample-hello-moon-app:bionic --builder cnbs/sample-builder:bionic --buildpack buildpacks/hello-world --buildpack buildpacks/hello-moon $(PACK_FLAGS)

	@echo "> Creating 'hello-world' app using 'bionic' builder..."
	$(PACK_CMD) build sample-hello-world-app:bionic --builder cnbs/sample-builder:bionic --buildpack buildpacks/hello-world $(PACK_FLAGS)

	@echo "> Creating 'java-maven' app using 'bionic' builder..."
	$(PACK_CMD) build sample-java-maven-app:bionic --builder cnbs/sample-builder:bionic --path apps/java-maven $(PACK_FLAGS)
	
	@echo "> Creating 'kotlin-gradle' app using 'bionic' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:bionic --builder cnbs/sample-builder:bionic --path apps/kotlin-gradle $(PACK_FLAGS)
	
	@echo "> Creating 'ruby-bundler' app using 'bionic' builder..."
	$(PACK_CMD) build sample-ruby-bundler-app:bionic --builder cnbs/sample-builder:bionic --path apps/ruby-bundler $(PACK_FLAGS)

docker-login:
	@echo "> Logging in to docker hub..."
ifeq ($(DOCKER_USERNAME),)
	@echo "No docker login information provided. Expecting DOCKER_USERNAME and DOCKER_PASSWORD envars."
	exit 1
else
	@echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
endif 

deploy-stacks: docker-login
	docker push cnbs/sample-stack-base:alpine
	docker push cnbs/sample-stack-run:alpine
	docker push cnbs/sample-stack-build:alpine
	docker push cnbs/sample-stack-base:bionic
	docker push cnbs/sample-stack-run:bionic
	docker push cnbs/sample-stack-build:bionic
	
deploy-builders: docker-login
	docker push cnbs/sample-builder:alpine
	docker push cnbs/sample-builder:bionic
	
deploy: deploy-stacks deploy-builders

clean:
	rm -f ./out/*
	
	# alpine stack
	docker rmi cnbs/sample-stack-base:alpine || true
	docker rmi cnbs/sample-stack-run:alpine || true
	docker rmi cnbs/sample-stack-build:alpine || true
	
	# bionic stack
	docker rmi cnbs/sample-stack-base:bionic || true
	docker rmi cnbs/sample-stack-run:bionic || true
	docker rmi cnbs/sample-stack-build:bionic || true
	
	# builders
	docker rmi cnbs/sample-builder:alpine || true
	docker rmi cnbs/sample-builder:bionic || true
	
	# alpine apps
	docker rmi sample-hello-world-app:alpine || true
	docker rmi sample-hello-moon-app:alpine || true
	docker rmi sample-java-maven-app:alpine || true
	docker rmi sample-kotlin-gradle-app:alpine || true
	
	# bionic apps
	docker rmi sample-hello-world-app:bionic || true
	docker rmi sample-hello-moon-app:bionic || true
	docker rmi sample-java-maven-app:bionic || true
	docker rmi sample-kotlin-gradle-app:bionic || true
	docker rmi sample-ruby-bundler-app:bionic || true

./out/pack:
	@echo "> Using pack binary '$(PACK_CMD)'"  
ifdef PACK_VERSION
	echo "> Downloading $(PACK_VERSION)"
	mkdir -p ./out/
	curl -s -L -o out/pack.tgz https://github.com/buildpack/pack/releases/download/v$(PACK_VERSION)/pack-v$(PACK_VERSION)-linux.tgz
	tar xvzf out/pack.tgz -C out/
endif
GITHUB_TOKEN?=
PACK_CMD?=$(shell which pack)
ifeq ($(PACK_CMD),)
ifneq ($(GITHUB_TOKEN),)
	_PACK_VERSION=$(shell curl -s -H "Authorization: token $(GITHUB_TOKEN)" https://api.github.com/repos/buildpack/pack/releases/latest | jq -r '.tag_name' | sed -e 's/^v//')
else
	_PACK_VERSION=$(shell curl -s https://api.github.com/repos/buildpack/pack/releases/latest | jq -r '.tag_name' | sed -e 's/^v//')
endif
PACK_CMD=./out/pack
PACK_VERSION:=$(_PACK_VERSION)
endif

all: ./out/pack stacks builders apps

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

builders: ./out/pack stacks
	@echo "> Building 'bionic' builder..."
	$(PACK_CMD) create-builder sample-bionic-builder --builder-config builders/bionic/builder.toml

apps: ./out/pack builders
	@echo "> Creating 'java-maven' app using 'bionic' builder..."
	$(PACK_CMD) build sample-java-maven-app --builder sample-bionic-builder --path apps/java-maven
	
	@echo "> Creating 'kotlin-gradle' app using 'bionic' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app --builder sample-bionic-builder --path apps/kotlin-gradle
	
	@echo "> Creating 'ruby-bundler' app using 'bionic' builder..."
	$(PACK_CMD) build sample-ruby-bundler-app --builder sample-bionic-builder --path apps/ruby-bundler

clean:
	rm -f ./out/*
	docker rmi sample/stack-base || true
	docker rmi sample/stack-run || true
	docker rmi sample/stack-build || true
	docker rmi sample-bionic-builder || true
	docker rmi sample-java-maven-app || true
	docker rmi sample-kotlin-gradle-app || true
	docker rmi sample-ruby-bundler-app || true
	
.PHONY: stacks builders cleanup
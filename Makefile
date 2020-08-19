PACK_FLAGS?=--no-pull
PACK_BUILD_FLAGS?=--trust-builder
PACK_CMD?=pack

####################
## Linux
####################

build-linux: build-linux-stacks build-packages build-builders build-buildpacks

build-linux-stacks: build-stack-alpine build-stack-bionic

build-alpine: build-stack-alpine build-builder-alpine build-buildpacks-alpine

build-bionic: build-stack-bionic build-builder-bionic build-buildpacks-bionic

build-stack-alpine:
	@echo "> Building 'alpine' stack..."
	bash stacks/build-stack.sh stacks/alpine

build-stack-bionic:
	@echo "> Building 'bionic' stack..."
	bash stacks/build-stack.sh stacks/bionic

build-builders: build-builder-alpine build-builder-bionic

build-builder-alpine: build-packages
	@echo "> Building 'alpine' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:alpine --config builders/alpine/builder.toml $(PACK_FLAGS)

build-builder-bionic: build-packages
	@echo "> Building 'bionic' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:bionic --config builders/bionic/builder.toml $(PACK_FLAGS)

build-buildpacks: build-buildpacks-alpine build-buildpacks-bionic

build-buildpacks-alpine:
	@echo "> Creating 'hello-moon' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-moon-app:alpine --builder cnbs/sample-builder:alpine --buildpack buildpacks/hello-world --buildpack buildpacks/hello-moon $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-processes' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-processes-app:alpine --builder cnbs/sample-builder:alpine --buildpack buildpacks/hello-processes $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-world-app:alpine --builder cnbs/sample-builder:alpine --buildpack buildpacks/hello-world $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'java-maven' app using 'alpine' builder..."
	$(PACK_CMD) build sample-java-maven-app:alpine --builder cnbs/sample-builder:alpine --path apps/java-maven $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'kotlin-gradle' app using 'alpine' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:alpine --builder cnbs/sample-builder:alpine --path apps/kotlin-gradle $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

build-buildpacks-bionic:
	@echo "> Creating 'hello-moon' app using 'bionic' builder..."
	$(PACK_CMD) build sample-hello-moon-app:bionic --builder cnbs/sample-builder:bionic --buildpack buildpacks/hello-world --buildpack buildpacks/hello-moon $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-processes' app using 'bionic' builder..."
	$(PACK_CMD) build sample-hello-processes-app:bionic --builder cnbs/sample-builder:bionic --buildpack buildpacks/hello-processes $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world' app using 'bionic' builder..."
	$(PACK_CMD) build sample-hello-world-app:bionic --builder cnbs/sample-builder:bionic --buildpack buildpacks/hello-world $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'java-maven' app using 'bionic' builder..."
	$(PACK_CMD) build sample-java-maven-app:bionic --builder cnbs/sample-builder:bionic --path apps/java-maven $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'kotlin-gradle' app using 'bionic' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:bionic --builder cnbs/sample-builder:bionic --path apps/kotlin-gradle $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'ruby-bundler' app using 'bionic' builder..."
	$(PACK_CMD) build sample-ruby-bundler-app:bionic --builder cnbs/sample-builder:bionic --path apps/ruby-bundler $(PACK_FLAGS) $(PACK_BUILD_FLAGS)

build-packages:
	@echo "> Creating 'hello-world' buildpack package"
	$(PACK_CMD) package-buildpack cnbs/sample-package:hello-world --config packages/hello-world/package.toml $(PACK_FLAGS)

	@echo "> Creating 'hello-universe' buildpack package"
	$(PACK_CMD) package-buildpack cnbs/sample-package:hello-universe --config packages/hello-universe/package.toml $(PACK_FLAGS)

deploy-linux: deploy-linux-stacks deploy-packages deploy-builders

deploy-linux-stacks:
	@echo "> Deploying 'alpine' stack..."
	docker push cnbs/sample-stack-base:alpine
	docker push cnbs/sample-stack-run:alpine
	docker push cnbs/sample-stack-build:alpine

	@echo "> Deploying 'bionic' stack..."
	docker push cnbs/sample-stack-base:bionic
	docker push cnbs/sample-stack-run:bionic
	docker push cnbs/sample-stack-build:bionic

deploy-packages:
	@echo "> Deploying packages..."
	docker push cnbs/sample-package:hello-world
	docker push cnbs/sample-package:hello-universe

deploy-builders:
	@echo "> Deploying 'alpine' builder..."
	docker push cnbs/sample-builder:alpine

	@echo "> Deploying 'bionic' builder..."
	docker push cnbs/sample-builder:bionic

clean-linux:
	@echo "> Removing 'alpine' stack..."
	docker rmi cnbs/sample-stack-base:alpine || true
	docker rmi cnbs/sample-stack-run:alpine || true
	docker rmi cnbs/sample-stack-build:alpine || true

	@echo "> Removing 'bionic' stack..."
	docker rmi cnbs/sample-stack-base:bionic || true
	docker rmi cnbs/sample-stack-run:bionic || true
	docker rmi cnbs/sample-stack-build:bionic || true

	@echo "> Removing builders..."
	docker rmi cnbs/sample-builder:alpine || true
	docker rmi cnbs/sample-builder:bionic || true

	@echo "> Removing 'alpine' apps..."
	docker rmi sample-hello-moon-app:alpine || true
	docker rmi sample-hello-processes-app:alpine || true
	docker rmi sample-hello-world-app:alpine || true
	docker rmi sample-java-maven-app:alpine || true
	docker rmi sample-kotlin-gradle-app:alpine || true

	@echo "> Removing 'bionic' apps..."
	docker rmi sample-hello-moon-app:bionic || true
	docker rmi sample-hello-processes-app:bionic || true
	docker rmi sample-hello-world-app:bionic || true
	docker rmi sample-java-maven-app:bionic || true
	docker rmi sample-kotlin-gradle-app:bionic || true
	docker rmi sample-ruby-bundler-app:bionic || true

	@echo "> Removing packages..."
	docker rmi cnbs/sample-package:hello-universe || true

####################
## Windows
####################

build-windows: build-windows-stacks

build-windows-stacks: build-stack-nanoserver-1809

build-stack-nanoserver-1809:
	@echo "> Building 'nanoserver-1809' stack..."
	bash stacks/build-stack.sh stacks/nanoserver-1809

deploy-windows: deploy-windows-stacks

deploy-windows-stacks:
	@echo "> Deploying 'nanoserver-1809' stack..."
	docker push cnbs/sample-stack-base:nanoserver-1809
	docker push cnbs/sample-stack-run:nanoserver-1809
	docker push cnbs/sample-stack-build:nanoserver-1809

clean-windows:
	@echo "> Removing 'nanoserver-1809' stack..."
	docker rmi cnbs/sample-stack-base:nanoserver-1809
	docker rmi cnbs/sample-stack-run:nanoserver-1809
	docker rmi cnbs/sample-stack-build:nanoserver-1809

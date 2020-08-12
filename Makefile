PACK_FLAGS?=--pull-policy=never
PACK_BUILD_FLAGS?=--trust-builder
PACK_CMD?=pack

####################
## Linux
####################

build-linux: build-linux-stacks build-linux-packages build-linux-builders build-linux-buildpacks

build-linux-stacks: build-stack-alpine build-stack-bionic

build-alpine: build-stack-alpine build-builder-alpine build-buildpacks-alpine

build-bionic: build-stack-bionic build-builder-bionic build-buildpacks-bionic

build-stack-alpine:
	@echo "> Building 'alpine' stack..."
	bash stacks/build-stack.sh stacks/alpine

build-stack-bionic:
	@echo "> Building 'bionic' stack..."
	bash stacks/build-stack.sh stacks/bionic

build-linux-builders: build-builder-alpine build-builder-bionic

build-builder-alpine: build-linux-packages
	@echo "> Building 'alpine' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:alpine --config builders/alpine/builder.toml $(PACK_FLAGS)

build-builder-bionic: build-linux-packages
	@echo "> Building 'bionic' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:bionic --config builders/bionic/builder.toml $(PACK_FLAGS)

build-linux-buildpacks: build-buildpacks-alpine build-buildpacks-bionic

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

build-linux-packages:
	@echo "> Creating 'hello-world' buildpack package"
	$(PACK_CMD) package-buildpack cnbs/sample-package:hello-world --config packages/hello-world/package.toml $(PACK_FLAGS)

	@echo "> Creating 'hello-universe' buildpack package"
	$(PACK_CMD) package-buildpack cnbs/sample-package:hello-universe --config packages/hello-universe/package.toml $(PACK_FLAGS)

deploy-linux: deploy-linux-stacks deploy-linux-packages deploy-linux-builders

deploy-linux-stacks:
	@echo "> Deploying 'alpine' stack..."
	docker push cnbs/sample-stack-base:alpine
	docker push cnbs/sample-stack-run:alpine
	docker push cnbs/sample-stack-build:alpine

	@echo "> Deploying 'bionic' stack..."
	docker push cnbs/sample-stack-base:bionic
	docker push cnbs/sample-stack-run:bionic
	docker push cnbs/sample-stack-build:bionic

deploy-linux-packages:
	@echo "> Deploying linux packages..."
	docker push cnbs/sample-package:hello-world
	docker push cnbs/sample-package:hello-universe

deploy-linux-builders:
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

build-windows: build-windows-stacks build-windows-builders build-windows-buildpacks # build-windows-packages: not yet supported

build-nanoserver-1809: build-stack-nanoserver-1809 build-builder-nanoserver-1809 build-buildpacks-nanoserver-1809

build-windows-stacks: build-stack-nanoserver-1809

build-stack-nanoserver-1809:
	@echo "> Building 'nanoserver-1809' stack..."
	bash stacks/build-stack.sh stacks/nanoserver-1809

build-windows-builders: build-builder-nanoserver-1809

build-builder-nanoserver-1809: # build-windows-packages: not yet supported
	@echo "> Building 'nanoserver-1809' builder..."
# When pack.exe, replace directory-based buildpack with tgz in temporary builder.toml
ifeq ($(OS),Windows_NT)
	mkdir -p tmp
	tar -czf tmp/hello-world-windows.tgz -C buildpacks/hello-world-windows .
	sed "s|../../buildpacks/hello-world-windows|hello-world-windows.tgz|" builders/nanoserver-1809/builder.toml > tmp/builder.toml
	$(PACK_CMD) create-builder cnbs/sample-builder:nanoserver-1809 --config tmp/builder.toml $(PACK_FLAGS)
	rm -rf tmp
else
	$(PACK_CMD) create-builder cnbs/sample-builder:nanoserver-1809 --config builders/nanoserver-1809/builder.toml $(PACK_FLAGS)
endif

build-windows-buildpacks: build-buildpacks-nanoserver-1809

build-buildpacks-nanoserver-1809:
	@echo "> Creating 'hello-world-windows' app using 'nanoserver-1809' builder..."
# When pack.exe, replace directory-based buildpack with tgz
ifeq ($(OS),Windows_NT)
	mkdir -p tmp
	tar -czf tmp/hello-world-windows.tgz -C buildpacks/hello-world-windows .
	$(PACK_CMD) build sample-hello-world-windows-app:nanoserver-1809 --builder cnbs/sample-builder:nanoserver-1809 --buildpack tmp/hello-world-windows.tgz $(PACK_FLAGS) $(PACK_BUILD_FLAGS)
	rm -rf tmp
else
	$(PACK_CMD) build sample-hello-world-windows-app:nanoserver-1809 --builder cnbs/sample-builder:nanoserver-1809 --buildpack buildpacks/hello-world-windows $(PACK_FLAGS) $(PACK_BUILD_FLAGS)
endif

build-windows-apps:
	@echo "> Creating 'batch-script' app using 'nanoserver-1809' builder..."
# When pack.exe, replace directory-based buildpack with tgz
ifeq ($(OS),Windows_NT)
	mkdir -p tmp
	tar -czf tmp/hello-world-windows.tgz -C buildpacks/hello-world-windows .
	sed "s|batch-script-buildpack/|batch-script-buildpack.tgz|" apps/batch-script/project.toml > tmp/project.toml
	tar -czf tmp/batch-script-buildpack.tgz -C apps/batch-script/batch-script-buildpack/ .
	$(PACK_CMD) build sample-batch-script-app:nanoserver-1809 --builder cnbs/sample-builder:nanoserver-1809 --descriptor tmp/project.toml --path apps/batch-script $(PACK_FLAGS) $(PACK_BUILD_FLAGS)
	rm -rf tmp
else
	$(PACK_CMD) build sample-batch-script-app:nanoserver-1809 --builder cnbs/sample-builder:nanoserver-1809 $(PACK_FLAGS) $(PACK_BUILD_FLAGS)
endif

build-buildpacks-nanoserver-1809-on-posix:
	@echo "> Creating 'hello-world-windows' app using 'nanoserver-1809' builder..."
	$(PACK_CMD) build sample-hello-world-windows-app:nanoserver-1809 --builder cnbs/sample-builder:nanoserver-1809 --buildpack tmp/hello-world-windows.tgz $(PACK_FLAGS) $(PACK_BUILD_FLAGS)
	rm -rf tmp

deploy-windows: deploy-windows-stacks deploy-windows-builders # deploy-windows-packages: not yet supported

deploy-windows-stacks:
	@echo "> Deploying 'nanoserver-1809' stack..."
	docker push cnbs/sample-stack-base:nanoserver-1809
	docker push cnbs/sample-stack-run:nanoserver-1809
	docker push cnbs/sample-stack-build:nanoserver-1809

deploy-windows-builders:
	@echo "> Deploying 'alpine' builder..."
	docker push cnbs/sample-builder:nanoserver-1809

clean-windows:
	@echo "> Removing 'nanoserver-1809' stack..."
	docker rmi cnbs/sample-stack-base:nanoserver-1809 || true
	docker rmi cnbs/sample-stack-run:nanoserver-1809 || true
	docker rmi cnbs/sample-stack-build:nanoserver-1809 || true

	@echo "> Removing builders..."
	docker rmi cnbs/sample-builder:nanoserver-1809 || true

	@echo "> Removing 'nanoserver-1809' apps..."
	docker rmi sample-hello-world-windows-app:nanoserver-1809 || true
	docker rmi sample-batch-script-app:nanoserver-1809 || true

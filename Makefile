PULL_POLICY_NEVER?=--pull-policy=never
PACK_BUILD_FLAGS?=--trust-builder
PACK_CMD?=pack

clean: clean-linux clean-windows

####################
## Linux
####################

build-linux: build-linux-bases build-linux-packages build-linux-builders build-linux-buildpacks

build-linux-bases: build-base-alpine build-base-jammy

build-alpine: build-base-alpine build-builder-alpine build-buildpacks-alpine

build-jammy: build-base-jammy build-builder-jammy build-buildpacks-jammy

build-base-alpine:
	@echo "> Building 'alpine' base images..."
	${PACK_CMD} config experimental true
	bash base-images/build.sh alpine

build-base-jammy:
	@echo "> Building 'jammy' base images..."
	${PACK_CMD} config experimental true
	bash base-images/build.sh jammy

build-linux-builders: build-builder-alpine build-builder-jammy

build-builder-alpine: build-linux-packages build-sample-root
	@echo "> Building 'alpine' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:alpine --config $(SAMPLES_ROOT)/builders/alpine/builder.toml $(PULL_POLICY_NEVER)

build-builder-jammy: build-linux-packages build-sample-root
	@echo "> Building 'jammy' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:jammy --config $(SAMPLES_ROOT)/builders/jammy/builder.toml $(PULL_POLICY_NEVER)

build-linux-buildpacks: build-buildpacks-alpine build-buildpacks-jammy

build-buildpacks-alpine: build-sample-root
	@echo "> Starting local registry to store alpine builder (when builder contains extensions it must exist in a registry so that builds can use --pull-policy=always and we don't want to override the locally built builder)"
	docker run -d --rm -p 5000:5000 registry:2
	sleep 2
	docker tag cnbs/sample-builder:alpine localhost:5000/cnbs/sample-builder:alpine
	docker push localhost:5000/cnbs/sample-builder:alpine

	@echo "> Creating 'hello-moon' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-moon-app:alpine -v --builder localhost:5000/cnbs/sample-builder:alpine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world --buildpack $(SAMPLES_ROOT)/buildpacks/hello-moon --network=host

	@echo "> Creating 'hello-processes' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-processes-app:alpine -v --builder localhost:5000/cnbs/sample-builder:alpine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-processes --network=host

	@echo "> Creating 'hello-world' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-world-app:alpine -v --builder localhost:5000/cnbs/sample-builder:alpine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world --network=host

	@echo "> Creating 'java-maven' app using 'alpine' builder..."
	$(PACK_CMD) build sample-java-maven-app:alpine -v --builder localhost:5000/cnbs/sample-builder:alpine --path apps/java-maven --network=host

	@echo "> Creating 'kotlin-gradle' app using 'alpine' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:alpine -v --builder localhost:5000/cnbs/sample-builder:alpine --path apps/kotlin-gradle --network=host

build-buildpacks-jammy: build-sample-root
	@echo "> Creating 'hello-moon' app using 'jammy' builder..."
	$(PACK_CMD) build sample-hello-moon-app:jammy -v --builder cnbs/sample-builder:jammy --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world --buildpack $(SAMPLES_ROOT)/buildpacks/hello-moon $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-processes' app using 'jammy' builder..."
	$(PACK_CMD) build sample-hello-processes-app:jammy -v --builder cnbs/sample-builder:jammy --buildpack $(SAMPLES_ROOT)/buildpacks/hello-processes $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world' app using 'jammy' builder..."
	$(PACK_CMD) build sample-hello-world-app:jammy -v --builder cnbs/sample-builder:jammy --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'java-maven' app using 'jammy' builder..."
	$(PACK_CMD) build sample-java-maven-app:jammy -v --builder cnbs/sample-builder:jammy --path apps/java-maven $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'kotlin-gradle' app using 'jammy' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:jammy -v --builder cnbs/sample-builder:jammy --path apps/kotlin-gradle $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'ruby-bundler' app using 'jammy' builder..."
	$(PACK_CMD) build sample-ruby-bundler-app:jammy -v --builder cnbs/sample-builder:jammy --path apps/ruby-bundler $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-linux-packages: build-sample-root
	@echo "> Creating 'hello-world' buildpack package"
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-world --config $(SAMPLES_ROOT)/$(PACKAGES_DIR)/hello-world/package.toml $(PULL_POLICY_NEVER)

	@echo "> Creating 'hello-universe' buildpack package"
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-universe --config $(SAMPLES_ROOT)/$(PACKAGES_DIR)/hello-universe/package.toml $(PULL_POLICY_NEVER)

deploy-linux: deploy-linux-bases deploy-linux-packages deploy-linux-builders

deploy-linux-bases:
	@echo "> Deploying 'alpine' base images..."
	docker push cnbs/sample-base:alpine
	docker push cnbs/sample-base-run:alpine
	docker push cnbs/sample-base-build:alpine

	@echo "> Deploying 'jammy' base images..."
	docker push cnbs/sample-base:jammy
	docker push cnbs/sample-base-run:jammy
	docker push cnbs/sample-base-build:jammy

deploy-linux-packages:
	@echo "> Deploying linux packages..."
	docker push cnbs/sample-package:hello-world
	docker push cnbs/sample-package:hello-universe

deploy-linux-builders:
	@echo "> Deploying 'alpine' builder..."
	docker run cnbs/sample-builder:alpine ls /cnb/extensions/samples_curl || true
	docker push cnbs/sample-builder:alpine

	@echo "> Deploying 'jammy' builder..."
	docker push cnbs/sample-builder:jammy

clean-linux:
	@echo "> Removing 'alpine' base images..."
	docker rmi cnbs/sample-base:alpine || true
	docker rmi cnbs/sample-base-run:alpine || true
	docker rmi cnbs/sample-base-build:alpine || true

	@echo "> Removing 'jammy' base images..."
	docker rmi cnbs/sample-base:jammy || true
	docker rmi cnbs/sample-base-run:jammy || true
	docker rmi cnbs/sample-base-build:jammy || true

	@echo "> Removing builders..."
	docker rmi cnbs/sample-builder:alpine || true
	docker rmi cnbs/sample-builder:jammy || true

	@echo "> Removing 'alpine' apps..."
	docker rmi sample-hello-moon-app:alpine || true
	docker rmi sample-hello-processes-app:alpine || true
	docker rmi sample-hello-world-app:alpine || true
	docker rmi sample-java-maven-app:alpine || true
	docker rmi sample-kotlin-gradle-app:alpine || true

	@echo "> Removing 'jammy' apps..."
	docker rmi sample-hello-moon-app:jammy || true
	docker rmi sample-hello-processes-app:jammy || true
	docker rmi sample-hello-world-app:jammy || true
	docker rmi sample-java-maven-app:jammy || true
	docker rmi sample-kotlin-gradle-app:jammy || true
	docker rmi sample-ruby-bundler-app:jammy || true

	@echo "> Removing packages..."
	docker rmi cnbs/sample-package:hello-world || true
	docker rmi cnbs/sample-package:hello-universe || true

	@echo "> Removing '.tmp'"
	rm -rf .tmp

set-experimental:
	@echo "> Setting experimental"
	$(PACK_CMD) config experimental true

####################
## Windows
####################

build-windows-2022: build-windows-packages build-dotnet-framework-2022 build-nanoserver-2022

build-nanoserver-2022: build-base-nanoserver-2022 build-builder-nanoserver-2022 build-buildpacks-nanoserver-2022

build-dotnet-framework-2022: build-base-dotnet-framework-2022 build-builder-dotnet-framework-2022 build-buildpacks-dotnet-framework-2022

build-base-nanoserver-2022:
	@echo "> Building 'nanoserver-2022' base images..."
	bash base-images/build.sh nanoserver-2022

build-base-dotnet-framework-2022:
	@echo "> Building 'dotnet-framework-2022' base images..."
	bash base-images/build.sh dotnet-framework-2022

build-builder-nanoserver-2022: build-windows-packages
	@echo "> Building 'nanoserver-2022' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:nanoserver-2022 --config $(SAMPLES_ROOT)/builders/nanoserver-2022/builder.toml $(PULL_POLICY_NEVER)

build-builder-dotnet-framework-2022: build-windows-packages
	@echo "> Building 'dotnet-framework-2022' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:dotnet-framework-2022 --config $(SAMPLES_ROOT)/builders/dotnet-framework-2022/builder.toml $(PULL_POLICY_NEVER)

build-buildpacks-nanoserver-2022: build-sample-root
	@echo "> Creating 'hello-moon-windows' app using 'nanoserver-2022' builder..."
	$(PACK_CMD) build sample-hello-moon-windows-app:nanoserver-2022 -v --builder cnbs/sample-builder:nanoserver-2022 --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world-windows --buildpack $(SAMPLES_ROOT)/buildpacks/hello-moon-windows $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world-windows' app using 'nanoserver-2022' builder..."
	$(PACK_CMD) build sample-hello-world-windows-app:nanoserver-2022 -v --builder cnbs/sample-builder:nanoserver-2022 --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world-windows $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-buildpacks-dotnet-framework-2022: build-sample-root
	@echo "> Creating 'dotnet-framework' app using 'dotnet-framework-2022' builder..."
	$(PACK_CMD) build sample-dotnet-framework-app:dotnet-framework-2022 -v --builder cnbs/sample-builder:dotnet-framework-2022 --buildpack $(SAMPLES_ROOT)/buildpacks/dotnet-framework --path apps/aspnet $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-windows-packages: build-sample-root
	@echo "> Creating 'hello-world-windows' buildpack package"
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-world-windows --config $(SAMPLES_ROOT)/$(PACKAGES_DIR)/hello-world-windows/package.toml $(PULL_POLICY_NEVER)

	@echo "> Creating 'hello-universe-windows' buildpack package"
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-universe-windows --config $(SAMPLES_ROOT)/$(PACKAGES_DIR)/hello-universe-windows/package.toml $(PULL_POLICY_NEVER)

deploy-windows-packages:
	@echo "> Deploying windows packages..."
	docker push cnbs/sample-package:hello-world-windows
	docker push cnbs/sample-package:hello-universe-windows

deploy-windows-2022: deploy-windows-bases-2022 deploy-windows-builders-2022

deploy-windows-bases-2022: deploy-windows-bases-dotnet-framework-2022 deploy-windows-bases-nanoserver-2022

deploy-windows-bases-nanoserver-2022:
	@echo "> Deploying 'nanoserver-2022' base images..."
	docker push cnbs/sample-base:nanoserver-2022
	docker push cnbs/sample-base-run:nanoserver-2022
	docker push cnbs/sample-base-build:nanoserver-2022

deploy-windows-bases-dotnet-framework-2022:
	@echo "> Deploying 'dotnet-framework-2022' base images..."
	docker push cnbs/sample-base-run:dotnet-framework-2022
	docker push cnbs/sample-base-build:dotnet-framework-2022

deploy-windows-builders-2022: deploy-windows-builders-dotnet-framework-2022 deploy-windows-builders-nanoserver-2022

deploy-windows-builders-nanoserver-2022:
	@echo "> Deploying 'nanoserver-2022' builder..."
	docker push cnbs/sample-builder:nanoserver-2022

deploy-windows-builders-dotnet-framework-2022:
	@echo "> Deploying 'dotnet-framework-2022' builder..."
	docker push cnbs/sample-builder:dotnet-framework-2022

clean-windows:
	@echo "> Removing 'nanoserver-2022' base images..."
	docker rmi cnbs/sample-base:nanoserver-2022 || true
	docker rmi cnbs/sample-base-run:nanoserver-2022 || true
	docker rmi cnbs/sample-base-build:nanoserver-2022 || true

	@echo "> Removing 'dotnet-framework-2022' base images..."
	docker rmi cnbs/sample-base-run:dotnet-framework-2022 || true
	docker rmi cnbs/sample-base-build:dotnet-framework-2022 || true

	@echo "> Removing builders..."
	docker rmi cnbs/sample-builder:nanoserver-2022 || true
	docker rmi cnbs/sample-builder:dotnet-framework-2022 || true

	@echo "> Removing 'nanoserver-2022' apps..."
	docker rmi sample-hello-moon-windows-app:nanoserver-2022 || true
	docker rmi sample-hello-world-windows-app:nanoserver-2022 || true
	docker rmi sample-batch-script-app:nanoserver-2022 || true

	@echo "> Removing 'dotnet-framework-2022' apps..."
	docker rmi sample-aspnet-app:dotnet-framework-2022 || true

	@echo "> Removing packages..."
	docker rmi cnbs/sample-package:hello-world-windows || true
	docker rmi cnbs/sample-package:hello-universe-windows || true

	@echo "> Removing '.tmp'"
	rm -rf .tmp

####################
## Windows pack for any daemon OS
####################

# pack on Windows does not support directory-based buildpacks
# workaround by pivoting samples-root to tmp path with tgz-buildpacks of the same name
ifeq ($(OS),Windows_NT)
SAMPLES_ROOT:=$(shell mkdir -p .tmp && mktemp --directory -p . .tmp/samples-XXX)
PACKAGES_DIR:=packages
build-sample-root:
	@mkdir -p $(SAMPLES_ROOT)/buildpacks/

	@for bp_dir in ./buildpacks/*/; do \
		tar -czf $(SAMPLES_ROOT)/buildpacks/$$(basename $$bp_dir) -C $$bp_dir . ; \
	done

	@cp -r builders $(SAMPLES_ROOT)/
	@cp -r buildpacks $(SAMPLES_ROOT)/$(PACKAGES_DIR)
else
# No-op for posix pack
SAMPLES_ROOT:=.
PACKAGES_DIR:=buildpacks
build-sample-root:
endif


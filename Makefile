PULL_POLICY_NEVER?=--pull-policy=never
PACK_BUILD_FLAGS?=--trust-builder
PACK_CMD?=pack

clean: clean-linux clean-windows

####################
## Linux
####################

build-linux: build-linux-stacks build-linux-packages build-linux-builders build-linux-buildpacks

build-linux-stacks: build-stack-alpine build-stack-jammy

build-alpine: build-stack-alpine build-builder-alpine build-buildpacks-alpine

build-jammy: build-stack-jammy build-builder-jammy build-buildpacks-jammy

build-stack-alpine:
	@echo "> Building 'alpine' stack..."
	bash stacks/build-stack.sh stacks/alpine

build-stack-jammy:
	@echo "> Building 'jammy' stack..."
	bash stacks/build-stack.sh stacks/jammy

build-linux-builders: build-builder-alpine build-builder-jammy

build-builder-alpine: build-linux-packages build-sample-root
	@echo "> Building 'alpine' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:alpine --config $(SAMPLES_ROOT)/builders/alpine/builder.toml $(PULL_POLICY_NEVER)
	docker run cnbs/sample-builder:alpine ls /cnb/extensions/samples_curl
	docker run cnbs/sample-builder:alpine cat /cnb/order.toml

build-builder-jammy: build-linux-packages build-sample-root
	@echo "> Building 'jammy' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:jammy --config $(SAMPLES_ROOT)/builders/jammy/builder.toml $(PULL_POLICY_NEVER)

build-linux-buildpacks: build-buildpacks-alpine build-buildpacks-jammy

build-buildpacks-alpine: build-sample-root
	@echo "> Creating 'hello-moon' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-moon-app:alpine -v --builder cnbs/sample-builder:alpine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world --buildpack $(SAMPLES_ROOT)/buildpacks/hello-moon $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-processes' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-processes-app:alpine -v --builder cnbs/sample-builder:alpine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-processes $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world' app using 'alpine' builder..."
	$(PACK_CMD) build sample-hello-world-app:alpine -v --builder cnbs/sample-builder:alpine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world $(PACK_BUILD_FLAGS)

	@echo "> Creating 'java-maven' app using 'alpine' builder..."
	$(PACK_CMD) build sample-java-maven-app:alpine -v --builder cnbs/sample-builder:alpine --path apps/java-maven $(PACK_BUILD_FLAGS)

	@echo "> Creating 'kotlin-gradle' app using 'alpine' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:alpine -v --builder cnbs/sample-builder:alpine --path apps/kotlin-gradle $(PACK_BUILD_FLAGS)

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
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-world --config $(SAMPLES_ROOT)/packages/hello-world/package.toml $(PULL_POLICY_NEVER)

	@echo "> Creating 'hello-universe' buildpack package"
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-universe --config $(SAMPLES_ROOT)/packages/hello-universe/package.toml $(PULL_POLICY_NEVER)

deploy-linux: deploy-linux-stacks deploy-linux-packages deploy-linux-builders

deploy-linux-stacks:
	@echo "> Deploying 'alpine' stack..."
	docker push cnbs/sample-stack-base:alpine
	docker push cnbs/sample-stack-run:alpine
	docker push cnbs/sample-stack-build:alpine

	@echo "> Deploying 'jammy' stack..."
	docker push cnbs/sample-stack-base:jammy
	docker push cnbs/sample-stack-run:jammy
	docker push cnbs/sample-stack-build:jammy

deploy-linux-packages:
	@echo "> Deploying linux packages..."
	docker push cnbs/sample-package:hello-world
	docker push cnbs/sample-package:hello-universe

deploy-linux-builders:
	@echo "> Deploying 'alpine' builder..."
	docker run cnbs/sample-builder:alpine ls /cnb/extensions/samples_curl
	docker run cnbs/sample-builder:alpine cat /cnb/order.toml
	docker push cnbs/sample-builder:alpine

	@echo "> Deploying 'jammy' builder..."
	docker push cnbs/sample-builder:jammy

clean-linux:
	@echo "> Removing 'alpine' stack..."
	docker rmi cnbs/sample-stack-base:alpine || true
	docker rmi cnbs/sample-stack-run:alpine || true
	docker rmi cnbs/sample-stack-build:alpine || true

	@echo "> Removing 'jammy' stack..."
	docker rmi cnbs/sample-stack-base:jammy || true
	docker rmi cnbs/sample-stack-run:jammy || true
	docker rmi cnbs/sample-stack-build:jammy || true

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
## Wine
####################

build-wine: build-stack-wine build-builder-wine build-buildpacks-wine

build-stack-wine:
	@echo "> Building 'wine' stack..."
	bash stacks/build-stack.sh stacks/wine

build-builder-wine: build-sample-root
	@echo "> Building 'wine' builder..."
	$(PACK_CMD) create-builder cnbs/sample-builder:wine --config $(SAMPLES_ROOT)/builders/wine/builder.toml $(PULL_POLICY_NEVER)

build-wine-apps: build-sample-root
	@echo "> Creating 'batch-script' app using 'wine' builder..."
	$(PACK_CMD) build sample-batch-script-app:wine -v --builder cnbs/sample-builder:wine --path apps/batch-script $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-buildpacks-wine: build-sample-root
	@echo "> Creating 'hello-moon-windows' app using 'wine' builder..."
	$(PACK_CMD) build sample-hello-moon-windows-app:wine -v --builder cnbs/sample-builder:wine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world-windows --buildpack $(SAMPLES_ROOT)/buildpacks/hello-moon-windows $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world-windows' app using 'wine' builder..."
	$(PACK_CMD) build sample-hello-world-windows-app:wine -v --builder cnbs/sample-builder:wine --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world-windows $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

deploy-wine: deploy-wine-stacks deploy-wine-builders

deploy-wine-stacks:
	@echo "> Deploying 'wine' stack..."
	docker push cnbs/sample-stack-run:wine
	docker push cnbs/sample-stack-build:wine

deploy-wine-builders:
	@echo "> Deploying 'wine' builder..."
	docker push cnbs/sample-builder:wine

clean-wine:
	@echo "> Removing 'wine' stack..."
	docker rmi cnbs/sample-stack-base:wine || true
	docker rmi cnbs/sample-stack-run:wine || true
	docker rmi cnbs/sample-stack-build:wine || true

	@echo "> Removing builders..."
	docker rmi cnbs/sample-builder:wine || true

	@echo "> Removing 'wine' apps..."
	docker rmi sample-hello-moon-windows-app:wine || true
	docker rmi sample-hello-world-windows-app:wine || true
	docker rmi sample-batch-script-app:wine || true

	@echo "> Removing '.tmp'"
	rm -rf .tmp

####################
## Windows
####################

build-windows-1809: build-windows-packages build-nanoserver-1809 build-dotnet-framework-1809

build-windows-2004: build-windows-packages build-dotnet-framework-2004

build-windows-2022: build-windows-packages build-dotnet-framework-2022

build-nanoserver-1809: build-stack-nanoserver-1809 build-builder-nanoserver-1809 build-buildpacks-nanoserver-1809

build-dotnet-framework-1809: build-stack-dotnet-framework-1809 build-builder-dotnet-framework-1809 build-buildpacks-dotnet-framework-1809

build-dotnet-framework-2004: build-stack-dotnet-framework-2004 build-builder-dotnet-framework-2004 build-buildpacks-dotnet-framework-2004

build-dotnet-framework-2022: build-stack-dotnet-framework-2022 build-builder-dotnet-framework-2022 build-buildpacks-dotnet-framework-2022

build-stack-nanoserver-1809:
	@echo "> Building 'nanoserver-1809' stack..."
	bash stacks/build-stack.sh stacks/nanoserver-1809

build-stack-dotnet-framework-1809:
	@echo "> Building 'dotnet-framework-1809' stack..."
	bash stacks/build-stack.sh stacks/dotnet-framework-1809

build-stack-dotnet-framework-2004:
	@echo "> Building 'dotnet-framework-2004' stack..."
	bash stacks/build-stack.sh stacks/dotnet-framework-2004

build-stack-dotnet-framework-2022:
	@echo "> Building 'dotnet-framework-2022' stack..."
	bash stacks/build-stack.sh stacks/dotnet-framework-2022

build-builder-nanoserver-1809: build-windows-packages
	@echo "> Building 'nanoserver-1809' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:nanoserver-1809 --config $(SAMPLES_ROOT)/builders/nanoserver-1809/builder.toml $(PULL_POLICY_NEVER)

build-builder-dotnet-framework-1809: build-windows-packages
	@echo "> Building 'dotnet-framework-1809' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:dotnet-framework-1809 --config $(SAMPLES_ROOT)/builders/dotnet-framework-1809/builder.toml $(PULL_POLICY_NEVER)

build-builder-dotnet-framework-2004: build-windows-packages
	@echo "> Building 'dotnet-framework-2004' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:dotnet-framework-2004 --config $(SAMPLES_ROOT)/builders/dotnet-framework-2004/builder.toml $(PULL_POLICY_NEVER)

build-builder-dotnet-framework-2022: build-windows-packages
	@echo "> Building 'dotnet-framework-2022' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:dotnet-framework-2022 --config $(SAMPLES_ROOT)/builders/dotnet-framework-2022/builder.toml $(PULL_POLICY_NEVER)

build-buildpacks-nanoserver-1809: build-sample-root
	@echo "> Creating 'hello-moon-windows' app using 'nanoserver-1809' builder..."
	$(PACK_CMD) build sample-hello-moon-windows-app:nanoserver-1809 -v --builder cnbs/sample-builder:nanoserver-1809 --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world-windows --buildpack $(SAMPLES_ROOT)/buildpacks/hello-moon-windows $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world-windows' app using 'nanoserver-1809' builder..."
	$(PACK_CMD) build sample-hello-world-windows-app:nanoserver-1809 -v --builder cnbs/sample-builder:nanoserver-1809 --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world-windows $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-buildpacks-dotnet-framework-1809: build-sample-root
	@echo "> Creating 'dotnet-framework' app using 'dotnet-framework-1809' builder..."
	$(PACK_CMD) build sample-dotnet-framework-app:dotnet-framework-1809 -v --builder cnbs/sample-builder:dotnet-framework-1809 --buildpack $(SAMPLES_ROOT)/buildpacks/dotnet-framework --path apps/aspnet $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-buildpacks-dotnet-framework-2004: build-sample-root
	@echo "> Creating 'dotnet-framework' app using 'dotnet-framework-2004' builder..."
	$(PACK_CMD) build sample-dotnet-framework-app:dotnet-framework-2004 -v --builder cnbs/sample-builder:dotnet-framework-2004 --buildpack $(SAMPLES_ROOT)/buildpacks/dotnet-framework --path apps/aspnet $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-buildpacks-dotnet-framework-2022: build-sample-root
	@echo "> Creating 'dotnet-framework' app using 'dotnet-framework-2022' builder..."
	$(PACK_CMD) build sample-dotnet-framework-app:dotnet-framework-2022 -v --builder cnbs/sample-builder:dotnet-framework-2022 --buildpack $(SAMPLES_ROOT)/buildpacks/dotnet-framework --path apps/aspnet $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

build-windows-packages: build-sample-root
	@echo "> Creating 'hello-world-windows' buildpack package"
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-world-windows --config $(SAMPLES_ROOT)/packages/hello-world-windows/package.toml $(PULL_POLICY_NEVER)

	@echo "> Creating 'hello-universe-windows' buildpack package"
	$(PACK_CMD) buildpack package cnbs/sample-package:hello-universe-windows --config $(SAMPLES_ROOT)/packages/hello-universe-windows/package.toml $(PULL_POLICY_NEVER)

deploy-windows-packages:
	@echo "> Deploying windows packages..."
	docker push cnbs/sample-package:hello-world-windows
	docker push cnbs/sample-package:hello-universe-windows

deploy-windows-1809: deploy-windows-stacks-1809 deploy-windows-builders-1809

deploy-windows-2004: deploy-windows-stacks-2004 deploy-windows-builders-2004

deploy-windows-2022: deploy-windows-stacks-2022 deploy-windows-builders-2022

deploy-windows-stacks-1809: deploy-windows-stacks-nanoserver-1809 deploy-windows-stacks-dotnet-framework-1809

deploy-windows-stacks-2004: deploy-windows-stacks-dotnet-framework-2004

deploy-windows-stacks-2022: deploy-windows-stacks-dotnet-framework-2022

deploy-windows-stacks-nanoserver-1809:
	@echo "> Deploying 'nanoserver-1809' stack..."
	docker push cnbs/sample-stack-base:nanoserver-1809
	docker push cnbs/sample-stack-run:nanoserver-1809
	docker push cnbs/sample-stack-build:nanoserver-1809

deploy-windows-stacks-dotnet-framework-1809:
	@echo "> Deploying 'dotnet-framework-1809' stack..."
	docker push cnbs/sample-stack-run:dotnet-framework-1809
	docker push cnbs/sample-stack-build:dotnet-framework-1809

deploy-windows-stacks-dotnet-framework-2004:
	@echo "> Deploying 'dotnet-framework-2004' stack..."
	docker push cnbs/sample-stack-run:dotnet-framework-2004
	docker push cnbs/sample-stack-build:dotnet-framework-2004

deploy-windows-stacks-dotnet-framework-2022:
	@echo "> Deploying 'dotnet-framework-2022' stack..."
	docker push cnbs/sample-stack-run:dotnet-framework-2022
	docker push cnbs/sample-stack-build:dotnet-framework-2022

deploy-windows-builders-1809: deploy-windows-builders-nanoserver-1809 deploy-windows-builders-dotnet-framework-1809

deploy-windows-builders-2004: deploy-windows-builders-dotnet-framework-2004

deploy-windows-builders-2022: deploy-windows-builders-dotnet-framework-2022

deploy-windows-builders-nanoserver-1809:
	@echo "> Deploying 'nanoserver-1809' builder..."
	docker push cnbs/sample-builder:nanoserver-1809

deploy-windows-builders-dotnet-framework-1809:
	@echo "> Deploying 'dotnet-framework-1809' builder..."
	docker push cnbs/sample-builder:dotnet-framework-1809

deploy-windows-builders-dotnet-framework-2004:
	@echo "> Deploying 'dotnet-framework-2004' builder..."
	docker push cnbs/sample-builder:dotnet-framework-2004

deploy-windows-builders-dotnet-framework-2022:
	@echo "> Deploying 'dotnet-framework-2022' builder..."
	docker push cnbs/sample-builder:dotnet-framework-2022

clean-windows:
	@echo "> Removing 'nanoserver-1809' stack..."
	docker rmi cnbs/sample-stack-base:nanoserver-1809 || true
	docker rmi cnbs/sample-stack-run:nanoserver-1809 || true
	docker rmi cnbs/sample-stack-build:nanoserver-1809 || true

	@echo "> Removing 'dotnet-framework-1809' stack..."
	docker rmi cnbs/sample-stack-run:dotnet-framework-1809 || true
	docker rmi cnbs/sample-stack-build:dotnet-framework-1809 || true
	
	@echo "> Removing 'dotnet-framework-2004' stack..."
	docker rmi cnbs/sample-stack-run:dotnet-framework-2004 || true
	docker rmi cnbs/sample-stack-build:dotnet-framework-2004 || true

	@echo "> Removing 'dotnet-framework-2022' stack..."
	docker rmi cnbs/sample-stack-run:dotnet-framework-2022 || true
	docker rmi cnbs/sample-stack-build:dotnet-framework-2022 || true

	@echo "> Removing builders..."
	docker rmi cnbs/sample-builder:nanoserver-1809 || true
	docker rmi cnbs/sample-builder:dotnet-framework-1809 || true
	docker rmi cnbs/sample-builder:dotnet-framework-2004 || true
	docker rmi cnbs/sample-builder:dotnet-framework-2022 || true

	@echo "> Removing 'nanoserver-1809' apps..."
	docker rmi sample-hello-moon-windows-app:nanoserver-1809 || true
	docker rmi sample-hello-world-windows-app:nanoserver-1809 || true
	docker rmi sample-batch-script-app:nanoserver-1809 || true

	@echo "> Removing 'dotnet-framework-1809' apps..."
	docker rmi sample-aspnet-app:dotnet-framework-1809 || true

	@echo "> Removing 'dotnet-framework-2004' apps..."
	docker rmi sample-aspnet-app:dotnet-framework-2004 || true

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
build-sample-root:
	@mkdir -p $(SAMPLES_ROOT)/buildpacks/

	@for bp_dir in ./buildpacks/*/; do \
		tar -czf $(SAMPLES_ROOT)/buildpacks/$$(basename $$bp_dir) -C $$bp_dir . ; \
	done

	@cp -r builders packages $(SAMPLES_ROOT)/
else
# No-op for posix pack
SAMPLES_ROOT:=.
build-sample-root:
endif


PULL_POLICY_NEVER?=--pull-policy=never
PACK_BUILD_FLAGS?=--trust-builder
PACK_CMD?=pack

clean: clean-linux

####################
## Linux
####################

build-linux: build-linux-bases build-linux-packages build-linux-builders build-linux-buildpacks

build-linux-bases: build-base-alpine build-base-noble

build-alpine: build-base-alpine build-builder-alpine build-buildpacks-alpine

build-noble: build-base-noble build-builder-noble build-buildpacks-noble

build-base-alpine:
	@echo "> Building 'alpine' base images..."
	${PACK_CMD} config experimental true
	bash base-images/build.sh alpine

build-base-noble:
	@echo "> Building 'noble' base images..."
	${PACK_CMD} config experimental true
	bash base-images/build.sh noble

build-linux-builders: build-builder-alpine build-builder-noble

build-builder-alpine: build-linux-packages build-sample-root
	@echo "> Building 'alpine' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:alpine --config $(SAMPLES_ROOT)/builders/alpine/builder.toml $(PULL_POLICY_NEVER)

build-builder-noble: build-linux-packages build-sample-root
	@echo "> Building 'noble' builder..."
	$(PACK_CMD) builder create cnbs/sample-builder:noble --config $(SAMPLES_ROOT)/builders/noble/builder.toml $(PULL_POLICY_NEVER)

build-linux-buildpacks: build-buildpacks-alpine build-buildpacks-noble

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

build-buildpacks-noble: build-sample-root
	@echo "> Creating 'hello-moon' app using 'noble' builder..."
	$(PACK_CMD) build sample-hello-moon-app:noble -v --builder cnbs/sample-builder:noble --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world --buildpack $(SAMPLES_ROOT)/buildpacks/hello-moon $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-processes' app using 'noble' builder..."
	$(PACK_CMD) build sample-hello-processes-app:noble -v --builder cnbs/sample-builder:noble --buildpack $(SAMPLES_ROOT)/buildpacks/hello-processes $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'hello-world' app using 'noble' builder..."
	$(PACK_CMD) build sample-hello-world-app:noble -v --builder cnbs/sample-builder:noble --buildpack $(SAMPLES_ROOT)/buildpacks/hello-world $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'java-maven' app using 'noble' builder..."
	$(PACK_CMD) build sample-java-maven-app:noble -v --builder cnbs/sample-builder:noble --path apps/java-maven $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'kotlin-gradle' app using 'noble' builder..."
	$(PACK_CMD) build sample-kotlin-gradle-app:noble -v --builder cnbs/sample-builder:noble --path apps/kotlin-gradle $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

	@echo "> Creating 'ruby-bundler' app using 'noble' builder..."
	$(PACK_CMD) build sample-ruby-bundler-app:noble -v --builder cnbs/sample-builder:noble --path apps/ruby-bundler $(PULL_POLICY_NEVER) $(PACK_BUILD_FLAGS)

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

	@echo "> Deploying 'noble' base images..."
	docker push cnbs/sample-base:noble
	docker push cnbs/sample-base-run:noble
	docker push cnbs/sample-base-build:noble

deploy-linux-packages:
	@echo "> Deploying linux packages..."
	docker push cnbs/sample-package:hello-world
	docker push cnbs/sample-package:hello-universe

deploy-linux-builders:
	@echo "> Deploying 'alpine' builder..."
	docker run cnbs/sample-builder:alpine ls /cnb/extensions/samples_curl || true
	docker push cnbs/sample-builder:alpine

	@echo "> Deploying 'noble' builder..."
	docker push cnbs/sample-builder:noble

clean-linux:
	@echo "> Removing 'alpine' base images..."
	docker rmi cnbs/sample-base:alpine || true
	docker rmi cnbs/sample-base-run:alpine || true
	docker rmi cnbs/sample-base-build:alpine || true

	@echo "> Removing 'noble' base images..."
	docker rmi cnbs/sample-base:noble || true
	docker rmi cnbs/sample-base-run:noble || true
	docker rmi cnbs/sample-base-build:noble || true

	@echo "> Removing builders..."
	docker rmi cnbs/sample-builder:alpine || true
	docker rmi cnbs/sample-builder:noble || true

	@echo "> Removing 'alpine' apps..."
	docker rmi sample-hello-moon-app:alpine || true
	docker rmi sample-hello-processes-app:alpine || true
	docker rmi sample-hello-world-app:alpine || true
	docker rmi sample-java-maven-app:alpine || true
	docker rmi sample-kotlin-gradle-app:alpine || true

	@echo "> Removing 'noble' apps..."
	docker rmi sample-hello-moon-app:noble || true
	docker rmi sample-hello-processes-app:noble || true
	docker rmi sample-hello-world-app:noble || true
	docker rmi sample-java-maven-app:noble || true
	docker rmi sample-kotlin-gradle-app:noble || true
	docker rmi sample-ruby-bundler-app:noble || true

	@echo "> Removing packages..."
	docker rmi cnbs/sample-package:hello-world || true
	docker rmi cnbs/sample-package:hello-universe || true

	@echo "> Removing '.tmp'"
	rm -rf .tmp

set-experimental:
	@echo "> Setting experimental"
	$(PACK_CMD) config experimental true

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


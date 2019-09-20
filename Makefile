
all: stacks builders apps

stacks:
	@echo "> Building 'bionic' stack..."
	./stacks/build-stack.sh stacks/bionic

builders: stacks
	@echo "> Building 'bionic' builder..."
	pack create-builder sample-bionic-builder --builder-config builders/bionic/builder.toml

apps: builders
	@echo "> Creating 'java-maven' app using 'bionic' builder..."
	pack build sample-java-maven-app --builder sample-bionic-builder --path apps/java-maven
	
	@echo "> Creating 'kotlin-gradle' app using 'bionic' builder..."
	pack build sample-kotlin-gradle-app --builder sample-bionic-builder --path apps/kotlin-gradle
	
	@echo "> Creating 'ruby-bundler' app using 'bionic' builder..."
	pack build sample-ruby-bundler-app --builder sample-bionic-builder --path apps/ruby-bundler

cleanup:
	docker rmi sample/stack-base || true
	docker rmi sample/stack-run || true
	docker rmi sample/stack-build || true
	docker rmi sample-bionic-builder || true
	docker rmi sample-java-maven-app || true
	docker rmi sample-kotlin-gradle-app || true
	docker rmi sample-ruby-bundler-app || true
	
.PHONY: stacks builders cleanup
user := $(shell whoami)
git_branch := $(shell git rev-parse --abbrev-ref HEAD)
docker_tag := $(user)/innosetup:$(git_branch)

.PHONY: build
build: ## Build the Docker image
build:
	docker build --pull --platform linux/amd64,linux/arm64 -t $(docker_tag) .

.PHONY: test
test: ## Test the Docker image
test: clean
	docker run --rm -i -v $(PWD):/work $(docker_tag) helloworld.iss
	ls -al Output/HelloWorld.exe

.PHONY: shell
shell: ## Open a shell in the Docker container
shell:
	docker run --rm -it -v $(PWD):/work --entrypoint /bin/bash $(docker_tag)

.PHONY: push
push: ## Publish to Docker Hub
	docker push $(docker_tag)

.PHONY: clean
clean: ## Remove generated files
clean:
	rm -rf Output

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

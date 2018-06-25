.PHONY: all

DOCKER_URL := docker.io/hibri/sample-k8s-controller
TAG := latest

print-%: ; @echo $*=$($*)

default: build

codegen:
	hack/update-codegen.sh
	dep ensure

test:
	hack/test.sh

build: test
	hack/build.sh

package: build
	docker build -t "$(DOCKER_URL):$(TAG)" -f Dockerfile .

publish: package
	docker push "$(DOCKER_URL):$(TAG)"

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


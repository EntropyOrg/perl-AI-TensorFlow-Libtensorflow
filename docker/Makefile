ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

build: $(ROOT_DIR)/docker-bake.hcl
	cd $(ROOT_DIR)/.. && docker buildx bake -f $(ROOT_DIR)/docker-bake.hcl

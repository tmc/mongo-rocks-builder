all: artifacts

# must be a valid ref in the offical mongo git repository
MONGO_VERSION ?= r3.2.0
MONGO_TOOLS_VERSION ?= $(MONGO_VERSION)
MONGOROCKS_VERSION ?= $(MONGO_VERSION)
MONGOROCKS_VERSION_LABEL ?= $(MONGOROCKS_VERSION)
ROCKSDB_VERSION ?= 4.1

builder: Dockerfile
	docker build -t mongorocks-builder . 

artifacts: builder
	test -d artifacts || mkdir artifacts
	$(foreach artifact,$(shell docker run mongorocks-builder ls /artifacts), docker run mongorocks-builder cat /artifacts/$(artifact)> artifacts/$(artifact))

Dockerfile: Dockerfile.tmpl
	which tmpl || go get github.com/tmc/tmpl
	MONGO_VERSION=$(MONGO_VERSION) \
	  MONGO_TOOLS_VERSION=$(MONGO_TOOLS_VERSION) \
	  MONGOROCKS_VERSION=$(MONGOROCKS_VERSION) \
	  MONGOROCKS_VERSION_LABEL=$(MONGOROCKS_VERSION_LABEL) \
	  ROCKSDB_VERSION=$(ROCKSDB_VERSION) \
	  ROCKSDB_MAKE_EXTRA_ARGS=$(ROCKSDB_MAKE_EXTRA_ARGS) \
	  MONGO_SCONS_EXTRA_ARGS=$(MONGO_SCONS_EXTRA_ARGS) \
	  tmpl -f Dockerfile.tmpl > Dockerfile

.PHONY = clean
clean:
	rm -f Dockerfile
	rm -rf artifacts

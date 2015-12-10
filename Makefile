all: mongodb-rocksdb-ubuntu-12.04.deb

mongodb-rocksdb-ubuntu-12.04.deb:
	echo hi
	$(MAKE) -C 12.04 all

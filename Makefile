all:
	$(MAKE) -C libcgc all
	$(MAKE) -C selected all
clean:
	$(MAKE) -C libcgc clean
	$(MAKE) -C selected clean

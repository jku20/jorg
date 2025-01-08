.PHONY: jorg
jorg:
	@$(MAKE) -C src ../jorg

.PHONY: test
test:
	@$(MAKE) -C test test

.PHONY: gen
gen:
	@$(MAKE) -C test gen

.PHONY: clean
clean:
	rm -f jorg
	@$(MAKE) -C src clean
	@$(MAKE) -C test clean

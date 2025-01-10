.PHONY: jorg
jorg: libtoml
	@$(MAKE) -C src ../jorg

.PHONY: test
test: libtoml
	@$(MAKE) -C test test

libtoml:
	@$(MAKE) -C tomlc99

.PHONY: gen
gen:
	@$(MAKE) -C test gen

.PHONY: clean
clean:
	rm -f jorg
	@$(MAKE) -C src clean
	@$(MAKE) -C test clean

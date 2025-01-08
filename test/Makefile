MMC = mmc
PARALLEL = -j $(shell nproc 2>/dev/null || echo 1)
DIFF = diff -u

files = $(wildcard **.m ../src/**.m)

TESTS = sample_test

.PHONY: test
test: $(addsuffix .runtest,$(TESTS)) Mercury.options

.PHONY: gen
gen: $(addsuffix .gen,$(TESTS)) Mercury.options

$(TESTS): $(files) Mercury.modules
	@$(MMC) --make $(PARALLEL) $@
	@test -e build/ || mkdir build/
	@mv $@ build/

Mercury.modules: $(files)
	@$(MMC) -f $(files)

.PHONY: %.runtest
# Subcommand for the runtest script, "test" runs tests.
%.runtest: %
	@cp $(<).exp build/ || (touch $(<).exp && cp $(<).exp build/)
	./runtest.sh test build/$(<)

.PHONY: %.gen
# Subcommand for the runtest script, "gen" creates the .exp files.
%.gen: %
	./runtest.sh gen build/$(<)
	@cp build/$(<).exp $(<).exp

.PHONY: clean
clean:
	rm -rf Mercury
	rm -rf build
	rm -f *.err *.mh
	rm -f Mercury.modules

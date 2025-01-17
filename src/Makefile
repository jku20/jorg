MMC = mmc
PARALLEL = -j $(shell nproc 2>/dev/null || echo 1)

files = $(wildcard **.m)

../jorg: jorg
	@ln -L -f jorg ../jorg

jorg: $(files) Mercury.options
	echo $(files)
	@$(MMC) --make $(PARALLEL) $@

tags: $(files)
	@mtags $(files)

.PHONY: clean
clean:
	rm -rf Mercury
	rm -f *.err *.mh jorg

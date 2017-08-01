# OPAMROOT=$(PWD)/.opam

# build: setup.data
# 	$(SETUP) -build $(BUILDFLAGS)

# test: setup.data build
# 	$(SETUP) -test $(TESTFLAGS)

# all:
# 	$(SETUP) -all $(ALLFLAGS)
env:
	export OPAMROOT=$(PWD)/.opam

install: env
	OPAMROOT=$(PWD)/.opam \
	opam install -y \
	sedlex \
	ounit \
	extlib

# clean:
# 	$(SETUP) -clean $(CLEANFLAGS)

echo:
	echo $(OPAMROOT)

init: env
	opam init -ya --root $(OPAMROOT)
	eval `opam config env`
	opam pin add ocaml-suburi . -y

# .PHONY: 
OPAM=$(PWD)/.opam

build:
	ocamlbuild -use-ocamlfind -pkgs \
sedlex,\
ounit,\
extlib\
		src/main/main.native

# test: setup.data build
# 	$(SETUP) -test $(TESTFLAGS)

# all:
# 	$(SETUP) -all $(ALLFLAGS)

init:
	opam init -ya --comp=4.03.0
	eval `opam config env`

	# OPAMROOT=$(OPAM) \
	# 	opam pin add ocaml-suburi . -y

install:
	opam update
	opam install -y \
		ocamlfind \
		sedlex \
		ounit \
		extlib

clean:
	ocamlbuild -clean

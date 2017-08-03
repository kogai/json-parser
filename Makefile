OPAM=$(PWD)/.opam

build:install 
	OPAMROOT=$(OPAM) \
	ocamlbuild \
		-use-ocamlfind -pkgs \
		sedlex \
		ounit \
		extlib \
		src/main/main.native

# test: setup.data build
# 	$(SETUP) -test $(TESTFLAGS)

# all:
# 	$(SETUP) -all $(ALLFLAGS)

init:
	opam init -ya --root $(OPAM)
	OPAMROOT=$(OPAM) \
		opam switch 4.05.0+trunk
	OPAMROOT=$(OPAM) \
		eval `opam config env`

	# OPAMROOT=$(OPAM) \
	# 	opam pin add ocaml-suburi . -y

install:init
	OPAMROOT=$(OPAM) \
	opam install -y \
	ocamlfind \
	sedlex \
	ounit \
	extlib

clean:
	ocamlbuild -clean

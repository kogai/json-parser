OPAM=$(PWD)/.opam

build:
	ocamlbuild -use-ocamlfind -pkgs sedlex,ounit,extlib\
		src/main/main.native

gen:
	ocamlbuild -use-menhir src/lib/parser.mli

# all:
# 	$(SETUP) -all $(ALLFLAGS)

init:
	opam init -ya --comp=4.03.0
	eval `opam config env`

install:
	opam update
	opam install -y \
		ocamlfind \
		sedlex \
		ounit \
		menhir \
		extlib

clean:
	ocamlbuild -clean

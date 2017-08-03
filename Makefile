OPAM=$(PWD)/.opam

build:
	ocamlbuild -use-ocamlfind -pkgs sedlex,ounit,extlib,core\
		src/main/main.native

gen:
	ocamlbuild -use-menhir src/lib/parser.mli

tests:
	ocamlbuild -use-menhir -tag thread -use-ocamlfind -quiet -pkg core src/lib/test.native
	./test.native fixture.json

# all:
# 	$(SETUP) -all $(ALLFLAGS)

init:
	opam init -ya --comp=4.03.0
	eval `opam config env`

install:
	opam update
	opam install -y \
		core \
		ocamlfind \
		sedlex \
		ounit \
		menhir \
		extlib

clean:
	ocamlbuild -clean

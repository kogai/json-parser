OPAM=$(PWD)/.opam

build:
	ocamlbuild -use-ocamlfind -tag thread -pkgs sedlex,ounit,extlib,core\
		src/main/main.native

gen:build
	ocamlbuild -use-menhir -pkg core src/lib/parser.mli

run:gen
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

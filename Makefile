OCB_FLAGS = -use-ocamlfind -use-menhir -I src -pkgs sedlex,ounit,core -tag thread
OCB = ocamlbuild $(OCB_FLAGS)

build:native byte

run:build
	./main.native fixture.json

native:
	$(OCB) main.native

byte:
	$(OCB) main.byte

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
		menhir

clean:
	ocamlbuild -clean

OCB_FLAGS = -use-ocamlfind -use-menhir -I src -pkgs 'sedlex,ounit,core,menhirlib' -tags thread
OCB = ocamlbuild $(OCB_FLAGS)

build:native byte

complement:
	ocamlbuild -use-ocamlfind -use-menhir -I sandbox -pkgs 'sedlex,ounit,core' -tags thread complement.byte

run:build
	./main.native fixture.json

test:
	$(OCB) main_test.native
	./main_test.native

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
		ocp-indent \
		ocp-index \
		merlin \
		core \
		ocamlfind \
		sedlex \
		ounit \
		menhir
	opam user-setup install

clean:
	ocamlbuild -clean

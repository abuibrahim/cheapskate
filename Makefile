PROG ?= dist/build/markdown/markdown
BENCHPROGS ?= pandoc Markdown.pl
SOURCES=Cheapskate.hs Cheapskate/Parse.hs Cheapskate/Types.hs Cheapskate/Render.hs bin/markdown.hs SimpleParserCombinators.hs
.PHONY: prof test bench linecount clean

$(PROG): $(SOURCES)
	cabal configure --user && cabal build

prof:
	cabal configure --enable-library-profiling --enable-executable-profiling --user && cabal build ; \
	  echo "To profile:  $(PROG) +RTS -pa -V0.0002 -RTS"

test:
	make -C tests --quiet clean all

bench:
	for prog in $(PROG) $(BENCHPROGS); do \
	   echo; \
	   echo "Benchmarking $$prog"; \
	     time for i in tests/*/*.markdown; do \
	       cat $$i | $$prog >/dev/null ; \
	       done ; \
	done

linecount:
	@echo "Non-comment, non-blank lines:" ; \
	grep '^[^-]' Cheapskate.hs Cheapskate/*.hs | wc -l

clean:
	cabal clean && make -C tests clean

SCHEME = unsyntax-scheme -I lib

check:
	$(SCHEME) tests.scm

.PHONY: check

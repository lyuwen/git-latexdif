gitexecdir = ${shell git --exec-path}

-include ./config.mak

ifndef BASH_PATH
	BASH_PATH = /bin/bash
endif

BASH_PATH_SQ = $(subst ','\'',$(BASH_PATH))
GIT_LATEXDIFF_VERSION=${shell git describe --tags HEAD}
gitexecdir_SQ = $(subst ','\'',$(gitexecdir))

SCRIPT=git-latexdiff

.PHONY: install help
help:
	@echo 'This is the help target of the Makefile. Current configuration:'
	@echo '  gitexecdir = $(gitexecdir_SQ)'
	@echo '  BASH_PATH = $(BASH_PATH_SQ)'
	@echo 'Run "$(MAKE) install" to install $(SCRIPT) in gitexecdir.'

install:
	sed -e '1s|#!.*/bash|#!$(BASH_PATH_SQ)|' \
	    -e 's|@GIT_LATEXDIFF_VERSION@|$(GIT_LATEXDIFF_VERSION)|' \
	        $(SCRIPT) > '$(gitexecdir_SQ)/$(SCRIPT)'
	chmod 755 '$(gitexecdir_SQ)/$(SCRIPT)'

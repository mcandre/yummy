# YummY management

include make.d/config.make
#include make.d/debug.make

########################################################################
# Parameters (redefine as you like)
########################################################################

prefix	?= /usr/local
bindir	?= $(prefix)/bin
datadir	?= $(prefix)/share

########################################################################
# Rules
########################################################################

# Create auxiliar directories
include make.d/setup.make

# Default target
all:

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber install uninstall

clean:

clobber: clean

install:
	test -d $(bindir) || $(SUDO) mkdir --verbose --parents $(bindir)
	test -d $(datadir)/yummy || $(SUDO) mkdir --verbose --parents $(datadir)/yummy
	$(SUDO) install --verbose --compare --mode 555 bin/* $(bindir)
	$(SUDO) install --verbose --compare --mode 644 share/* $(datadir)/yummy

uninstall:
	$(SUDO) rm --verbose --force -- $(addprefix $(prefix)/,$(wildcard bin/*))
	test -d $(datadir)/yummy 					\
	&& $(SUDO) rm --verbose --force --recursive $(datadir)/yummy	\
	|| true

# Show targets
.PHONY: help
help:
	echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4

########################################################################
# Tests
########################################################################

.PHONY: check yaml csv

check: yaml csv

# YAML and CSV tests

define FileFormat
# Run one example
$(1)-%.sh:
	echo -en '$$@:\t'
	$(SHELL) tests/$$@
	echo 'No news is good news!'
# Run one example named without file suffix
$(1)-%: $(1)-%.sh ;
# Run all tests
$(1): $(sort $(subst tests/,,$(wildcard tests/$(1)-[0-9][0-9].sh)))
# Check output of all filters is empty for empty input
	test -z "$$$$(for f in bin/$(1)2* bin/*2$(1); do echo | $$$$f; done)" \
	|| { echo 1>&2 'EMPTY-FAILED'; false; }
endef

$(eval $(call FileFormat,yaml))
$(eval $(call FileFormat,csv))

# vim:ai:sw=8:ts=8:noet:syntax=make

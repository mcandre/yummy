########################################################################
# Prerequisites
########################################################################

# We are using some of the newest GNU Make features... so require GNU
# Make version >= 3.82
version_test := $(filter 3.82,$(firstword $(sort $(MAKE_VERSION) 3.82)))
ifndef version_test
$(error GNU Make version $(MAKE_VERSION); version >= 3.82 is needed)
endif

# Paranoia
ifeq (0,$(shell id --user))
ifeq (,$(filter install uninstall,$(MAKECMDGOALS)))
$(error  Root only can make "(un)install" targets)
endif
SUDO := 
else
SUDO := sudo
endif

########################################################################
# Configuration
########################################################################

# Disable builtins.
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

# Warn when an undefined variable is referenced.
MAKEFLAGS += --warn-undefined-variables

# Make will not print the recipe used to remake files.
.SILENT:

# Eliminate use of the built-in implicit rules. Also clear out the
# default list of suffixes for suffix rules.
.SUFFIXES:

# Sets the default goal to be used if no targets were specified on the
# command line.
.DEFAULT_GOAL := all

# When it is time to consider phony targets, make will run its recipe
# unconditionally, regardless of whether a file with that name exists or
# what its last-modification time is.
.PHONY: all

# When a target is built all lines of the recipe will be given to a
# single invocation of the shell.
# !!!Does not work in  make <= 3.82 event it is documented!!!
#.ONESHELL:

# Default shell: if we require GNU Make, why not require Bash?
SHELL := /bin/bash

# The argument(s) passed to the shell are taken from the variable
# .SHELLFLAGS.
.SHELLFLAGS := -o errexit -o pipefail -o nounset -c

# Make will delete the target of a rule if it has changed and its recipe
# exits with a nonzero exit status.
.DELETE_ON_ERROR:

# vim:ai:sw=8:ts=8:noet:syntax=make

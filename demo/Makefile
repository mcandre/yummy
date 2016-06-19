# YummY website makefile

########################################################################
# Prerequisites
########################################################################

# We are using some of the newest GNU Make features... so require GNU
# Make version >= 3.82
version_test := $(filter 3.82,$(firstword $(sort $(MAKE_VERSION) 3.82)))
ifndef version_test
$(error GNU Make version $(MAKE_VERSION); version >= 3.82 is needed)
endif

# Check 'root' intentions
ifeq (0,$(shell id --user))
ifeq (,$(filter install uninstall,$(MAKECMDGOALS)))
$(error  Root only can make "(un)install" targets)
endif
endif

# Entry point
.PHONY: all
.DEFAULT_GOAL := all
MAKECMDGOALS  ?= all

# Only one target at the same time
ifneq (1,$(words $(MAKECMDGOALS)))
$(error Only one target accepted!)
endif

########################################################################
# Configuration
########################################################################

# Remove defaults
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --warn-undefined-variables
.SUFFIXES:

# Shell and options
SHELL := /bin/bash
.SHELLFLAGS := -o errexit -o pipefail -o nounset -c

# Don't leave incomplete targets
.DELETE_ON_ERROR:

# Enable a second expansion of the prerequisites
.SECONDEXPANSION:

# Make will not print the recipe used to remake files.
.SILENT:

########################################################################
# Macros
########################################################################

_comma := ,
_empty :=
_space := $(_empty) $(_empty)

#=======================================================================
# Canned recipes capturing environment
#=======================================================================

# Used to print target to be created
_trace = echo 1>&2 '==> $@'

#=======================================================================
# Filters
#=======================================================================

# Extract YAML front-matter
define _yaml_extract =
  sed -n -e '1d;/^---$$/q;/^\.\.\.$$/q;/^\#/d;p'
endef

# Remove YAML front-matter
define _yaml_remove =
  sed  -e '/^---$$/,/\(^\.\.\.$$\)\|\(^---$$\)/d'
endef

# Remove (some) XML comments
define _uncomment =
  sed -e '/^<!--=*$$/,/^=*-->$$/d'
endef

#=======================================================================
# Functions
#=======================================================================

# Validate XHTML
define _validate =
  xmllint --noout --valid $1 		\
  || echo 1>&2 'Errors validating XHTML output: $1'
endef

# Make a directory if no exists
define _mkdir
  if test ! -d $1; then 		\
	echo 1>&2 '==> $1';		\
  	mkdir --parents $1;		\
  fi
endef

# Remove first word
define _rest =
  $(wordlist 2,2147483648,$1)
endef

########################################################################
# Globals
########################################################################

# Metadata repository
Meta := .yummy

-include $(Meta)/dirs.make

# Defined?
#	Destination
#	Documents
#	Assets
#	Data
#	Snippets
#	Layouts

# Shared scripts used for M4, jq, etc.
Share := /usr/local/share/yummy

# YummY version
Version := $(shell cat $(Share)/version.txt)

# M4 configuration and defined y4 macros
Y4 := $(Share)/yummy.m4

# Accumulate files to clean and clobber targets
clean = *.log
clobber = *.bak

########################################################################
# Filesystem data and directories
########################################################################

ifdef Destination # and Documents

clobber += $(Destination)

# Input documents extensions
_md :=	-name '*.markdown' -o	\
	-name '*.md' -o		\
	-name '*.mdown' -o	\
	-name '*.mkd' -o	\
	-name '*.text' -o	\
	-name '*.txt'		\

# All markdown documents
_docs := $(shell find $(Documents) -type f -a $(_md))

# Pages to be generated, and related JSON
define _pages =
  $(patsubst %.md,%.$1,$(patsubst $(Documents)%,$2%,$(_docs)))
endef

PagesHTML := $(call _pages,html,$(Destination))
PagesJSON := $(call _pages,json,$(Meta)/pages)
PagesYAML := $(PagesJSON:.json=.yaml)

clean += $(PagesHTML)

# Tree structure of directories
define _tree =
  $(patsubst $(Documents)%,$1%,$(_docs_tree))
endef

_docs_tree := $(sort $(dir $(_docs)))
_site_tree := $(call _tree,$(Destination))
_page_tree := $(call _tree,$(Meta)/pages)
_node_tree := $(call _tree,$(Meta)/nodes)

# All sections and subsections, removing home page node
define _nodes =
  $(call _rest,$(patsubst %/,%$1,$2))
endef

NodesJSON := $(call _nodes,.json,$(_node_tree))
NodesHTML := $(call _nodes,/index.html,$(_site_tree))
NodesYAML := $(NodesJSON:.json=.yaml)

# Home page
HomeHTML := $(Documents)/index.html

# Make directories
$(_site_tree): $(Destination)/% : $(Documents)/% ; $(call _mkdir,$@)
$(_page_tree): $(Meta)/pages/%  : $(Documents)/% ; $(call _mkdir,$@)
$(_node_tree): $(Meta)/nodes/%  : $(Documents)/% ; $(call _mkdir,$@)

endif  # Destination

########################################################################
# Metadata
########################################################################

# Top metadata folder
$(Meta):
	$(call _mkdir,$@)

clobber += $(Meta)

#=======================================================================
# Config
#=======================================================================

ifeq (config.yaml, $(wildcard config.yaml))
# Using config.yaml as a config file
$(Meta)/config.json: config.yaml | $(Meta)
	$(_trace)
	yaml2json $<				\
	| jq --sort-keys			\
	     --from-file $(Share)/config.jq	\
	- > $@

else
ifeq (config.json, $(wildcard config.json))
# Using config.json as a config file
$(Meta)/config.json: config.json | $(Meta)
	$(_trace)
	jq --sort-keys '.' $< > $@
else
$(error Configuration file not found)
endif
endif

#=======================================================================
# Makefiles
#=======================================================================

$(Meta)/dirs.make: $(Meta)/config.json
	$(_trace)
	jq --sort-keys				\
	   --raw-output				\
	   --from-file $(Share)/directories.jq	\
	$< > $@

ifdef PagesJSON # and Documents, NodesJSON

#=======================================================================
# JSON for each page
#=======================================================================

define _base
$(patsubst ../../%,%,$(subst $(_space),,$(patsubst %,../,$(subst /, ,$1))))
endef

# $(Meta)/pages/%.json == PagesJSON
$(Meta)/pages/%.json: $(Documents)/%.md $(Meta)/config.json | $$(dir $$@)
	$(_trace)
	{ echo 'id: "$(subst ./,,$(basename $*))"';			\
	  echo 'ispage: true';						\
	  echo 'isnode: false';						\
	  echo 'filename: "$(notdir $*)"';				\
	  echo 'section: "$(subst .,,$(patsubst %/,%,$(dir $*)))"';	\
	  echo 'path: "$(subst ./,,$(dir $*))"';			\
	  echo 'url: "$*.html"';					\
	  echo -n 'lastmod: ';						\
		date --utc --iso-8601=seconds --reference='$<'		\
		| sed 's/+0000/+00:00/;s/^/"/;s/$$/"/';			\
	  echo 'base: "$(call _base,$<)"';				\
	  $(_yaml_extract) $<; }					\
	| yaml2json							\
	| jq --sort-keys						\
	     --slurpfile config $(Meta)/config.json			\
	     --from-file $(Share)/merge.jq				\
	> $@

# "pages:" top level object
$(Meta)/pages.json: $(PagesJSON)
	$(_trace)
	jq --sort-keys		\
	   --slurp		\
	   '{pages: .}'		\
	   $^ > $@

# "site:" top level object
$(Meta)/site.json: $(Meta)/config.json $(Meta)/pages.json
	$(_trace)
	jq --sort-keys				\
	   --slurpfile p $(Meta)/pages.json	\
	   '{site: (. + {version: "$(Version)"} + {sections: [$$p[0].pages[].section] | unique})}' \
	$< > $@

#=======================================================================
# JSON for each node
#=======================================================================

# TODO...
$(NodesJSON): $(Meta)/config.json | $$(dir $$@)
	{ echo '{';							\
	  echo '"id": "$(patsubst $(Meta)/nodes/%,%,$(basename $@))/",';\
	  echo '"isnode": true,';					\
	  echo '"ispage": false,';					\
	  echo '"ishome": false',;					\
	  echo '"title": "$(notdir $(basename $@))",';			\
	  echo '"date": "'$$(date --utc --iso-8601)'"';			\
	  echo '}'; }							\
	| jq --sort-keys						\
	     --slurpfile config $(Meta)/config.json			\
	     --from-file $(Share)/merge.jq				\
	> $@

#=======================================================================
# Derived YAML
#=======================================================================

define _object
  $(_trace)
  { echo '{"$1":'; cat $<; echo "}"; }	\
  | json2yaml > $@
endef

.PRECIOUS: $(Meta)/pages/%.yaml
.PRECIOUS: $(Meta)/nodes/%.yaml

$(Meta)/pages/%.yaml: $(Meta)/pages/%.json ; $(call _object,page)
$(Meta)/nodes/%.yaml: $(Meta)/nodes/%.json ; $(call _object,node)

METADATA := $(Meta)/site.yaml $(Meta)/pages.yaml

$(METADATA): %.yaml : %.json
	$(_trace)
	json2yaml $< > $@

endif # PagesJSON

########################################################################
# Layouts
########################################################################

ifdef Layouts # and Y4, _uncomment

define _matryoshka :=
  $(foreach p,page outer,$(Layouts)/$p.p)		\
  $(foreach p,head title toc,$(Layouts)/_parts/$p.p)
endef

$(Layouts)/page.html: $(_matryoshka) $(Y4)
	$(_trace)
	m4 --prefix-builtins				\
	   --include=$(Layouts)/_parts			\
	   $(Y4) $(Layouts)/page.p $(Layouts)/outer.p	\
	| $(_uncomment) -e '/^$$/d'			\
	> $@

clobber += $(Layouts)/*.html

# TODO...
$(Layouts)/section.html: $(Layouts)/page.html
	cp $< $@

# TODO...
$(Layouts)/index.html: $(Layouts)/page.html
	cp $< $@

endif  # Layouts

########################################################################
# Site
########################################################################

ifdef Destination # and Documents, etc.

#=======================================================================
# Single page
#=======================================================================

_page = $(Meta)/pages/%.yaml $(Layouts)/page.html $(METADATA) 

$(Destination)/%.html: $(Documents)/%.md $(_page) | $$(dir $$@)
	$(_trace)
	m4 --prefix-builtins				\
	   --include=$(Snippets)			\
	   --define=@BASE@=$(call _base,$<)		\
	   $(Y4) $<					\
	| $(_uncomment)					\
	| $(_yaml_remove)				\
	| pandoc --smart				\
		 --standalone				\
		 --table-of-contents			\
		 --from=markdown-pandoc_title_block	\
		 --to=html				\
		 --template=$(Layouts)/page.html	\
		 $(Meta)/pages/$*.yaml			\
		 $(METADATA)				\
		 -					\
	> $@						\
	&& $(call _validate,$@)

#=======================================================================
# Section listing
#=======================================================================

_node = $(Meta)/nodes/%.json $(Layouts)/section.html $(METADATA) 

# TODO...
$(NodesHTML): $(Destination)/%/index.html : $(_node) | $$(dir $$@)
	$(_trace)
	touch $@

#=======================================================================
# Home page
#=======================================================================

_home = $(Layouts)/index.html $(METADATA) 

# TODO...
$(Destination)/index.html: $(_home) | $$(dir $$@)
	$(_trace)
	touch $@

endif # Destination

########################################################################
# Other site targets
########################################################################

ifdef Destination # and Documents, etc.

#=======================================================================
# Assets
#=======================================================================

# Static files
.PHONY: assets
assets:
	cp --link --recursive --update $(Assets)/* $(Destination)

# Sitemap
$(Destination)/sitemap.xml: $(Meta)/pages.json
	$(_trace)
	jq --raw-output				\
	   --from-file $(Share)/sitemap.jq	\
	   $(Meta)/pages.json > $@

$(Destination)/sitemap.xml.gz: $(Destination)/sitemap.xml
	$(_trace)
	gzip --stdout $< > $@

clean += $(Destination)/sitemap.*

#=======================================================================
# New page and document
#=======================================================================

%: # make page by ID
	if test -f $(Documents)/$*.md			\
	|| [[ $* == *index ]]; then			\
	    rm --force $(Destination)/$*.html;		\
	    $(MAKE) $(Destination)/$*.html;		\
	else						\
	    echo 'Bad id: $*';				\
	fi

# A new document
$(Documents)/%.md:
	if test ! -f $@; then				\
	    $(call _mkdir,$(dir $@));			\
	    $(_trace);					\
	    sed "s/@DATE@/$$(date --utc --iso-8601)/"	\
	        $(Share)/document.md			\
	    > $@;					\
	fi

#=======================================================================
# Default target
#=======================================================================

ifdef new
all:
	$(MAKE) $(Documents)/$(new).md
else
TARGETS :=				\
	$(Destination)/index.html	\
	$(Destination)/sitemap.xml.gz	\
	$(PagesHTML) $(NodesHTML)	\
	assets				\

all: $(TARGETS)
	echo  1>&2 'Imprimatur'
endif # new

endif # Destination

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build

clean:
	rm --force --recursive $(clean)

clobber:
	rm --force --recursive $(clean) $(clobber)

build: clean all

setup: $(METADATA) $(NodesYAML) $(PagesYAML) $(Layouts)/page.html
	@:

# Edit all documents
edit:
	$(EDITOR) $$(find $(Documents) -name '*.md')

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
	echo 'Parameters:';					\
	{ echo 'new=<id>'; }					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4

# vim:ai:sw=8:ts=8:noet:syntax=make

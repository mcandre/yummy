#
# YummY documentation makefile
#

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

# Shell and shell options
SHELL := /bin/bash
.SHELLFLAGS := -o errexit -o pipefail -o nounset -c

# Don't leave incomplete targets
.DELETE_ON_ERROR:

# Enable a second expansion of the prerequisites
.SECONDEXPANSION:

# Make will not print the recipe used to make files.
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
  sed -e '/^<!--.*-->$$/d' -e '/^<!--=*$$/,/^=*-->$$/d'
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
Meta := ./.yummy

-include $(Meta)/dirs.make

# Defined?
#	Assets
#	Data
#	Destination
#	Documents
#	Layouts
#	Macros
#	Snippets

# Shared data and scripts used for M4, jq, etc.
Share := /usr/local/share/yummy

# YummY version
Version := $(shell cat $(Share)/version.txt)

# M4 configuration
Y4 := $(Share)/yummy.m4

# Accumulate files to clean and clobber targets
clean = *.log
clobber = *.bak

########################################################################
# Filesystem data and directories
########################################################################

ifdef Destination # and Documents

clobber += $(Destination) # delete all output

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

clobber += $(Meta) # delete all metadata

# TODO: move _meta/xxx to /usr/local/share/yummy/meta

#=======================================================================
# Config
#=======================================================================

# Use config.yaml...
ifeq (config.yaml, $(wildcard config.yaml))
    # conversion of config.yaml to $(Meta)/config.json
$(Meta)/config.json: config.yaml _meta/config _meta/config.jq | $(Meta)
	$(_trace)
	yaml2json $< | _meta/config > $@
else
# ...or config.json...
ifeq (config.json, $(wildcard config.json))
    # copy (formated) of config.json to $(Meta)/config.json
$(Meta)/config.json: config.json | $(Meta)
	$(_trace)
	_meta/config < $< > $@
else
# ...or die!
$(error Configuration file not found)
endif
endif

# "site:" top level object
$(Meta)/site.json: $(Meta)/config.json _meta/site _meta/site.jq
	$(_trace)
	_meta/site $< $(Version) > $@

#=======================================================================
# Makefiles
#=======================================================================

$(Meta)/dirs.make: $(Meta)/config.json
	$(_trace)
	jq --sort-keys				\
	   --raw-output				\
	   --from-file $(Share)/directories.jq	\
	$< > $@

#=======================================================================
# JSON for each page and node
#=======================================================================

ifdef PagesJSON # and Documents

$(Meta)/pages/%.json: $(Documents)/%.md $(Meta)/config.json _meta/entryP _meta/entryP.jq | $$(dir $$@)
	$(_trace)
	$(_yaml_extract) $<	\
	| yaml2json		\
	| _meta/entryP $(Meta)/config.json $< $@ > $@

$(Meta)/nodes/%.json: $(Meta)/config.json _meta/entryN _meta/entryN.jq | $$(dir $$@)
	$(_trace)
	_meta/entryN $< $@ > $@

$(Meta)/pages.json: $(PagesJSON) _meta/pages _meta/pages.jq
	$(_trace)
	_meta/pages $(filter %.json,$^) > $@

$(Meta)/nodes.json: $(NodesJSON) _meta/nodes _meta/nodes.jq
	$(_trace)
	_meta/nodes $(filter %.json,$^) > $@

$(Meta)/sections.json: $(Meta)/pages.json _meta/sections _meta/sections.jq
	$(_trace)
	_meta/sections $< > $@

#=======================================================================
# Derived YAML
#=======================================================================

# Pages and nodes have same top level object name: 'self'
define _self
  $(_trace)
  jq '{self: .}' $< | json2yaml > $@
endef

$(Meta)/pages/%.yaml: $(Meta)/pages/%.json ; $(_self)
$(Meta)/nodes/%.yaml: $(Meta)/nodes/%.json ; $(_self)

%.yaml: %.json
	$(_trace)
	json2yaml $< > $@

# Metadata to use when calling pandoc
METADATA := \
	$(Meta)/nodes.yaml	\
	$(Meta)/pages.yaml	\
	$(Meta)/sections.yaml	\
	$(Meta)/site.yaml	\
	$(NodesYAML)		\
	$(PagesYAML)		\

endif # PagesJSON

########################################################################
# Layouts
########################################################################

ifdef Layouts # and Y4, _uncomment

$(Layouts)/page.html:				\
		$(Layouts)/page.p		\
		$(Layouts)/outer.p		\
		$(Layouts)/_parts/head.p	\
		$(Layouts)/_parts/title.p	\
		$(Layouts)/_parts/toc.p		\
		$(Y4)
	$(_trace)
	m4 --prefix-builtins			\
	   --include=$(Layouts)/_parts		\
	   $(Y4) $(Layouts)/{page,outer}.p	\
	| $(_uncomment) -e '/^$$/d'		\
	> $@

$(Layouts)/section.html:			\
		$(Layouts)/section.p		\
		$(Layouts)/outer.p		\
		$(Layouts)/_parts/head.p	\
		$(Layouts)/_parts/title.p	\
		$(Y4)
	$(_trace)
	m4 --prefix-builtins			\
	   --include=$(Layouts)/_parts		\
	   $(Y4) $(Layouts)/{section,outer}.p	\
	| $(_uncomment) -e '/^$$/d'		\
	> $@

$(Layouts)/home.html:				\
		$(Layouts)/home.p		\
		$(Layouts)/outer.p		\
		$(Layouts)/_parts/head.p	\
		$(Layouts)/_parts/title.p	\
		$(Y4)
	$(_trace)
	m4 --prefix-builtins			\
	   --include=$(Layouts)/_parts		\
	   $(Y4) $(Layouts)/{home,outer}.p	\
	| $(_uncomment) -e '/^$$/d'		\
	> $@

clobber += $(Layouts)/*.html # delete generated layouts

TEMPLATES := \
	$(Layouts)/home.html	\
	$(Layouts)/page.html	\
	$(Layouts)/section.html	\

endif  # Layouts

########################################################################
# Site
########################################################################

ifdef Destination # and Documents, etc.

_macros := $(wildcard $(Macros)/*.m4)
_data := $(wildcard $(Data)/*.yaml)

#=======================================================================
# Single page
#=======================================================================

define _base
$(patsubst ../../%,%,$(subst $(_space),,$(patsubst %,../,$(subst /, ,$1))))
endef

_page = $(Layouts)/page.html $(Meta)/pages/%.yaml $(Meta)/site.yaml $(_data) $(_macros) 

$(Destination)/%.html: $(Documents)/%.md $(_page) | $$(dir $$@)
	$(_trace)
	m4 --prefix-builtins				\
	   --include=$(Snippets)			\
	   --define=@BASE@=$(call _base,$<)		\
	   $(Y4) $(_macros) $<				\
	| $(_yaml_remove)				\
	| $(_uncomment)					\
	| pandoc --smart				\
		 --standalone				\
		 --table-of-contents			\
		 --from=markdown-pandoc_title_block	\
		 --to=html				\
		 --template=$(Layouts)/page.html	\
		 $(Meta)/pages/$*.yaml			\
		 $(Meta)/site.yaml			\
		 $(_data)				\
		 -					\
	> $@						\
	&& $(call _validate,$@)

#=======================================================================
# Section listing
#=======================================================================

# All site metadata
_site = \
	$(Meta)/nodes.yaml	\
	$(Meta)/pages.yaml	\
	$(Meta)/sections.yaml	\
	$(Meta)/site.yaml	\

_extra = $(_data) $(_macros) 

_node = $(Layouts)/section.html $(Meta)/nodes/%.yaml $(_site) $(_extra)

$(NodesHTML): $(Destination)/%/index.html : $(_node) | $$(dir $$@)
	$(_trace)
	pandoc  --standalone				\
		--from=markdown-pandoc_title_block	\
		--to=html				\
		--template=$(Layouts)/section.html	\
		$(Meta)/nodes/$*.yaml			\
		$(_site)				\
		$(_data)				\
	> $@						\
	&& $(call _validate,$@)

#=======================================================================
# Home page
#=======================================================================

_home = $(Layouts)/home.html $(_site) $(_extra)

$(Destination)/index.html: $(_home) | $$(dir $$@)
	$(_trace)
	pandoc  --standalone				\
		--from=markdown-pandoc_title_block	\
		--to=html				\
		--template=$(Layouts)/home.html		\
		$(_site)				\
		$(_data)				\
	> $@						\
	&& $(call _validate,$@)

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

clean += $(Destination)/sitemap.* # delete all sitemap formats

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
	    d=$$(date --utc --iso-8601=seconds);	\
	    sed "s/@DATE@/$$d/" $(Share)/entry.md > $@;\
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

.PHONY: clean clobber build setup edit help

clean:
	rm --force --recursive $(clean)

clobber:
	rm --force --recursive $(clean) $(clobber)

build: clean all

setup: $(TEMPLATES) $(METADATA)

# Edit all documents
edit:
	$(EDITOR) $$(find $(Documents) -name '*.md')

# Show targets
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

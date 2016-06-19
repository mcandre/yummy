########################################################################
# Tools
########################################################################

#
# Check required tools
#

ifneq (file,$(shell type -t jq))
$(error Run 'make setup' to install jq using dnf)
endif

ifneq (file,$(shell type -t pandoc))
$(error Run 'make setup' to install pandoc using dnf)
endif

ifneq (ok,$(shell python -c 'import yaml; print("ok")' 2>/dev/null))
$(error Run 'make setup' to install PyYAML using dnf)
endif

ifneq (ok,$(shell rpm -q --quiet xhtml1-dtds && echo ok))
$(error Run 'make setup' to install xhtml1-dtds using dnf)
endif

#
# Show variable value. Usage: make ?VARNAME
#

?%: .force
	echo -E '$($*)'

.force: # simulate phony target

# vim:ai:sw=8:ts=8:noet:syntax=make

########################################################################
# Setup
########################################################################

#
# Install dependencies
#

# Warning: only `dnf`! Use this rule as template to your own script.
# Assumed: GNU Make, sudo, coreutils, findutils...
setup:
	@rpm -q --quiet PyYAML	|| sudo dnf -y install PyYAML
	@rpm -q --quiet jq	|| sudo dnf -y install jq
	@rpm -q --quiet libxml2 || sudo dnf -y install libxml2
	@rpm -q --quiet m4	|| sudo dnf -y install m4
	@rpm -q --quiet pandoc 	|| sudo dnf -y install pandoc
	@rpm -q --quiet xhtml1-dtds	|| sudo dnf -y install xhtml1-dtds

#
# Static makefiles
#

#?Makefile: ;

#?$(wildcard make.d/*.make): ;

# vim:ai:sw=8:ts=8:noet:syntax=make

m4_divert(-1)

m4_changequote({{,}})

#
# Utilities for templates
#

# Include partial template
m4_define(y4_partial, {{m4_include($1.p)}})

m4_define(y4_set, {{m4_define({{@$1@}},{{$2}})}})
m4_define(y4_get, {{m4_defn({{@$1@}})}})

#
# Embeded videos
#

m4_define(y4_youtube,{{<iframe src="https://www.youtube.com/embed/$1" width="$2" height="$3" frameborder="0"></iframe>}})

m4_define(y4_vimeo,{{<iframe src="http://player.vimeo.com/video/$1" width="$2" height="$3" frameborder="0"></iframe>}})

#
# Changed in Markdown and HTML files
#
m4_changecom(<!--,-->)

m4_divert(0)m4_dnl
m4_dnl vim:ts=4:sw=4:et:fileencoding=utf8:syntax=m4

m4_divert(-1)

m4_changequote({{,}})

#########################################################################
# Macros in "hidden" namespace
#########################################################################

# y4_set(NAME, VALUE)
m4_define(y4_set, {{m4_define({{@$1@}},{{$2}})}})

# y4_get(NAME)
m4_define(y4_get, {{m4_indir({{@$1@}})}})

# y4_ref(id)
m4_define(y4_ref, {{y4_get(BASE)$1.html}})

#########################################################################
# Embeded videos
#########################################################################

# y4_youtube(7zIoLvbCCm8, 420, 315)
m4_define(y4_youtube,{{<iframe src="https://www.youtube.com/embed/$1" width="$2" height="$3" frameborder="0"></iframe>}})

# y4_vimeo(38514156, 560, 315)
m4_define(y4_vimeo,{{<iframe src="http://player.vimeo.com/video/$1" width="$2" height="$3" frameborder="0"></iframe>}})

#########################################################################
# Google analytics
#########################################################################

# y4_analytics(UA-8673551-2)
m4_define(y4_analytics,
{{ <script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', '$1']);
    _gaq.push(['_trackPageview']);
    (function() {
        var ga = document.createElement('script');
        ga.type = 'text/javascript';
        ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ga, s);
    })();
</script> }})

#
# Changed in Markdown and HTML files
#
m4_changecom(<!--,-->)

m4_divert(0)m4_dnl
m4_dnl vim:ts=4:sw=4:et:fileencoding=utf8:syntax=m4

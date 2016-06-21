# meta/sections.jq

# Input is the 'pages' object

.pages as $pages |

{
  sections: ([$pages[].section] | unique)
}


# vim:ai:sw=2:ts=2:et:fileencoding=utf-8:syntax=jq

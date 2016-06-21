# meta/pages.jq

# Input is an array of slurped JSON pages

. as $pages |

{
  pages: $pages
}


# vim:ai:sw=2:ts=2:et:fileencoding=utf-8:syntax=jq

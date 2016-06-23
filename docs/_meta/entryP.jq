# meta/entryP.jq

# Create page object and merge with defaults

. as $front_matter |

$front_matter + {
  base:     $base,
  filename: $filename,
  id:       $id,
  isnode:   false,
  ispage:   true,
  lastmod:  $lastmod,
  path:     $path,
  section:  $section,
  url:      ($id + ".html")
}                   as $page     |
$config[0].defaults as $defaults |

# merge defaults with page
reduce $defaults[] as $d
  ({}; if ($id | test("^" + $d.idprefix))
       then . + $d.properties
       else . end) + $page

# vim:ts=2:sw=2:ai:et:syntax=jq

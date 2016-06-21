# meta/node.jq

# Create node object and merge with defaults

. as $config |
{ id:     $id,
  isnode: true,
  ispage: false,
  ishome: false,
  title:  $title,
  date:   (now | todateiso8601)
} as $node |

# merge defaults with node
reduce $config.defaults[] as $d
  ({}; if ($id | test("^" + $d.idprefix))
       then . + $d.properties
       else . end) + $node

# vim:ts=2:sw=2:ai:et:syntax=jq

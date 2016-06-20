# Merge page/node JSON with defaults defined in config.yaml

{
    id: $id,
    isnode: true,
    ispage: false,
    ishome: false,
    title: $title,
    date: $date
}                   as $node     |
$config[0].defaults as $defaults |

# merge defaults with node
reduce $defaults[] as $d
  ({}; if ($id | test("^" + $d.idprefix))
       then . + $d.properties
       else . end) + $node

# vim:ts=2:sw=2:ai:et:syntax=jq

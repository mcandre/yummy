# Merge page JSON with defaults defined in config.yaml
# Usage: page JSON... | jq --sort-keys --slurpfile config config.json --from-file merge.jq > page.json

$config[0].defaults as $defaults |
.id as $id   |
reduce $defaults[] as $d
  ({}; if ($id | test("^" + $d.idprefix))
       then . + $d.properties
       else . end) + .

# vim:ts=2:sw=2:ai:et:syntax=jq

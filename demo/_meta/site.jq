# meta/site.jq

del(.defaults) as $config   |

{ site: (
    $config 
    + {
        version: $version
      }
    )
}

# vim:ai:sw=2:ts=2:et:fileencoding=utf-8:syntax=jq

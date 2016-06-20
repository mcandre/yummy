# Create site.json
#   --arg: version
#   --slurpfile: pages

del(.defaults)                  as $config   |
$pages[0].pages                 as $pages    |
([$pages[].section] | unique)   as $sections |

{ site: ($config 
            + { version: $version, sections: $sections }
        )
}

# vim:ai:sw=4:ts=4:et:fileencoding=utf-8:syntax=jq

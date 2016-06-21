# meta/config.jq

# Add some configuration defaults

. as $config |

$config + { 
  assets:      (.assets // "./assets"),
  data:        (.data // "./data"),
  destination: (.destination // "./_site"),
  documents:   (.documents // "./documents"),
  layouts:     (.layouts // "./layouts"),
  macros:      (.macros // "./macros"),
  snippets:    (.snippets // "./snippets")
}

# vim:ai:sw=2:ts=2:et:fileencoding=utf-8:syntax=jq

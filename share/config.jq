# Generate config.json adding defaults to config.yaml
# Usage: yaml2json config.yaml | jq --sort-keys --from-file config.jq > config.json

. + { 
    destination: (.destination // "./_site"),
    assets:      (.assets // "./assets"),
    data:        (.data // "./data"),
    documents:   (.documents // "./documents"),
    layouts:     (.layouts // "./layouts"),
    macros:      (.macros // "./macros"),
    snippets:    (.snippets // "./snippets"),
    style:       (.style // "./style")
}

# vim:ai:sw=4:ts=4:et:fileencoding=utf-8:syntax=jq

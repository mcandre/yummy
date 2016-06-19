# Generate makefile fragment for global directories defined in config.json
# Usage: jq --raw-output --sort-keys --from-file directories.jq config.json > dirs.make

"# vim:syntax=make\n",
"Assets := " + .assets,
"Data := " + .data,
"Macros := " + .macros,
"Destination := " + .destination,
"Documents := " + .documents,
"Layouts := " + .layouts,
"Snippets := " + .snippets,
""

# vim:ai:sw=4:ts=4:et:fileencoding=utf-8:syntax=jq

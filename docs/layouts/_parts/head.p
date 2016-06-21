<!--
  Favorite icon
-->
<link rel="icon" type="image/vnd.microsoft.icon" href="$self.base$favicon.ico"/>

<!--
  CSS
-->
<style type="text/css">code{white-space: pre;}</style>

<!--
  Pandoc option: html-q-tags
-->
$if(quotes)$
<style type="text/css">q { quotes: "“" "”" "‘" "’"; }</style>
$endif$

<!--
  Pandoc options: no-highlight, highlight-style=STYLE 
-->
$if(highlighting-css)$
<style type="text/css">
$highlighting-css$
</style>
$endif$

<!--
  Pandoc option: css=URL
-->
$for(css)$
<link rel="stylesheet" href="$css$" $if(html5)$$else$type="text/css" $endif$/>
$endfor$

<!--
vim:ts=2:sw=2:ai:et:syntax=xhtml
-->

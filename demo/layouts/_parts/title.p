<!--
  Title block
-->
$if(page.title)$
<div id="$idprefix$header">
  <h1 class="title">$page.title$</h1>
$if(page.subtitle)$
  <h1 class="subtitle">$page.subtitle$</h1>
$endif$
$for(page.author)$
  <h2 class="author">$page.author$</h2>
$endfor$
$if(page.date)$
  <h3 class="date">$page.date$</h3>
$endif$
</div>
$endif$

<!--
vim:ts=2:sw=2:ai:et:syntax=xhtml
-->

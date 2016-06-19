<!--
  Title block
-->
$if(self.title)$
<div id="$idprefix$header">
  <h1 class="title">$self.title$</h1>
$if(self.subtitle)$
  <h1 class="subtitle">$self.subtitle$</h1>
$endif$
$for(self.author)$
  <h2 class="author">$self.author$</h2>
$endfor$
$if(self.date)$
  <h3 class="date">$self.date$</h3>
$endif$
</div>
$endif$

<!--
vim:ts=2:sw=2:ai:et:syntax=xhtml
-->

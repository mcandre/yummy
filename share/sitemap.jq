# Generate sitemap.xml using meta.json as input
# Usage: jq --raw-output --from-file sitemap.jq meta.json > sitemap.xml

.site.baseurl as $baseurl |

"<?xml version='1.0' encoding='UTF-8'?>
<urlset xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
    xsi:schemaLocation='http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'
    xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>",

( .pages[] | 
    "\t<url>",
    "\t\t<loc>" + $baseurl + .url + "</loc>",
    "\t\t<lastmod>" + .lastmod + "</lastmod>",
    "\t</url>"
),

"</urlset>"

# vim:ai:sw=4:ts=4:et:fileencoding=utf-8:syntax=jq

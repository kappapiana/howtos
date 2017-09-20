Tutto questo non ha più senso, l'originale è asciidoc


# In wiki

    \{empty\}footnote:[(.*?)]

with

    <ref>$1</ref>

Quotes:

    (\`\`|'')

with

    "

Sections and stuff:

    [[.*

Just delete them

# In Markdown

Sometimes the `[]` are escaped, then:

    \\[

with

    [

Same with round parentheses

    \\\(

with

    (

Blockquote issue:

^\\_\\_\\_\\_\\_.*?

With

<blockquote>

and

    \\_\\_\\_\\_.*$

with

    </blockquote>

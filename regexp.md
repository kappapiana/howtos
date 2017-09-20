# Sostituzione selettiva

per creare regexp che mantengano parte del pattern per la sostituzione:

`(qualcosa viene mantenuto) qualcosa viene selezionato`

Nella sostituzione useremo `$1, $2` e così via per identificare, nella stringa di sostituzione, quello che verrà mantenuto

Così usando la ricerca:

nella stringa

`questo va tenuto ma questo anche verrà tenuto`

con la regexp

`(questo va tenuto) ma (questo anche verrà tenuto)`

la stringa di sostituzione

`$1 e $2 `

darà

`questo va tenuto e questo anche verrà tenuto `

# Regexp per LibreOffice et simil

Trova e seleziona tutte le parti tra parentesi quadre (es placeholder per inserimento)

`\[.*?\]`

Nota: il `?` serve per rendere la ricerca "non greedy" (prende solo la prima ricorrenza successiva, non tutte le ricorrenze, altrimenti in `[ciccio] va da [pluto]` prenderebbe anche `va da`, che deve stare fuori).

Trova tutto quanto tra doppi apici (eleganti):

`\“.*?\”`

seleziona solo gli apici e non il contenuto

`[\“|\”]`


# cambiare da hyperlink a nota in calce Markdown (Atom)

    \[(.*?)\]\((http.*?)\)

a

    $1^[<$2>]

Nota: i simboli `<` e `>` fanno sì che il testo venga interpretato come hyperlink da Pandoc.

# match negativo

Per trovare ogni ricorrenza di <Testo2> che non è preceduta o seguita da <Testo1>:

    ((?!<Testo1>))(<Testo2>)

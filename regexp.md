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

## Roba italiana

Per trasformare contratti italiani in non nazionalizzati. Ricerca tutte le ricorrenze di Art. art. e roba simile:

    \ [a|A]rt

e per codice civile:

    [c|C]{1,2}[\.| ]|(Cod)|(cod)

Prende cc,
C.c.,
cc.,
C.C.,
c.c., Cod, cod

# cambiare da hyperlink a nota in calce Markdown (Atom)

    \[(.*?)\]\((http.*?)\)

a

    $1^[<$2>]

Nota: i simboli `<` e `>` fanno sì che il testo venga interpretato come hyperlink da Pandoc.

# match negativo

Per trovare ogni ricorrenza di <Testo2> che non è preceduta o seguita da <Testo1>:

    ((?!<Testo1>))(<Testo2>)

# Grep

Nota: in grep gli escape sono un po' strani.

Non escape `[ ]` ma `\( \), \., e \{ \}`

# Espressione numero di ripetizioni

Le parentesi `"{1,3}"` significa "il carattere precedente, ripetuto da una a tre volte". Un solo numero `{3}` significa "esattamente `n` volte"

    a{1,3}
    
Trova a, aa, aaa.

Ad esempio, se un furbacchione ha inserito i numeri di capitolo a mano all'inizio (1.1, 1.2, ... nn.mm) con Libreoffice usare:

    ^[0-9]{1,2}\.[0-9]{1,2} 

E sostituire con una stringa vuota. La regexp equivale a "ogni paragrafo che ha all'inizio una o due cifre, un punto, una o due cifre, uno spazio"

# per trovare indirizzo IP generico all'interno di un testo

Per un qualsiasi indirizzo generico:

    grep '\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)' [nomefile]

Se sappiamo in che classe è (ad esempio 192.0.0.0)

    grep '192.\([0-9]\{1,3\}\).\([0-9]\{1,3\}\).\([0-9]\{1,3\}\)' [nomefile]


# Legislazione Europea

## usata in GDPR per articoli

    ^Article ([0-9]{1,3})\n\n(^.*$)

sostituito con
    
    ## @$1 Article $1 $2
    
Era

    Article n
    
    Title of the Article
    
Diventa 

    ## @n Article n Title of the Article 
    
(consente l'indicizzazione dei capitoli)

## per considerando

(sostituzione solo in selezione di Atom)

    ^(\([0-9]{1,3}\))\n\n\t\n
    
con 

    ## @w$1
    


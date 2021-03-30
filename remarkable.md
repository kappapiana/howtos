## ssh

ssh root@10.11.99.1

## Templates

A ogni aggiornamento si sputttana.

```shell
cd ~/Documents/modelli # la directory dove stanno
scp dayplanner.* root@10.11.99.1:/usr/share/remarkable/templates/

```

Sul Remarkable

```shell
cd /usr/share/remarkable/templates/
vim templates.json
```

E scegliere un'entry per `$nomefile`.

(Es: dayplanner.svg)

```json
{
       "name": "Dayplanner",
       "filename": "dayplanner",
       "iconCode": "\ue991",
       "categories": [
         "Life/organize"
       ]
     },
```

Alla fine

```shell
systemctl restart xochitl
```

## Creare template

- Fare PDF
- Caricare su coso
- Aprire da coso
- Inviare il PNG e l'SVG via email

Solo così si hanno SVG e PDF corretti.

Aggiungere il template al documento.

# useful recurring commands


# iptables - block

To **ban** an IP on the fly

     iptables -I INPUT -s $foeip -j DROP

To view blocked IP addresses (if entered with the command above), enter:

    iptables -L INPUT -v -n

or, to list all blocked (not just the INPUT chain) and show in which chain the offending ip is

```bash
sudo iptables --list -n --line-numbers | egrep --color  "(Chain) | $foeip"
```

How Do I Delete or Unblock IP Address 1.2.3.4?

Use the following syntax to **delete** or unblock an IP address under Linux, enter (where `$chain` is the chain found above:

    iptables -D $chain -s [legit-ip] -j DROP

Check if the chain is INPUT!

If the chain is fail2ban-ip-blocklist, remove the corresponding line(s) from `ip.blocklist.repeatoffender`

        sudo vim /etc/fail2ban/ip.blocklist.repeatoffender

Because it's something that you will find again at the next restart of fail2ban!

Finally, **always** make sure you save the firewall:

    sudo sh -c "iptables-save > /etc/network/iptables.save"

**note: or add permanence**

# logs

To get offending IP from access.logs


    grep "POST /wp-login.php HTTP/1.1" /var/log/apache2/other_vhosts_access.log | grep nonpercaso | awk '{print $2}' | uniq > ip.txt

From mail.log

    sudo tail -n 1000 /var/log/mail.log | egrep "unknown\[.*]\: SASL LOGIN authentication failed" | awk '{print $7}' | sed 's/]://g' | sed 's/unknown\[//g' | sort | uniq | sort -n > ip.txt

Note, to see who's more trespasser, you can add `-c` to uniq, to see how many ip did this

Grep 91.20 just to limit to a subnetwork, can be omitted. **Note** only works with unknown IPs. **TODO**: make it universal, e.g. by using the regexp

    '\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)'

to find only the IP part.

# conservazione

Per comodità, creiamo il range di mesi (così sarà sufficiente copiare i singoli comandi dalla directory madre e tutto dovrebbe funzionare senza ulteriori interventi)

    export range="[mese1-mese2]"

cambiando il mese in questione

> _nota:_ Ricordarsi di modificare `[mese1-mese2]` con i valori corretti

Creo una directory dove esportare tutti i messaggi come singoli file .eml:

    mkdir $(date +"%Y-%m-%d")\_$range/

Copiamo nella directory che abbiamo creato i file (da Thunderbird si può fare con `ImportExportTools` usando `Search and Export`).

Verifica che tutti i messaggi siano validi Smime, quali file abbiano problemi di certificato (se expired o con firma modificata):

    find $(date +"%Y-%m-%d")\_$range/ -type f -exec openssl smime -verify -in "{}" \; | grep verification

> *Nota:* meglio farlo dalla directory madre.

Crea una lista di corrispondenza tra i vari hash e il file dal quale essi sono stati generati:


    find $(date +"%Y-%m-%d")\_$range/ -type f -exec sha256sum "{}" \; > $(date +"%Y-%m-%d")\_lista_hash.txt

Estrae solo gli hash senza lista dei nomi:

    cat $(date +"%Y-%m-%d")\_lista_hash.txt | awk '{print $1}' > $(date +"%Y-%m-%d")\_lista_hash_noname.txt


Metto tutte le poste elettroniche in uno zip;


Inserisco gli hash in una dichiarazione e firmo la dichiarazione; appongo la marca temporale (con Arubasign).

> *nota:* Con Arubasign si può fare firma e marca in un solo passaggio.

Metto nella directory tutto quanto, per fare ordine

Faccio backup

## vedere al volo .p7m senza app del cavolo

`openssl smime -in documento.p7m -inform DER -verify -noverify -out documento.pdf ` `#o .txt`

se si vuole verificare il documento, usare il file delle CA

`openssl smime -in documento.p7m -inform DER -verify -CAfile CA.pem -out documento.pdf`


Questo **estrae il certificato**

`openssl pkcs7 -inform DER -in documentoVuotoFirmato.p7m -print_certs -out cert.pem`

Questo verifica il certificato estratto:

`openssl verify -CAfile CA.pem cert.pem`

Questo fa vedere le informazioni del certificato:

`openssl x509 -inform pem -in cert.pem -noout -text`

Per scaricare i certificati delle CA

    # /bin/bash
    wget -O - https://applicazioni.cnipa.gov.it/TSL/_IT_TSL_signed.xml | perl -ne 'if (/<X509Certificate>/) {
    s/^\s+//; s/\s+$//;
    s/<\/*X509Certificate>//g;
    print "-----BEGIN CERTIFICATE-----\n";
    while (length($_)>64) {
    print substr($_,0,64)."\n";
    $_=substr($_,64);
    }
    print $_."\n";
    print "-----END CERTIFICATE-----\n";
    }'

metterlo in un file script e dirigere l'output su un file chiamato CA.pem (vedi i comandi) che contiene i certificati validi a quel momento.

# Pandoc

Per creare un HTML fatto benino:

`pandoc -N --toc -Ss -c  ~/Documents/markdown/utility/pandoc.css comandi_utili.md -o comandi_utili.html --self-contained`


# Ubuntu sound systems not silenced

On the command shell:

    dconf write /org/gnome/desktop/sound/event-sounds false

<!-- # FDF per estrarre roba dai PDF compilati


Estrarre FDF con **pdftk**

`pdftk [nomefile] generate_fdf output data.fdf`

Prima stringa di sed per pulire il file FDF

## Generare i campi

`sed '1,+7d' data.fdf | sed -n -e :a -e '1,10!{P;N;D;};N;ba' | sed 's/>>//g' | sed 's/<<//g' | sed '/^\s*$/d' | grep \/T | sed 's/\/T (\(.*\))/\1;/g' | tr -d '\n' > dati.csv`


## Generare i dati

Prima dobbiamo creare una nuova linea in fondo al file

[1] `sed -i -e '$a\' dati.csv`

Poi popoliamo i dati con l'altro comando:

[2] `sed '1,+7d' data.fdf | sed -n -e :a -e '1,10!{P;N;D;};N;ba' | sed 's/>>//g' | sed 's/<<//g' | sed '/^\s*$/d' | grep \/V | sed 's/\/V (\(.*\))/\1;/g' | sed 's/\/V \/\(.*\)$/\1;/g' | tr -d '\n' >> dati.csv `

E di nuovo alla [1] per tutti i nuovi file

Da qui si può generare uno script -->
<!--
`<!-- FIXME bisogna ancora sistemare i campi multilinea: due possono essere
tolti, il terzo va filtrato, mi sa --> `

<!-- `<!-- FIXME probabilmente lo script che abbiamo generato funziona senza tutta
questa pippa, con la form che abbiamo creato -->  --> -->

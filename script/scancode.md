directory di base `oss_sdk/build/tmp/deploy/sources`

installazione di scancode:

```shell
python3 -m venv ~/scancode_venv
. ~/scancode_venv/bin/activate

pip install --upgrade pip setuptools wheel
pip install scancode-toolkit==32.5.0
deactivate

echo '#!/bin/bash
. ~/scancode_venv/bin/activate
scancode $@
deactivate
' > ~/.local/bin/scancode
chmod +x ~/.local/bin/scancode

echo '#!/bin/bash
. ~/scancode_venv/bin/activate
extractcode $@  
deactivate
' > ~/.local/bin/extractcode
chmod +x deac
```

nella cartella dove ci sono i tarball:

c'era il problema "The plugincode 32.0.0 package, which extractcode and scancode depend on, clashes with the newly installed pluggy 1.7.0 and causes the traceback, so I'm going to try pinning pluggy to an older version." (claude)

> Fix: I downgraded pluggy in the venv:
> ~/scancode_venv/bin/pip install "pluggy<1.6"
> After that, extractcode --list-formats loads normally.
>

in più su arm va installato 

`sudo apt install libarchive-dev libmagic1 p7zip-full`

e poi 

```shell
export EXTRACTCODE_LIBARCHIVE_PATH=$(ls /usr/lib/aarch64-linux-gnu/libarchive.so* | head -1)
echo $EXTRACTCODE_LIBARCHIVE_PATH   # should print a real path
```

```shell
tar xzf sources-1.0.472.tgz
extractcode --shallow --replace-originals sources
echo "{% if files.license_copyright %}{% for location, data in files.license_copyright.items() %}{% for row in data %}{% if row.what == 'copyright' %}{{ row.value }}
{% endif %}{% endfor %}{% endfor %}{% endif %}" > copyright_template.txt
mkdir copyrights
cd sources
for recipe in *; do
  echo
  echo "processing $recipe"
  rname=`python3 -c "d='$recipe'; print('-'.join(d.split('-')[:-2]))"`
  mkdir ../copyrights/$rname
  scancode --copyright \
    --custom-output ../copyrights/$rname/copyrights.all.txt \
    --custom-template ../copyright_template.txt \
    $recipe
  sort -u ../copyrights/$rname/copyrights.all.txt \
    > ../copyrights/$rname/copyrights.txt
  rm ../copyrights/$rname/copyrights.all.txt
done

```

Ci vuole una vita

Fa tutte le directory in sources

Alla fine c'è una lista di file con [-----#----] numero scannedi: nomefile

Ci pensa un po'  a ' [####################] 249910

POi passa alla prossima directory

Ha creato solo `allarch` e `arm-poky`, chiesto a Al
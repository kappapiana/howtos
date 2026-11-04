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
chmod +x ~/.local/bin/extractcode
```

nella cartella dove ci sono i tarball:

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

````
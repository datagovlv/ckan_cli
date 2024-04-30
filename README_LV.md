# [CKAN CLI](https://github.com/datagovlv/ckan_cli)


> CKAN komandrindā. Izmantojiet savu termināli, lai pārbaudītu un publicētu resursus CKAN. Darbojas ar CKAN API. Izstrādāts un pielāgots Latvijas atvērto datu portālam (Comprehensive Knowledge Archive Network).

![Interface](https://github.com/datagovlv/ckan_cli/raw/master/assets/interface.png)

## Instalācija

### Ruby instalācija

#### Windows

##### 1	Opcija: RubyInstaller

1. Apmeklējiet RubyInstaller mājaslapu.
2. Lejupielādējiet jaunāko RubyInstaller un DevKit versiju.
3. Palaidiet instalēšanas programmu, atlasiet “Pievienot Ruby izpildāmos failus savam PATH” un noklikšķiniet uz Instalēt.
4. Izpildiet instalēšanas norādījumus.
5. Atveriet komandrindu vai PowerShell un ierakstiet ruby --version, lai pārbaudītu vai instalācija bijusi veiksmīga

##### 2	Opcija: Chocolatey

1. Instalējiet Chocolatey. Instrukcijām apmeklējiet lapu Chocolatey.
2. Atveriet komandrindu vai PowerShell kā administrators.
3. Lai instalētu Ruby, palaidiet komandu: choco install ruby -y.
4. Atveriet komandrindu vai PowerShell un ierakstiet ruby --version, lai pārbaudītu vai instalācija bijusi veiksmīga

##### Pirms instalācijas:
Windows lietotājiem ir jāinstalē [MSYS2](https://www.msys2.org) pirms instalēšanas procesa sākšanas.

#### Linux

##### 1 Opcija: Izmantojot pakotņu pārvaldnieku

###### Ubuntu/Debian

1. Atveriet termināli.
2. Palaidiet sudo apt update, lai atjauninātu pakešu sarakstus.
3. Instalējiet Ruby, palaižot sudo apt install ruby-full.
4. Kad instalācija beigusies, ierakstiet ruby --version, lai to pārbaudītu.

###### CentOS/Fedora

1. Atveriet termināli.
2. Palaidiet sudo yum update, lai atjauninātu pakotņu sarakstus.
3. Instalējiet Ruby, palaižot sudo yum install ruby.
4. Kad instalācija beigusies, ierakstiet ruby --version, lai to pārbaudītu.

##### 2 Opcija: Izmantojot RVM (Ruby Version Manager)

1. Atveriet termināli.
2. Instalējiet RVM, palaižot \curl -sSL https://get.rvm.io | bash -s stable
3. Aizveriet un atkārtoti atveriet termināli, lai sāktu lietot RVM.
4. Instalējiet Ruby, izmantojot RVM: rvm install ruby.
5. Iestatiet Ruby noklusējuma versiju: rvm use ruby --default.
6. Pārbaudiet instalāciju, izmantojot ruby --version.


### Koda klonēšana no Github
Dodieties uz direktoriju, kurā vēlaties instalēt ckan_cli, un palaidiet šo komandu:
```shell
git clone https://github.com/datagovlv/ckan_cli.git
```
Tādējādi ckan_cli repozitorijs tiks klonēts jūsu izvēlētajā direktorijā.

### Instalējiet ruby projekta failu atkarības (dependency)
Dodieties uz direktoriju ckan_cli un palaidiet:
```shell
bundle install
```
### libcurl priekš Windows

Operētājsistēmai Windows kopējiet libcurldll no \ext\ git direktorijas uz Ruby izpildāmo failu direktoriju (piemēram, 'C:\Ruby26-x64\bin'). Pārdēvēt libcurl-32bit.dll -> libcurl.dll un libcurl-64bit.dll -> libcurl.dll

Izpildot šos norādījumus, iespējams, būs manuāli jāizpilda gem install csvlint, lai novērstu ActiveSupport kļūdas.

## Lietošana

Dodieties uz direktoriju ckan_cli. Rīks tiek aktivizēts ar komandu:

```shell
$ exe/ckancli.rb
```

Piemērs, lai publicētu visas katalogā esošās CSV datnes:

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file_folder/ -c example_files/config.json -r example_files/resource.json
```

Lai apskatītu palīgu, izpildiet komandu:

```shell
$ exe/ckancli.rb help
```

## Komandas un parametri

> Visas pieejamās komandas un to parametri ir aprakstīti arī CKAN CLI komandrīkā ($ ckancli.rb help)

### Pamatdarbība

Pamatkomanda resursu ielādei ir “upload” un obligātie norādāmie parametri, lai augšupielādētu datnes CKAN, ir:
- katalogs "-d". Lokālais ceļš uz datni/katalogu vai URL uz tīmekļa resursu (jāsākas ar http vai https protokolu).
- globālā konfigurācija "-c". Ceļš uz globālās konfigurācijas datni. Ceļam jābūt absolūtam vai relatīvam attiecībā pret kataloga parametrā norādīto. Skatīt konfigurēšanas sadaļu papildu informācijai. 
- resursa konfigurācija "-r". Ceļš uz resursa metadatu datni. Ceļam jābūt absolūtam vai relatīvam attiecībā pret kataloga parametrā norādīto. Skatīt konfigurēšanas sadaļu papildu informācijai. 

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json
```

### Validēšana

Lai validētu CSV resursus, pirms to ielādes CKAN, var izmantot parametru validācijas shēmai:
- validācijas shēma "-v". Ceļš uz JSON validācijas shēmu. Ceļam jābūt absolūtam vai relatīvam attiecībā pret kataloga parametrā norādīto. Skatīt konfigurēšanas sadaļu papildu informācijai.

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -v example_files/schema.json
```

### Datņu paplašinājumu ignorēšana

Pēc noklusējuma, CKAN CLI apstrādā tikai CSV datnes. Lai apstrādātu visas datnes, neatkarīgi no to paplašinājumiem, var izmantot parametru paplašinājumu ignorēšanai:
- ignorēt paplašinājumus "-i". Ja ir uzstādīts, tad tiks apstrādātas visas datnes norādītajā katalogā.

```shell
$ exe/ckancli.rb upload d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -i
```

### Esoša resursa pārrakstīšana

Pēc noklusējuma, CKAN CLI nepārraksta resursu, ja tāds jau tika atrasts pēc resursa identifikatora. Lai pārrakstītu, var izmantot parametru pārrakstīšanai:
- pārrakstīt "-w". Ja tiek izmantots šis parametrs, tad esošs resurss tiks pārrakstīts.

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -w
```

### Modificēšanas datuma atjaunošana

Lai automātiski uzstādītu resursa modificēšanas datumu CKAN API, var izmantot parametru modificēšanas datuma atjaunošanai:
- atjaunot modificēšanas datumu "-m". Ja ir uzstādīts, resursa modificēšanas datums tiks atjaunots kopā ar tā datni uz aktuālo datumu.

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -m
```

### Datu kopas metadatu atjaunošana

Lai atjauninātu arī pakotnes metadatus, izmantojiet datu kopas konfigurācijas opciju:
- pakotnes konfigurācija "-p". Ceļš uz metadatu failu. Ceļam jābūt absolūtam vai relatīvam pret direktoriju, kurā tiek izpildīta komanda. Plašāku informāciju skatiet konfigurācijas sadaļā. 

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -p example_files/package.json
```

## Konfigurēšana

> Piemēra datnes, tai skaitā shēmas un konfigurācijas datnes, ir pieejamas 'example_files' katalogā 

### Globālā konfigurācija

Satur konfigurāciju pieslēgumam ar  CKAN API un e-pastu notifikāciju uzstādījumus (sekcijas "email_server" un "notification_receiver" nav obligātas).

```javascript
{
    "ckan_api":{
        "api_key":"YOUR_CKAN_API_KEY",
        "url":"https://data.gov.lv/api/3/"
    },
    "email_server": {
            "address": "smtp.yourdomain.com",
            "port": "25",
            "ssl": false,
            "smtp_user": null,
            "smtp_password": null,
            "sender": "ckancli@data.gov.lv",
            "subject": "CKAN CLI task summary"
    },
    "notification_receiver": {
            "error": "mail_one@yourdomain.com",
            "success": "mail_one@yourdomain.com, mail_two@yourdomain.com"
    }
}
```

### Resursa konfigurācija

Satur konfigurāciju resursa metadatiem (parametri atbilst CKAN API vadlīnijām). 
- Ja resursa nosaukums nav norādīts, tiks izmantots datnes nosaukums. 
- Ja resursa identifikators nav norādīts, tiks veidots jauns resurss norādītajā datu kopā.


```javascript
{
	"result": {
		"name": "CKAN CLI file", 
		"package_name": "ta", 
		"package_id": "d1819200-121a-4452-8868-34f2c2a898c1", 
		"last_modified": "2019-05-14T05:12:21.257451", 
		"package_title": "TA", 
		"id": "15f950f0-1d50-467f-8db3-87366d30f7db"
	}, 
	"success": true
}
```

### Datu kopas konfigurācija

Satur konfigurāciju datu kopas metadatiem (parametri atbilstoši CKAN API vadlīnijām). 

```javascript
{
    "result": {
        "frequency": "http://publications.europa.eu/mdr/authority/frequency/DAILY", 
        "id": "d1819200-121a-4452-8868-34f2c2a898c1", 
        "metadata_modified": "2019-08-06T06:39:18.422714", 
        "name": "cli",
        "title": "CKAN CLI test"
    }, 
    "success": true
}
```

### CSV resursu shēmas

CSV datnes var tikt pārbaudītas, izmantojot CSV shēmu. Struktūra atbilst JSON tabulu shēmai [JSON Table Schema](http://www.w3.org/TR/tabular-metadata/). Detalizēts validāciju apraksts ir pieejams [CSV Lint project](https://github.com/theodi/csvlint.rb).

```javascript
{
	"fields": [
		{
			"name": "id",
			"constraints": {
				"required": true,
				"type": "http://www.w3.org/2001/XMLSchema#int"
			}
		},
		{
			"name": "price",
			"constraints": {
				"required": true,
				"minLength": 1 
			}
		},
		{
			"name": "postcode",
			"constraints": {
				"required": true,
				"pattern": "[A-Z]{1,2}[0-9]{4}"
			}
		}
	]
}
```

## Izstrādātājiem

Pievienot šo rindu savas Ruby aplikācijas Gemfile datnē:

```ruby
gem 'ckan_cli'
```

Un izpildīt komandu:

    $ bundle

## Kodekss

Jebkuram, veicot manipulācijas ar CKAN CLI projekta koda bāzi, to modificējot vai izplatot, jāievēro publicētais [rīcības kodekss](https://github.com/datagovlv/ckan_cli/blob/master/CODE_OF_CONDUCT.md).

## Autortiesības

Autortiesības (c) 2019 datagovlv. Skatīt [MIT Licenci](LICENSE.txt) papildu detaļām.

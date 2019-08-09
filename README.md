# [CKAN CLI](https://github.com/datagovlv/ckan_cli)

> CKAN on your command line. Use your terminal to validate and publish resources to CKAN. Works with CKAN API. Developed and adjusted for Latvian open data portal (Comprehensive Knowledge Archive Network).

## Installation

Install Ruby Gem yourself:

    $ gem install ckan_cli

## Usage

Run it:

```shell
$ ckancli.rb
```

For instance, to publish to CKAN all CSV files in folder do

```shell
$ ckancli.rb upload -d C:\my_csv_collection\ -c config.json -r resource.json
```

To see help do

```shell
$ ckancli.rb help
```

## Configuration

> Example files including schemas and configurations are located in 'example_files' directory.

### Global configuration

Contains configuration for CKAN API and e-mail notifications (sections "email_server" and "notification_receiver" are optional).

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

### Resource configuration

Contains configuration for resource metadata (parameters as specified in CKAN API guidelines). If resource name is not specified, file name will be used. If resource identifier is not specified, new resource will be created.

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

### Package configuration

Contains configuration for package metadata (parameters as specified in CKAN API guidelines). If package configuration is not specified, package metadata won't be affected.

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

### CSV schemas

CSV files can be validated against a schema. The structure currently follows [JSON Table Schema](http://www.w3.org/TR/tabular-metadata/). Detailed information for validations can be found at [CSV Lint project](https://github.com/theodi/csvlint.rb).

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

## Known issues for windows users

### Error "Could not open library 'libcurl.dll': The specified module could not be found.".

If this error is ocurring, copy file '\ext\libcurl.dll' to Ruby executables directory (e.g. 'C:\Ruby26-x64\bin\').

## For developers

Add this line to your application's Gemfile:

```ruby
gem 'ckan_cli'
```

And then execute:

    $ bundle

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/datagovlv/ckan_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the CKAN CLI project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/datagovlv/ckan_cli/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2019 datagovlv. See [MIT License](LICENSE.txt) for further details.
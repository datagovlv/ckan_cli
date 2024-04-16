# [CKAN CLI](https://github.com/datagovlv/ckan_cli)


> CKAN on your command line. Use your terminal to validate and publish resources to CKAN. Works with CKAN API. Developed and adjusted for Latvian open data portal (Comprehensive Knowledge Archive Network).

![Interface](https://github.com/datagovlv/ckan_cli/raw/master/assets/interface.png)

## Installation

### Installing Ruby

#### Windows

##### Option 1: RubyInstaller

1. Visit [RubyInstaller](https://rubyinstaller.org/) website.
2. Download the latest version of RubyInstaller and DevKit.
3. Run the installer, select "Add Ruby executables to your PATH" and click Install.
4. Follow the installation instructions.
5. Open Command Prompt or PowerShell and type `ruby --version` to verify the installation.

##### Option 2: Chocolatey

1. Install Chocolatey if you haven't already. Visit [Chocolatey](https://chocolatey.org/) for instructions.
2. Open Command Prompt or PowerShell as Administrator.
3. Run the following command to install Ruby: `choco install ruby -y`.
4. After installation, type `ruby --version` to verify.

##### Before Proceeding:
Windows users need to install [MSYS2](https://www.msys2.org) before starting the installation process.

#### Linux

##### Option 1: Using Package Manager

###### Ubuntu/Debian

1. Open Terminal.
2. Run `sudo apt update` to update package lists.
3. Install Ruby by running `sudo apt install ruby-full`.
4. Once installed, type `ruby --version` to verify.

###### CentOS/Fedora

1. Open Terminal.
2. Run `sudo yum update` to update package lists.
3. Install Ruby by running `sudo yum install ruby`.
4. Once installed, type `ruby --version` to verify.

##### Option 2: Using RVM (Ruby Version Manager)

1. Open Terminal.
2. Install RVM by running `\curl -sSL https://get.rvm.io | bash -s stable`.
3. Close and reopen Terminal to start using RVM.
4. Install Ruby using RVM: `rvm install ruby`.
5. Set Ruby version as default: `rvm use ruby --default`.
6. Verify installation with `ruby --version`.


### Clone code from github
Navigate to the directory where you want to install ckan_cli, then run the following command:
```shell
git clone https://github.com/datagovlv/ckan_cli.git
```
This will clone the ckan_cli repository into your chosen directory.

### Install ruby project dependency
Navigate to the ckan_cli directory and run:
```shell
bundle install
```
### libcurl for windows

For Windows OS copy libcurl dll from \ext\ git directory to Ruby executables directory (e.g. 'C:\Ruby26-x64\bin\'). Rename  libcurl-32bit.dll ->  libcurl.dll ir  libcurl-64bit.dll ->libcurl.dll

Additionally, after following these instructions, you may need to manually execute gem install csvlint to prevent ActiveSupport errors.


## Usage

Navigate to the ckan_cli directory and run:

```shell
$ exe/ckancli.rb
```

For instance, to publish to CKAN all CSV files in folder do

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file_folder/ -c example_files/config.json -r example_files/resource.json
```

To see help do

```shell
$ exe/ckancli.rb help
```

## Commands and options

> All available commands and options are also described in command line help.

### Basic usage

Mandatory options for CSV upload are:
- directory "-d". Local path to file/directory or URL to online resource (starting with http or https).
- global configuration "-c". Path to global configuration file. Path should be absolute or relative to directory option. See configuration section for more information. 
- resource configuration "-r". Path to resource metadata file. Path should be absolute or relative to directory option. See configuration section for more information. 

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json
```

### Validation

To validate CSV resources before uploading, use validation schema option:
- validation schema "-v". Path to JSON validation schema file. Path should be absolute or relative to directory option. See configuration section for more information.

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -v example_files/schema.json
```

### Ignore file extensions

By default, CKAN CLI processes only CSV files. To process all files in direcotry, ignoring extension, use ignore extension option:
- ignore extension "-i". If set, all files in specified directory will be processed.

```shell
$ exe/ckancli.rb upload d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -i
```

### Overwriting existing resources

By default, CKAN CLI will not overwrite resources if the same is found by resource identifier. To overwrite existing resource, use overwrite option:
- overwrite "-w". If set, existing resource will be overwritten.

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -w
```

### Updating modified date

To automatically set resources modified date in CKAN, use update modified option:
- update modified "-m". If set, resources metadata field "modified date" will be updated to current date.

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -m
```

### Updating package metadata

To also update package metadata, use dataset configuration option:
- package configuration "-p". Path to package metadata file. Path should be absolute or relative to directory option. See configuration section for more information. 

```shell
$ exe/ckancli.rb upload -d /tmp/some_csv_file.csv -c example_files/config.json -r example_files/resource.json -p example_files/package.json
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

Contains configuration for resource metadata (parameters as specified in CKAN API guidelines). Specified parameters will be passed to CKAN API with resource file. 
- If resource name is not specified, file name will be used. 
- If resource identifier is not specified, new resource will be created.

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

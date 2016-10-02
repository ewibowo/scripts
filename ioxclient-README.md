# Overview
This guide gives a brief overview of ioxclient and its usage.

## What is ioxclient?

**"ioxclient"** is a command line tool provided as part of Cisco IOx SDK. This utility is primarily meant for assisting application development for Cisco's IOx platforms. It aims to increase developer productivity by providing easy to use CLI to perform most common operations such as :

* App life cycle management [install, activate, deactivate, uninstall, start, stop, upgrade etc.,]
* Application troubleshooting [view and manage application logs]
* Life cycle management and troubleshooting for IOx services
* Cartridge management [install, uninstall, view info, upgrade etc.,]
* Platform management [view platform information, health, platform logs, techsupport snapshots, network information etc.,]
* Provides a notion of profiles that captures connection information to an IOx device and switch between multiple profiles.

It interacts with the software (CAF) running in IOx platform via well defined REST APIs.

# Installing ioxclient

ioxclient is typically distributed along with IOx SDK. It is also available as a stand alone, single, distributable binary for 32 and 64 bit platforms of MAC, Windows and Linux operating systems.

Please download the right version for your development machine. Once downloaded, it is advisable to mark it as executable (chmod 777) and place it somewhere it system path for easier usage.

Below is an overview of the commands supported by the tool. They will be described in more detail in the following sections.

# Using ioxclient

## General guidelines

* ioxclient has commands and subcommands.
* Each command/subcommand may require you to pass appropriate parameters
* Some commands may also show up an interactive commandline wizard where appropriate values needs to be keyed in.
* Each command/subcommand also has a "short name" as well. You can use the full command name or the short name.  Below is an overview of top level commands. The short names are also shown:

```
~$ ioxclient
NAME:
   ioxclient - Command line tool to assist in app development for Cisco IOx platforms

USAGE:
   ioxclient [global options] command [command options] [arguments...]

VERSION:
   0.3.0

AUTHOR:
  Harish Vishwanath - <havishwa@cisco.com>

COMMANDS:
   debug, dbg		Set debug to on or off
   showguide, guide	View ioxclient reference guide
   application, app	Manage lifecycle of applications
   service, svc		Manage lifecycle of services
   package, pkg		Package an iox application/service/cartridge. Produces an IOx compatible archive
   platform, plt	Manage IOx platform
   cartridge, cr	Create/Delete/List cartridges
   profiles, pr		Profile related commands
   help, h		Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --help, -h			show help
   --generate-bash-completion
   --version, -v		print the version
```

For instance,

```
$ ioxclient showguide
<-- is same as -->
$ ioxclient guide
```

* Whenever the tool asks for inputs, a default value is indicated in square brackets ([]). If you are okay with the default value, just hit enter and the tool will use the value shown as the default. For example:

```
Your IOx platform's port number[8443] :   <= Hitting enter will cause the port to be 8443.
```

* To get help, simply type:

```
$ ioxclient -h OR ioxclient --help
```

* To get help for a specific command/subcommand :

```
~$ ioxclient  application
NAME:
   ioxclient application - Manage lifecycle of applications

USAGE:
   ioxclient application command [command options] [arguments...]

COMMANDS:
   list, li		List installed applications on the system
   install, in		Install an application
   start, sta		Start an installed application
   stop, stp		Stop an installed application
   restart, rs		Restart an installed application
   status, sts		Get current status of an installed application
   info, inf		Get info pertaining to an installed application
   activate, act	Activate application
   deactivate, deact	Deactivate Application
   uninstall, unin	Uninstall an installed application
   upgrade, upgr	Upgrade an application
   getconfig, getconf	Get config information of an installed application
   setconfig, setconf	Set config information for an installed application from the specified file
   getloginfo, loginf	Get log files info for an installed application
   taillog, tllg	Get last n lines from a specific log file
   console, con		Connect to the console of the application
   downloadlog, dllg	Download application log files
   metrics, met		Get resource usage metrics of installed applications
   help, h		Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion


~$ ioxclient  application install
NAME:
   install - Install an application

USAGE:
   command install <application_id> <archive>


```

* Notation for command parameters.
 * any parameter indicated within <> is mandatory
 * any parameter indicated within \[\] is optional. If it is not specified, a default value is assumed. The defaults are indicated in the "help" for that command.
  * Mandatory parameter example:


```
~$ ioxclient  application install myapp
Insufficient Args.

NAME:
   install - Install an application

USAGE:
   command install <application_id> <archive>

```

   * Optional parameter example:

```
~$ ioxclient  platform events -h
NAME:
   events - Get platform events

USAGE:
   command events [fromseq] [toseq]. If not specified, default value is -1

```


## Configuring ioxclient

The first time ioxclient is used, a wizard will be shown asking a few questions based on which ioxclient will configure itself. It will also create a "default" profile that captures connection information with an IOx device. Creating and using additional profiles will be described in further sections.

```
~$ ioxclient
Config file not found :  /home/hvishwanath/.ioxclientcfg.yaml
Creating one time configuration..
Your / your organization's name : cisco
Your / your organization's URL : www.cisco.com
Your IOx platform's IP address[127.0.0.1] : 72.163.111.112
Your IOx platform's port number[8443] : 8443
Authorized user name[root] : appdev
Password for appdev :
Local repository path on IOx platform[/software/downloads]:      
URL Scheme (http/https) [https]: https
API Prefix[/iox/api/v2/hosting/]:         
Your IOx platform's SSH Port[2222]: 22
Activating Profile  default

```

* The tool creates a default profile. Each profile has information about how to connect to a specific Cisco IOx platform.
* The profile data is stored in $HOME/.ioxclientcfg.yaml file. Do not attempt to manually edit this file. Use `ioxclient profiles` commands to manipulate profile related information. Described in detail in the sections below.

## Managing profiles

ioxclient facilitates working with multiple IOx devices. Connection information to each such device is stored as a profile. Any ioxclient command used, is always run in the context of the currently *active* profile.

Profiles can be managed via `ioxclient profiles` and its subcommands.

```
~$ ioxclient  profiles
Active Profile :  default
NAME:
   ioxclient profiles - Profile related commands

USAGE:
   ioxclient profiles command [command options] [arguments...]

COMMANDS:
   list, l	List all existing profiles
   show, s	Show currently active profile
   create, c	Create a new profile
   activate, a	Activate specified profile
   delete, d	Delete specified profile
   reset, rs	Reset profile data
   help, h	Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion

```

### Creating a profile

If you want to interact with a new IOx device, add relevant information by creating a profile. Give a handy name to the profile so that it is easier to remember while switching between profiles.

```
~$ ioxclient  profiles create
Active Profile :  default
Enter a name for this profile : sandbox
Your IOx platform's IP address[127.0.0.1] : 192.168.3.1
Your IOx platform's port number[8443] :
Authorized user name[root] : appdev
Password for appdev :
Local repository path on IOx platform[/software/downloads]:
URL Scheme (http/https) [https]:
API Prefix[/iox/api/v2/hosting/]:
Your IOx platform's SSH Port[2222]: 22
Activating Profile  sandbox

```

> Note: When a new profile is created, it automatically gets activated.

### Listing existing profiles

```
~$ ioxclient  profiles list
Active Profile :  sandbox
Profile Name :  default
	Host IP:  72.163.111.112
	Host Port:  8443
	Auth Keys:  YXBwZGV2OmFwcGRldg==
	Auth Token:  
	Api Prefix:  /iox/api/v2/hosting/
	URL Scheme:  https
Profile Name :  sandbox
	Host IP:  192.168.3.1
	Host Port:  8443
	Auth Keys:  YXBwZGV2OmFwcGRldg==
	Auth Token:  
	Api Prefix:  /iox/api/v2/hosting/
	URL Scheme:  https

```

### Show currently activated profile

```
~$ ioxclient  profiles show
Active Profile :  sandbox
Profile Name :  sandbox
	Host IP:  192.168.3.1
	Host Port:  8443
	Auth Keys:  YXBwZGV2OmFwcGRldg==
	Auth Token:  
	Api Prefix:  /iox/api/v2/hosting/
	URL Scheme:  https

```

### Activating a profile

```
~$ ioxclient  profiles activate sandbox
Active Profile :  default
Activating Profile  sandbox

```

### Deleting a profile

```
~$ ioxclient  profiles delete sandbox
Active Profile :  sandbox
Deleting profile  sandbox

```

> Note that deleting "default" profile is not supported.

```
~$ ioxclient  profiles delete default
Active Profile :  default
Cannot delete the default profile
If you want startover, use the 'reset' command instead

```

> Note: Editing an existing profile is not supported. If you would like to reuse an existing profile name, simply delete it and recreate it with desired values.

### Overriding profile for a given command

`ioxclient` commands operate in the context of the currently active profile. However, in some use cases you may want to use a specific profile for a given command without changing active profile. This can be achieved by passing a valid profile name to the global `--profile` option.

When `--profile` option is set, `ioxclient` will use the profile name passed to the option for the currently run command. After the execution of the command, the previously active profile will be restored back.

```
$ ./ioxclient --profile local application list
Currently active profile :  default
Overriding profile to local for this command
Activating Profile  local
Command Name: application-list
List of installed App :
 1. py         --->    RUNNING
Activating Profile  default

```


### Resetting config information

This removes the existing configuration information stored by the tool. After this command, just type `ioxclient` which will prompt for fresh config information.

```
~$ ioxclient  profiles reset
Active Profile :  default
Your current config details will be lost. Continue (Y/n) ? : Y
Current config backed up at  /tmp/hvishwanath/ioxclient291276906
Config data deleted.

```

> When reset is issued, the tool backs up the existing config into a temporary file. If you want to store it, make sure you copy the temporary file to a location you will remember.

## Application management

The following sections describe usage of ioxclient to manage applications. Below are the application management commands:

```
$ ./ioxclient  application
NAME:
   ioxclient application - Manage lifecycle of applications

USAGE:
   ioxclient application command [command options] [arguments...]

COMMANDS:
   list, li		List installed applications on the system
   install, in		Install an application
   start, sta		Start an installed application
   stop, stp		Stop an installed application
   restart, rs		Restart an installed application
   status, sts		Get current status of an installed application
   info, inf		Get info pertaining to an installed application
   activate, act	Activate application
   deactivate, deact	Deactivate Application
   uninstall, unin	Uninstall an installed application
   upgrade, upgr	Upgrade an application
   getconfig, getconf	Get config information of an installed application
   setconfig, setconf	Set config information for an installed application from the specified file
   logs, lgs		Manage log files
   datamount, dm	Manage contents of application's data mount directory
   appdata, appdata	Manage files in the appdata directory under datamount
   console, con		Connect to the console of the application
   metrics, met		Get resource usage metrics of installed applications
   help, h		Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion

```

> Ensure that you have right profile activated.

### Packaging an application

You would typically use IOx SDK to create and package your application. `ioxclient` also provides ability to ONLY package an already created application.

```
$ ioxclient package
NAME:
   package - Package an iox application/service/cartridge. Produces an IOx compatible archive

USAGE:
   command package [command options] <path_to_dir>

OPTIONS:
   --use-targz	Use this to use gz compression on package

```

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  package .
Currently active profile :  local
Command Name: package
Checking if package descriptor file is present..
Created Staging directory at :  /tmp/hvishwanath/886820621
Copying contents to staging directory
Checking for application runtime type
Couldn't detect application runtime type
Creating an inner envelope for application artifacts
Excluding  package.tar
Excluding  package.tar.gz
Generated  /tmp/hvishwanath/886820621/artifacts.tar.gz
Calculating SHA1 checksum for package contents..
Root Directory :  /tmp/hvishwanath/886820621
Output file:  /tmp/hvishwanath/632612616
Path:  artifacts.tar.gz
SHA1 : acdca0a8f03ed7e5c79ee57f22965c91ac037ec8
Path:  package.yaml
SHA1 : 031db90866b722e361f6b60a565e7096511d61f1
Path:  package_config.ini
SHA1 : 69b9727a3587268994b7461bdbdb9e807df4a3d6
Generated package manifest at  package.mf
Generating IOx Package..
Created IOx package at :  /home/hvishwanath/projects/sample-apps-v2/paas/python/nettest/package.tar


```

> In the above command "." is supplied - indicating that package the current directory.
> ioxclient ensures that the path supplied for package command contains all the required files before packaging.
> Refer to IOx package documentation for more details about the structure and layout of the package.
> Successful completion of this command creates a "package.tar.gz" that can be used for installation on your IOx device.

### Installing an application

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application install nettest ./package.tar.gz
Currently using profile :  default
Command Name: application-install
Installation Successful. App is available at :  https://127.0.0.1:8443/iox/api/v2/hosting/apps/nettest
Successfully deployed
```

### Installing an application with dependent IOx Services

A user who wants the dependencies of the application to be taken care of, can specify the ioxclient to resolve dependencies in two methods - 

There are three flags available to achieve this functionality - 

* **--resolve-dependencies or --rd** : specify this flag to enable automatic dependency resolution
* **--service-source or --src** : specify a folder containing service bundles to use them for dependency resolution. If no folder is specified, fogportal will be searched for the required packages.
* **--service-activation-payload or --p** - where the path of the activation payload for services is specified. 
	
#### Resolve Service Dependencies from the Fog portal -
 Here, the installer searches for the required services from the Fog portal, downloads them into a temp folder and installs, activates using the activation payload, and runs them in order to install the required application  


```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application install nettest ./package.tar.gz --resolve-dependencies --service-activation-payload activation-file.json
```

Output -

```
~$ioxclient app in oauth sample-oauth.tar --rd --p test_resources\nat-activation.json
Currently active profile :  vm211
Command Name: application-install
Resolve Dependencies flag specified by user
Reading  sample-oauth.tar ......
Parsing  sample-oauth.tar .yaml
map[sample-app:{{{sample-app} { paas {[{1 true urn:cisco:system:service:nbi}]} {50}} {[]}} false 2 sample-oauth.tar -1 false}]map[]map[urn:cisco:system:service:nbi:{{1 true urn:cisco:syste
Checking CAF for the already existing services
Existing services in CAF are -
Resolving dependencies from Fog portal
Checking fog portal for the dependencies that are not in CAF
Requesting  http://10.78.106.35:8090/api/v1/fogportal/service_bundles/
Requesting -   http://10.78.106.35:8090/api/v1/fogportal/service_bundles/
The following services are available in the Fog portal
1 .  Middleware Message Broker
2 .  middleware-core
Saving current configuration
Constructing a Dependency tree for sample-app
|_sample-app
|_|_middleware-core
|_|_|_Middleware Message Broker
Checking CPU architecture compatibility of the service  Middleware Message Broker
Middleware Message Broker  is present in the FogPortal
Downloading  Middleware Message Broker ....
200 OK

C:\Users\cheb\AppData\Local\Temp\185222e322175b49ebe62449798d47f48dbe449932d5b752e2c7a2321031952b with 3319559 bytes downloaded
Service bundle to be stored in  C:\Users\cheb\AppData\Local\Temp\185222e322175b49ebe62449798d47f48dbe449932d5b752e2c7a2321031952b
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/MiddlewareMessageBroker
Successfully deployed
Payload file : test_resources\nat-activation.json. Will pass it as application/json in request body..
Service MiddlewareMessageBroker is Activated
Service MiddlewareMessageBroker is Started

Resolved status of  Middleware Message Broker  -  true
middleware-core  is present in the FogPortal
Downloading  middleware-core ....
200 OK

C:\Users\cheb\AppData\Local\Temp\9b22331ad31f16c00c108f7c4de8cda0796304632664175cbece439d18a21ca8 with 13270313 bytes downloaded
Service bundle to be stored in  C:\Users\cheb\AppData\Local\Temp\9b22331ad31f16c00c108f7c4de8cda0796304632664175cbece439d18a21ca8
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/middlewareCore
Successfully deployed
Payload file : test_resources\nat-activation.json. Will pass it as application/json in request body..
Service middlewareCore is Activated
Service middlewareCore is Started

Resolved status of  middleware-core  -  true
Installation Successful. App is available at : https://10.78.106.211:8443/iox/api/v2/hosting/apps/oauth
Successfully deployed
```

 
#### Resolve Service Dependencies from the folder -
 In this case, the specified folder is searched for the required dependencies and the ones required are installed, activated and started in order to install the application.

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application install nettest ./package.tar.gz --resolve-dependencies --src path/to/service/bundles --service-activation-payload activation-file.json
```

Output -

```
~$ioxclient app in apc package.tar.gz --rd localrepo --f path/to/folder --p activation-file.json
Currently active profile :  vm211
Command Name: application-install
Resolve Dependencies flag specified by user
Reading  test_resources\fog-apps\apcargo-fog-app-master-72c451defc2c1f2e33bcc4ef24745e0b4019dcb0\package.tar.gz ......
Reading .yaml of  package.tar.gz
Checking CAF for the already existing services
Existing services in CAF are -
Flag for Local repository dependency resolution recognized
Searching the specified local repo for the dependencies..
Unpacking  dartBroker.tar.gz
Reading  test_resources\svc-bundles\dartBroker.tar.gz ......
Reading .yaml of  dartBroker.tar.gz
Unpacking  mw-package.tar.gz
Reading  test_resources\svc-bundles\mw-package.tar.gz ......
Reading .yaml of  mw-package.tar.gz
Resolving dependencies for  APCargo
|_Resolving  APCargo
|_|_Resolving  iox:middleware:core
|_|_|_Resolving  Middleware Message Broker
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/MiddlewareMessageBroker
Successfully deployed
Payload file : test_resources\nat-activation.json. Will pass it as application/json in request body..
Service MiddlewareMessageBroker is Activated
Service MiddlewareMessageBroker is Started

Resolved status of  Middleware Message Broker  -  true
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/ioxMiddlewareCore
Successfully deployed
Payload file : test_resources\nat-activation.json. Will pass it as application/json in request body..
Service ioxMiddlewareCore is Activated
Service ioxMiddlewareCore is Started

Resolved status of  iox:middleware:core  -  true
Installation Successful. App is available at : https://10.78.106.211:8443/iox/api/v2/hosting/apps/apc
Successfully deployed
```

### Activating application

An application has to be activated before starting. At the time of activation, the developer/administrator has to supply the right resource mapping based on what the application needs.

> Refer IOx application states documentation for more information about application states.
> Refer IOx application descriptor documentation for more information about application resource requirements.

For ex, the above installed app asks for network interface. That interface has to be associated with the right logical network available on the device. Similarly, you could assign the right device, map external ports etc.,

```
$ ./ioxclient  application activate
NAME:
   activate - Activate application

USAGE:
   command activate [command options] <application_id>

DESCRIPTION:

Activation of an app causes the resources to be committed.
Pass a JSON file with the right payload. Here is a sample:

* port_map: The mode (auto, 1to1) governs how the ports are mapped.
* If no mode is given, auto is the default
* A mode can be specified, and you can still set a custom port mapping for individual/range of ports that overrides the mode settings.
{
	"resources": {
		"profile": "custom",
		"cpu": "50",
		"memory": "50",
		"disk": "100",
		"devices": [{
			"type": "serial",
			"label": "HOST_DEV1",
			"device-id": "/dev/ttyS1"
		}],
		"network": [{
			"interface-name": "eth0",
			"network-name": "iox-nat0",
			"port_map": {
				"mode": "auto",
				"tcp": {
					"9000": "15000",
					"10100-10200": "20100-20200"
				},
				"udp": {
					"19000": "25000"
				}
			}
		}]
	}
}


OPTIONS:
   --payload 	Pass the path to a JSON file containing your payload
   --debug 	Set to on/off.

```

> Pass a JSON file path to --payload that contains the right activation payload.

For the above app, we will use a "activation.json" that contains the right content.

```json
{
	"resources": {
		"profile": "c1.small",
		"network": [{"interface-name": "eth0", "network-name": "iox-nat0"}]
	}
}

```

> We are associating "eth0" interface requested by the app to "iox-nat0" network available on the device
> We are also setting the resource profile to "c1.small"

> **A note about "--debug" flag**
>> At the time of activation, you can set the `--debug on`. Setting this instructs the IOx platform to activate this app in debug mode. For platforms that use LXC container technology this means that even if the application stops/crashes, the container is still kept running, so that you can connect to the application console for further debugging.

Here is a sample activation command:

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application activate nettest --payload activation.json
Currently using profile :  default
Command Name: application-activate
Payload file : activation.json. Will pass it as application/json in request body..
App nettest is Activated

```

### Starting the application

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application start nettest
Currently using profile :  default
Command Name: application-start
App nettest is Started
```

### View application information

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application info nettest
Currently using profile :  default
Command Name: application-info
Details of App : nettest
-----------------------------
{
 "appCustomOptions": "",
 "appType": "paas",
 "author": "Cisco Systems",
 "authorLink": "http://www.cisco.com",
 "dependsOn": {
  "cartridges": [
   {
    "id": "urn:cisco:system:cartridge:language-runtime:python",
    "version": "2.7"
   }
  ]
 },
 "description": "Provides a REST end point on port 9000 and also tests outbound traffic",
 "id": "nettest",
 "is_service": false,
 "name": "PyNetTest",
 "networkInfo": {
  "eth0": {
   "ipv4": "192.168.223.10",
   "ipv6": null,
   "libvirt_network": "dpbr_n_0",
   "mac": "52:54:99:99:00:00",
   "mac_address": "52:54:99:99:00:00",
   "network_name": "iox-nat0",
   "port_mappings": {
    "tcp": [
     [
      9000,
      40003
     ]
    ],
    "udp": [
     [
      10000,
      42003
     ]
    ]
   }
  }
 },
 "resources": {
  "cpu": 200,
  "disk": 10,
  "memory": 64,
  "network": [
   {
    "interface-name": "eth0",
    "network-name": "iox-nat0",
    "ports": {
     "tcp": [
      9000
     ],
     "udp": [
      10000
     ]
    }
   }
  ],
  "profile": "c1.small",
  "vcpu": 1
 },
 "state": "RUNNING",
 "toolkitServicesUsed": null,
 "version": "1.5"
}

```

### Listing all the applications on the system

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application list
Currently using profile :  default
Command Name: application-list
List of installed apps :
 1. nettest    --->    STOPPED

```

### View application status

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application status nettest
Currently using profile :  default
Command Name: application-status
App nettest is RUNNING
```

### Get application bootstrap configuration

```
$ ioxclient application getconfig nettest
Currently using profile :  default
Command Name: application-getconfig
Retrieved app config successfully. Content stored at nettest-app_config.ini

```

### Setting application bootstrap configuration

You can set the application bootstrap configuration by passing a new configuration file.

Usage:

```
$ ioxclient  application setconfig
NAME:
   setconfig - Set config information for an installed application from the specified file

USAGE:
   command setconfig <application_id> <config_file> [log_level]

```

If the content is present in a "config.ini" file, you can use the command as below:

```
$ioxclient application setconfig nettest config.ini
Currently using profile :  default
Command Name: application-setconfig
Successfully updated apps configuration.

```

### Managing application logs

`ioxclient` provides CLIs to manage application log files.

#### Getting application log information

```
$ ./ioxclient  application logs info py
Currently active profile :  default
Command Name: application-logs-info

Log file information for :  py
	Size_bytes : 1.275576e+06
	Download_link : /admin/download/logs?filename=py-stdout.log
	Timestamp : Fri May 13 22:42:29 2016
	Filename : stdout.log

	Download_link : /admin/download/logs?filename=py-container_log_py.log
	Timestamp : Fri May 13 16:38:11 2016
	Filename : container_log_py.log
	Size_bytes : 17064

```

#### Downloading a log file

Download a log file by its name. If name is not provided, it is prompted for.

```
$ ./ioxclient  application logs download
NAME:
   download - Download a log file

USAGE:
   command download <application_id>[file_path]

$ ./ioxclient  application logs download py stdout.log
Currently active profile :  default
Command Name: application-logs-download
Retrieved log file successfully. Content stored at py-c3Rkb3V0LmxvZw==

```

#### Viewing last few lines of a particular log file

You can view last n lines of a log file by providing its name and the number of lines to be tailed. If the parameters are not part of the command, they are prompted for.

```
$ ./ioxclient  application logs tail
NAME:
   tail - Get last n lines from a specific log file

USAGE:
   command tail <application_id>[file_path][n_lines]


 $ ./ioxclient  application logs tail  py stdout.log 3
 Currently active profile :  default
 Command Name: application-logs-tail
 App/Service : py, Logfile : stdout.log, viewing last 3 lines
 1 packets transmitted, 1 packets received, 0% packet loss
 round-trip min/avg/max = 42.133/42.133/42.133 ms

```
#### Deleting a log file

Delete a log file by its name. If not provided, it is prompted for.

```
$ ./ioxclient  application logs delete
NAME:
   delete - Delete a log file

USAGE:
   command delete <application_id>[file_path]

$ ./ioxclient  application logs delete py stdout.log
Currently active profile :  default
Command Name: application-logs-delete
Log file stdout.log successfully deleted

```

#### Purge all application log files

```
$ ./ioxclient  app logs purge py
Currently active profile :  default
Command Name: application-logs-purge
All application log files are successfully purged

```

### Managing application core files

Applications may coredump generating core files. `ioxclient` provides CLIs to manage these core files.

#### List application core files

```
$ ioxclient app cores list
NAME:
   list - List core files

USAGE:
   command list <app_id>


$ ioxclient app cores list py
Currently active profile :  local
Command Name: application-cores-list
Core file list:
------------------------
1. core.ping.162.1465195133 (413696.000000 bytes)

```

#### Download core files

```
$ ioxclient app cores download
NAME:
   download - Download a core file

USAGE:
   command download <app_id>[file_path]

$ ioxclient app cores download py core.ping.162.1465195133
Currently active profile :  local
Command Name: application-cores-download
Downloading file core.ping.162.1465195133
Read bytes :  413696
App corefile successfully downloaded at core.ping.162.1465195133

```

### Download app's datamount contents

An app will be provisioned with a data mount disk where the app typically stores its data that needs to be persisted. You can download the contents of this disk as a compressed tar ball.

```
$ ./ioxclient  application datamount download py
Currently active profile :  local
Command Name: application-datamount-download
Read bytes :  2697
Datamount Content for py is downloaded at py-datamount.tar.gz
$ tar tzvf py-datamount.tar.gz
drwxr-xr-x root/root         0 2016-05-13 16:37 py/
-rw-r--r-- root/root       453 2016-05-13 16:37 py/.env
drwx------ root/root         0 2016-05-13 16:37 py/lost+found/
drwxr-xr-x root/root         0 2016-05-13 22:18 py/appdata/
-rw------- root/root      3714 2016-05-13 21:59 py/appdata/12network_config.yaml
drwxr-xr-x root/root         0 2016-05-13 22:55 py/logs/
-rw-r--r-- root/root        84 2016-05-13 22:55 py/logs/watchDog.log
-rw-r--r-- root/root      1923 2016-05-13 22:55 py/logs/stdout.log
-rw-r--r-- root/root        18 2016-05-13 16:37 py/package_config.ini

```

### Managing contents of "appdata" directory

IOx CAF provides file management to upload, download adhoc data files. These files are typically stored in `appdata` directory in the persistent storage.

```
$ ./ioxclient app appdata
NAME:
   ioxclient application appdata - Manage files in the appdata directory under datamount

USAGE:
   ioxclient application appdata command [command options] [arguments...]

COMMANDS:
   view, vi		View the files/directories under appdata. If a file is chosen, it will be downloaded
   upload, upload	Upload a new file to a target path
   delete, del		Delete a file/directory under appdata
   help, h		Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion

```

#### Upload adhoc data files

```
$ ./ioxclient app appdata upload
NAME:
   upload - Upload a new file to a target path

USAGE:
   command upload <application_id><input_file><target_path>

$ ./ioxclient app appdata upload py test_resources/app.tar.gz 1/2/app.tar.gz
Currently active profile :  local
Command Name: application-appdata-upload
Upload Successful. File is available at :  https://127.0.0.1:8443/iox/api/v2/hosting/apps/py/appdata/1/2/app.tar.gz
https://127.0.0.1:8443/iox/api/v2/hosting/apps/py/appdata/1/2/app.tar.gz

```

#### View / Download adhoc data files

```
$ ./ioxclient app appdata view
NAME:
   view - View the files/directories under appdata. If a file is chosen, it will be downloaded

USAGE:
   command view <application_id>[file_path]

$ ./ioxclient app appdata view py 1/2
Currently active profile :  local
Command Name: application-appdata-view
Directory Listing for path: 1/2
                         Name	 Type	  Size
-----------------------------------------------------------
                   app.tar.gz	 file	4958.000000

$ ./ioxclient app appdata view py 1/2/app.tar.gz
Currently active profile :  local
Command Name: application-appdata-view
Downloading file 1/2/app.tar.gz
Read bytes :  4958
File 1/2/app.tar.gz is downloaded at app.tar.gz

```
#### Delete adhoc data files/directories

```
$ ./ioxclient app appdata delete
NAME:
   delete - Delete a file/directory under appdata

USAGE:
   command delete <application_id><file_path>


$ ./ioxclient app appdata delete py 1
Currently active profile :  local
Command Name: application-appdata-delete
File or Directory 1 successfully deleted!

```
### Connecting to application console

You can connect to the console of your application.

While creating your profile, if the SSH_PORT is configured, `ioxclient` automatically tries to connect and drop you into a shell connected to applications console. If the port is not configured, then it prints out a template command that you can execute using a ssh client.

```
$ ./ioxclient application console py
Currently active profile :  default
Command Name: application-console
Console setup is complete..
The device's SSH port is not configured! Cannot auto connect!Please run the below command :
ssh -p {SSH_PORT} -i py.pem appconsole@127.0.0.1

```

> SSH_PORT is the ssh port on which the SSH server on the device is bound. Note that it can be a non standard port depending on the NAT rules configured on the device.

If the SSH_PORT is configured correctly, you will be automatically connected. Hit `Ctrl+C` to exit.

```
$ ./ioxclient application console py
Currently active profile :  local
Command Name: application-console
Console setup is complete..
Attempting to automatically connect.., press Ctrl+C to exit
Connecting to appconsole@127.0.0.1:22 using pem file py.pem
Connected to domain py
Escape character is ^]


root@ir800-lxc:~# ps
ps
  PID USER       VSZ STAT COMMAND
    1 root      4208 S    init [5]
  118 root      7784 S    udhcpc -R -b -p /var/run/udhcpc.eth0.pid -i eth0
  122 root      7784 S    {startcontainer.} /bin/sh /bin/startcontainer.sh
  127 root      294m S    python /appdir/app/main.py
  139 root      7784 S    /sbin/syslogd -n -O /var/log/messages
  142 root      7784 S    /sbin/klogd -n
  145 root     12012 S    -sh
 5274 root      7784 S    /sbin/getty 38400 tty2
 5275 root     10548 S    ping -c 1 www.google.com
 5276 root     12012 R    ps
root@ir800-lxc:~# ^C
$
```

### Getting application metrics

The metrics command shows the resources used by the application.

```
~$ ioxclient  application metrics nettest
Currently using profile :  default
Command Name: application-metrics
Host ID : 564D7AD1-641A-3FC3-0C41-3313E82D27AB
-------------------Resource usage by app------------------
AppID : nettest, RUNNING
	memory (current, in KB) : 6688
	cpu (current, in percent) : 0.01
	network (current, in bytes) : 99601
	disk (current, in MB) : 0.03

```


### Stopping the application

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application stop nettest
Currently using profile :  default
Command Name: application-stop
App nettest is Stopped

```

### Deactivating the application

```
~/projects/sample-apps-v2/paas/python/nettest$ ioxclient  application deactivate nettest
Currently using profile :  default
Command Name: application-deactivate
App nettest is Deactivated

```

### Upgrading the application

```
$ ioxclient application upgrade nettest app.tar.gz
Currently using profile :  default
Command Name: application-upgrade
Preserve app data across upgrade(y/N)? [y] :
Upgrade Successful. App is available at :  https://127.0.0.1:8443/iox/api/v2/hosting/apps/ioxclient_test_app/nettest
Upgrade successful.

```

### Uninstalling the application

```
$ ioxclient application uninstall nettest
Currently using profile :  default
Command Name: application-uninstall
Successfully uninstalled app  nettest

```

## Managing IOx services lifecycle

The service management commands are available via `ioxclient service` set of commands. The operation and usage of these commands are same as that of the application management commands.

```
$ ioxclient  service
NAME:
   ioxclient service - Manage lifecycle of services

USAGE:
   ioxclient service command [command options] [arguments...]

COMMANDS:
   list, li		            List installed services on the system
   install, in		        Install a service
   start, sta		        Start an installed service
   stop, stp		        Stop an installed service
   restart, rs		        Restart an installed service
   status, sts		        Get current status of an installed service
   info, inf		        Get info pertaining to an installed service
   activate, act	        Activate Service
   deactivate, deact	    Deactivate Service
   uninstall, unin	        Uninstall an installed service
   upgrade, upgr	        Upgrade a service
   getconfig, getconf	    Get config information of an installed service
   setconfig, setconf	    Set config information for an installed service from the specified file
   infrastructure,infra     Used for device provisioning, messaging,
   logs, lgs		        Manage log files
   datamount, dm	        Manage contents of service's data mount directory
   appdata, appdata	        Manage files in the appdata directory under datamount
   console, con		        Connect to the console of the service
   metrics, met		        Get resource usage metrics of installed services
   help, h		            Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion


```

### Installing a service with dependent IOx Services

A user who wants the dependencies of the services to be taken care of, can specify the ioxclient to resolve dependencies in two methods - 

There are three flags available to achieve this functionality - 

* **--resolve-dependencies or --rd** : specify this flag to enable automatic dependency resolution
* **--service-source or --src** : specify a folder containing service bundles to use them for dependency resolution. If no folder is specified, fogportal will be searched for the required packages.
* **--service-activation-payload or --p** - where the path of the activation payload for services is specified. 
	
#### Resolve Service Dependencies from the Fog portal
 Here, the ioxclient searches for the required services from the Fog portal, downloads them into a temp folder and installs, activates using the activation payload, and runs them in order to install the required service
 

A sample service install is as follows - 


```
~$ioxclient svc in mw test_resources\svc-bundles\mw-core.tar.gz --rd --p test_resources\nat-activation.json
```
**Sample Output**

```
Currently active profile :  vm211
Command Name: service-install
Resolve Dependencies flag specified by user
Reading  test_resources\svc-bundles\mw-core.tar.gz ......
Parsing  mw-core.tar.gz .yaml
Checking CAF for the already existing services
Existing services in CAF are -
Resolving dependencies from Fog portal
Checking fog portal for the dependencies that are not in CAF
Requesting  https://128.107.5.61:443/api/v1/fogportal/service_bundles/
Requesting -   https://128.107.5.61:443/api/v1/fogportal/service_bundles/
The following services are available in the Fog portal
1 .  middleware-core
2 .  Middleware Message Broker
Saving current configuration
Constructing a Dependency tree for middleware-core
|_middleware-core
|_|_Middleware Message Broker
Checking CPU architecture compatibility of the service  Middleware Message Broker
Middleware Message Broker  is present in the FogPortal
Downloading  Middleware Message Broker ....
Service bundle to be stored in  C:\Users\xyz\AppData\Local\Temp\185222e322175b49ebe62449798d47f48dbe449932d5b752e2c7a2321031952b
Installing the service  Middleware Message Broker
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/MiddlewareMessageBroker
Successfully deployed
Activating the service  Middleware Message Broker
Payload file : test_resources\nat-activation.json. Will pass it as application/json in request body..
Service MiddlewareMessageBroker is Activated
Starting the service  Middleware Message Broker
Service MiddlewareMessageBroker is Started

Resolved status of  Middleware Message Broker  -  true
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/mw
Successfully deployed

```

#### Resolve Service Dependencies from the folder
 In this case, the specified folder is searched for the required dependencies and the ones required are installed, activated and started in order to install the service.

```
~$ioxclient svc in mw test_resources\svc-bundles\mw-core.tar.gz --rd --src test_resources\svc-bundles -p test_resources\nat-activation.json
```

**Sample Output**

```
 Currently active profile :  vm211
 Command Name: service-install
 Resolve Dependencies flag specified by user
 Reading  test_resources\svc-bundles\mw-core.tar.gz ......
 Parsing  mw-core.tar.gz .yaml
 Checking CAF for the already existing services
 Existing services in CAF are -
 Resolving dependencies from the specified Local respository
 Searching the specified local repo for the dependencies..
 Unpacking  MessageBus.tar.gz
 Reading  test_resources\svc-bundles\MessageBus.tar.gz ......
 Parsing  MessageBus.tar.gz .yaml
 Unpacking  mw-core.tar.gz
 Reading  test_resources\svc-bundles\mw-core.tar.gz ......
 Parsing  mw-core.tar.gz .yaml
 Saving current configuration
 Constructing a Dependency tree for middleware-core
 |_middleware-core
 |_|_Middleware Message Broker
 Checking CPU architecture compatibility of the service  Middleware Message Broker
 Installing the service  Middleware Message Broker
 Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/MiddlewareMessageBroker
 Successfully deployed
 Activating the service  Middleware Message Broker
 Payload file : test_resources\nat-activation.json. Will pass it as application/json in request body..
 Service MiddlewareMessageBroker is Activated
 Starting the service  Middleware Message Broker
 Service MiddlewareMessageBroker is Started

 Resolved status of  Middleware Message Broker  -  true
 Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/mw
 Successfully deployed

```

## Platform management

ioxclient also provides CLIs to view and manage platform related information. Here are the list of platform commands:

```
~$ ioxclient  platform
NAME:
   ioxclient platform - Manage IOx platform

USAGE:
   ioxclient platform command [command options] [arguments...]

COMMANDS:
   resourcemanager, rsmgr	View resource manager information
   techsupport, ts		Manage techsupport snapshots
   network, nw			Manage logical networks on the platform
   core, core			Manage core files on the platform
   downloadlog, dllg		Download platform log files
   capability, cap		Get platform capability info
   events, ev			Get platform events
   health, hlt			Get platform health info
   info, inf			Get platform info
   help, h			Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion

```
### View resource manager data

CAF has an internal resource manager responsible for allocating and keeping track of resources such as cpu, memory, disk, serial devices etc., to applications.

#### View Resource Profile definitions

A Resource Profile encapsulates a set of resources (cpu, memory etc.,) under a unique name in a consistent fashion across all cisco's IOx platforms. To see the supported resource profile definitions and their values:

```
$ ioxclient platform  resourcemanager profiles                                                         
Currently using profile :  local
Command Name: plt-rsmgr-profiles
Profile Definitions :
-----------------------------
{
 "c1.large": {
  "cpu": 600,
  "memory": 256,
  "vcpu": 1
 },
 "c1.medium": {
  "cpu": 400,
  "memory": 128,
  "vcpu": 1
 },
 "c1.small": {
  "cpu": 200,
  "memory": 64,
  "vcpu": 1
 },
 "c1.tiny": {
  "cpu": 100,
  "memory": 32,
  "vcpu": 1
 },
 "c1.xlarge": {
  "cpu": 1200,
  "memory": 256,
  "vcpu": 1
 },
 "default": {
  "cpu": 200,
  "memory": 64,
  "vcpu": 1
 }
}

```

#### View resource allocation information

It is possible to view the inventory of resources and allocations maintained by resource manager.

```
$ ioxclient platform resourcemanager allocations
Currently using profile :  local
Command Name: plt-rsmgr-allocations
Resource Allocation Info :
-----------------------------
{
"cpu": {
 "app_cpu_allocations": [
  {
   "py": 600
  },
  {
   "sim": 200
  }
 ],
 "available_cpu": 200,
 "total_cpu": 1000
},
"devices": {
 "app_device_mapping": []
},
"disk": {
 "app_disk_allocations": [
  {
   "py": 10
  },
  {
   "sim": 30
  }
 ],
 "available_persistent_disk": 216,
 "total_persistent_disk": 256
},
"memory": {
 "app_memory_allocations": [
  {
   "py": 256
  },
  {
   "sim": 64
  }
 ],
 "available_memory": 4800,
 "total_memory": 5120
}
}

```

### Manage techsupport snapshots on the device

Techsupport snapshots are basically archive files that contain critical platform logs, statistics about platform health etc., These files can be used to analyze and troubleshoot any issues on the platform.

Techsupport commands are as below:

```
~$ ioxclient  platform techsupport
NAME:
   ioxclient platform techsupport - Manage techsupport snapshots

USAGE:
   ioxclient platform techsupport command [command options] [arguments...]

COMMANDS:
   list, li		List all existing techsupport files
   create, c		Create a new techsupport snapshot file
   delete, d		Delete a techsupport snapshot file
   download, dnld	Download a techsupport snapshot file
   help, h		Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion

```

#### Create a techsupport snapshot

```
~$ ioxclient  platform techsupport create
Currently using profile :  default
Command Name: plt-ts-create
A new techsupport snapshot has been generated. File name is  tech_support_2016-01-08_04.00.55.tar.gz

```

#### List techsupport files on the platform

```
~$ ioxclient platform techsupport list
Currently using profile :  default
Command Name: plt-ts-list
List of techsupport files on the system :
1  ---> tech_support_2016-01-08_04.00.55.tar.gz
2  ---> tech_support_2016-01-05_14.35.41.tar.gz
3  ---> tech_support_2016-01-05_13.42.14.tar.gz
4  ---> tech_support_2016-01-05_14.30.04.tar.gz
5  ---> tech_support_2016-01-07_10.22.56.tar.gz
6  ---> tech_support_2016-01-05_14.34.51.tar.gz
7  ---> tech_support_2016-01-05_14.34.15.tar.gz
8  ---> tech_support_2016-01-05_13.11.08.tar.gz
9  ---> tech_support_2016-01-05_14.05.59.tar.gz

```

#### Download a techsupport snapshot

```
~$ ioxclient  platform techsupport download
Currently using profile :  default
Command Name: plt-ts-download
List of techsupport files in the system :
1  ---> tech_support_2016-01-08_04.00.55.tar.gz
2  ---> tech_support_2016-01-05_14.35.41.tar.gz
3  ---> tech_support_2016-01-05_13.42.14.tar.gz
4  ---> tech_support_2016-01-05_14.30.04.tar.gz
5  ---> tech_support_2016-01-07_10.22.56.tar.gz
6  ---> tech_support_2016-01-05_14.34.51.tar.gz
7  ---> tech_support_2016-01-05_14.34.15.tar.gz
8  ---> tech_support_2016-01-05_13.11.08.tar.gz
9  ---> tech_support_2016-01-05_14.05.59.tar.gz
Choose the file (1:9) : 1
Read bytes :  3205206
Techsupport snapshot successfully downloaded at  tech_support_2016-01-08_04.00.55.tar.gz

```

#### Deleting a techsupport snapshot

```
~$ ioxclient  platform techsupport delete
Currently using profile :  default
Command Name: plt-ts-delete
List of techsupport files in the system :
1  ---> tech_support_2016-01-08_04.00.55.tar.gz
2  ---> tech_support_2016-01-05_14.35.41.tar.gz
3  ---> tech_support_2016-01-05_13.42.14.tar.gz
4  ---> tech_support_2016-01-05_14.30.04.tar.gz
5  ---> tech_support_2016-01-07_10.22.56.tar.gz
6  ---> tech_support_2016-01-05_14.34.51.tar.gz
7  ---> tech_support_2016-01-05_14.34.15.tar.gz
8  ---> tech_support_2016-01-05_13.11.08.tar.gz
9  ---> tech_support_2016-01-05_14.05.59.tar.gz
Choose the file (1:9) : 1
Tech support file tech_support_2016-01-08_04.00.55.tar.gz successfully deleted

```

### Managing core files

Core dumps may get generated on the platform following a nasty issue. You can view, download and manage core files.

Core file commands:

```
~$ ioxclient  platform core
NAME:
   ioxclient platform core - Manage core files on the platform

USAGE:
   ioxclient platform core command [command options] [arguments...]

COMMANDS:
   list, li		List all existing core files
   delete, d		Delete a corefile snapshot file
   download, dnld	Download a corefile snapshot file
   help, h		Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion

```

#### Listing core files on the platform

```
~$ ioxclient  platform core list
Currently using profile :  default
Command Name: plt-core-list
No core files found!

```

#### Downloading core files

```
~$ ioxclient  platform core download

```

#### Deleting core files

```
~$ ioxclient platform core delete
```

### Manage devices available on the platform

IOx devices may support peripheral devices like serial or usb ports and make it available for applications. `ioxclient` provides a few CLIs to view and manage these devices.

#### List all devices available on the platform

```
$ ioxclient platform device list
Currently active profile :  local
Command Name: plt-device-list
-------------Device Info----------------
{
 "ds_dev_ids": {},
 "serial": [
  {
   "available": true,
   "device_id": "/dev/ttyS2",
   "device_name": "async1",
   "port": null,
   "slot": null,
   "type": "serial",
   "used_by": null
  },
  {
   "available": true,
   "device_id": "/dev/ttyS1",
   "device_name": "async0",
   "port": null,
   "slot": null,
   "type": "serial",
   "used_by": null
  }
 ],
 "usbdev": [],
 "usbport": []
}                                                                                                               
```

#### List devices of a specific type

```
$ ioxclient platform device list serial
Currently active profile :  local
Command Name: plt-device-list
-------------Device Info (serial)----------------
{
 "serial": [
  {
   "available": true,
   "device_id": "/dev/ttyS2",
   "device_name": "async1",
   "port": null,
   "slot": null,
   "type": "serial",
   "used_by": null
  },
  {
   "available": true,
   "device_id": "/dev/ttyS1",
   "device_name": "async0",
   "port": null,
   "slot": null,
   "type": "serial",
   "used_by": null
  }
 ]
}
```

#### View platform device configuration

```
$ ioxclient  platform device get_config
Currently active profile :  local
Command Name: plt-device-get_config
-------------Device Configuration----------------
{
 "console": {
  "enabled": true,
  "group_name": "libvirtd",
  "setup_script": "setupconsole.sh",
  "teardown_script": "teardownconsole.sh",
  "user_name": "appconsole"
 },
 "scp": {
  "enabled": true,
  "setup_script": "setupscpuser.sh",
  "teardown_script": "teardownscpuser.sh",
  "user_name": "scpuser"
 },
 "serial": [
  {
   "device_id": "/dev/ttyS1",
   "device_name": "async0",
   "setup_script": null,
   "teardown_script": null
  },
  {
   "device_id": "/dev/ttyS2",
   "device_name": "async1",
   "setup_script": null,
   "teardown_script": null
  }
 ],
 "supported_device_types": [
  "serial"
 ]
}
```
### Managing logical networks on the platform

The hosting infrastructure on the device creates multiple logical networks based on the platform configuration.

> Refer network related documentation for your platform for more details.

`ioxclient` provides commands to manage these logical networks.

```
$ ./ioxclient  platform network
NAME:
   ioxclient platform network - Manage logical networks on the platform

USAGE:
   ioxclient platform network command [command options] [arguments...]

COMMANDS:
   list, li			List all available networks
   info, inf			View information pertaining a network
   getconfig, gconf		Get Network Configuration
   setconfig, sconf		Set Network Configuration. Pass a json file containing new config
   getmacregistry, macreg	View Current MAC/Hardware address allocation information
   getportregistry, portreg	View Current Port allocation information
   getdefaultnetwork, gdn	View the current default network in the system
   setdefaultnetwork, sdn	Set default network in the system. Pass a file with appropriate JSON payload
   bridge, br			Manage network bridges on the platform
   help, h			Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion

```

#### Listing networks available on the device

```
$ ./ioxclient  platform network list
Currently active profile :  local
Command Name: plt-network-list
List of networks:
 1. name=>iox-bridge0     :: type=>bridge, source_bridge=>svcbr_0
 2. name=>iox-nat0        :: type=>nat, source_bridge=>svcbr_0

```

#### Get information pertaining to a network

```
$ ./ioxclient  platform network info iox-nat0
Currently active profile :  local
Command Name: plt-network-info
Details of the network: iox-nat0
-----------------------------
{
 "app_ip_map": {},
 "description": "Maja Maja Network - nat",
 "external_interface": "VPG0",
 "gateway_ip": "192.168.40.33",
 "ip_end": "192.168.40.62",
 "ip_start": "192.168.40.34",
 "name": "iox-nat0",
 "nat_range_cidr": "192.168.40.32/27",
 "network_type": "nat",
 "private_route_table": "10",
 "repofolder": "/sw/opt/cisco/caf/work/network",
 "source_linux_bridge": "svcbr_0",
 "subnet_mask": "255.255.255.224"
}

```

#### List hosting bridges on the system

Logical networks are created based on the bridges configured for application hosting. To list:

```
$ ./ioxclient  platform network bridge list
Currently active profile :  local
Command Name: plt-network-bridge-list
List of hosting bridges:
[
 {
  "bridge_ip": {
   "mode": "dhcp"
  },
  "default_mode": "bridge",
  "description": "Maja Maja Network",
  "dynamically_created": false,
  "external_interface": "VPG0",
  "interface": "svcbr_0",
  "interface_info": {
   "interface_name": "svcbr_0",
   "ipv4_address": "192.168.196.128",
   "ipv6_address": "fe80::20c:29ff:fe2d:27ab/64",
   "mac_address": "00:0c:29:2d:27:ab",
   "status": "UP",
   "subnet_mask": "255.255.255.0"
  },
  "lease_info": {
   "dns": "192.168.196.2",
   "domain_name": "\"cisco.com\"",
   "fixed_address": "192.168.196.128",
   "routers": "192.168.196.2",
   "subnet_mask": "255.255.255.0"
  },
  "logical_network_info": {
   "iox-bridge0": {
    "type": "bridge"
   },
   "iox-nat0": {
    "gateway_ip": "192.168.40.33",
    "ip_end": "192.168.40.62",
    "ip_range": "192.168.40.34-192.168.40.62",
    "ip_start": "192.168.40.34",
    "nat_range_cidr": "192.168.40.32/27",
    "subnet_mask": "255.255.255.224",
    "type": "nat"
   }
  },
  "supported_modes": [
   "nat",
   "bridge"
  ],
  "vlan_id": null
 }
]

```

#### Get information from a bridge

```
$ ./ioxclient  platform network bridge info svcbr_0
Currently active profile :  local
Command Name: plt-network-bridge-info
Bridge Details:
-----------------------------
{
 "bridge_ip": {
  "mode": "dhcp"
 },
 "default_mode": "bridge",
 "description": "Maja Maja Network",
 "dynamically_created": false,
 "external_interface": "VPG0",
 "interface": "svcbr_0",
 "interface_info": {
  "interface_name": "svcbr_0",
  "ipv4_address": "192.168.196.128",
  "ipv6_address": "fe80::20c:29ff:fe2d:27ab/64",
  "mac_address": "00:0c:29:2d:27:ab",
  "status": "UP",
  "subnet_mask": "255.255.255.0"
 },
 "lease_info": {
  "dns": "192.168.196.2",
  "domain_name": "\"cisco.com\"",
  "fixed_address": "192.168.196.128",
  "routers": "192.168.196.2",
  "subnet_mask": "255.255.255.0"
 },
 "logical_network_info": {
  "iox-bridge0": {
   "type": "bridge"
  },
  "iox-nat0": {
   "gateway_ip": "192.168.40.33",
   "ip_end": "192.168.40.62",
   "ip_range": "192.168.40.34-192.168.40.62",
   "ip_start": "192.168.40.34",
   "nat_range_cidr": "192.168.40.32/27",
   "subnet_mask": "255.255.255.224",
   "type": "nat"
  }
 },
 "supported_modes": [
  "nat",
  "bridge"
 ],
 "vlan_id": null
}

```

#### Creating new networks

If your platform supports, new networks can be created and configured. To do so, you will need to create a bridge on an appropriate physical interface by passing the right JSON payload.

Here is the command help:

```
$ ./ioxclient  platform network bridge create
NAME:
   create - Create logical networks

USAGE:
   command create <json_file_with_input>

DESCRIPTION:

To create a network, pass a JSON file containing appropriate payload.
Below is a sample payload.
{
	"description": "Dynamic Network",
	"vlan_id": "10",
	"external_interface": "intsvc0",
	"supported_modes": ["nat", "bridge"],
	"bridge_ip": {
		"mode": "static",
		"ip": "192.168.0.15",
		"subnet_mask": "255.255.255.0",
		"bridge_gw_ip": "192.168.0.1",
		"dns": "8.8.4.4",
		"domain": "abc.com"
	},
	"nat": {
		"nat_range_cidr": "192.168.10.32/27"
	}
}
*vlan_id is optional
*mode can be static or dhcp. In case of dhcp, ip, bridge_gw_ip, dns, domain etc., are not needed.

```

Here is a sample CLI interaction to create a new bridge. This will result in automatic creation of bridge svcbr_1 and bridge and nat logical networks on top of it.

Sample payload:

```
$ cat test_resources/br_create.json
{
	"description": "Dynamic Network",
	"vlan_id": "10",
	"external_interface": "eth0",
	"supported_modes": ["nat", "bridge"],
	"bridge_ip": {
		"mode": "static",
		"ip": "192.168.0.15",
		"subnet_mask": "255.255.255.0",
		"bridge_gw_ip": "192.168.0.1",
		"dns": "8.8.4.4",
		"domain": "abc.com"
	},
	"nat": {
		"nat_range_cidr": "192.168.10.32/27"
	}
}

```

```
$ ./ioxclient  platform network bridge create test_resources/br_create.json
Currently active profile :  local
Command Name: plt-network-bridge-create
Payload file : test_resources/br_create.json. Will pass it as application/json in request body..
Network creation successful. Bridge is available at :  https://127.0.0.1:8443/iox/api/v2/hosting/platform/networks/hosting_bridges/svcbr_1

$ ./ioxclient  platform network list
Currently active profile :  local
Command Name: plt-network-list
List of networks:
 1. name=>iox-bridge1     :: type=>bridge, source_bridge=>svcbr_1
 2. name=>iox-bridge0     :: type=>bridge, source_bridge=>svcbr_0
 3. name=>iox-nat0        :: type=>nat, source_bridge=>svcbr_0
 4. name=>iox-nat1        :: type=>nat, source_bridge=>svcbr_1

```

#### Edit networks
It is possible to edit network configuration. Refer to the help below:

```
$ ./ioxclient  platform network bridge edit
Insufficient Args.

NAME:
   edit - Edit information pertaining a bridge

USAGE:
   command edit <bridge_id> <json_file_with_input>

DESCRIPTION:

Currently it is allowed only to change description and nat range of a network.
Below is a sample JSON payload.
{
	"description": "Dynamic Network",
	"nat": {
		"nat_range_cidr": "192.168.10.32/27"
	}
}

```

#### Deleting networks
Dynamically created/configured networks can be deleted. Below, we delete svcbr_1, which causes the iox-bridge1 and iox-nat1 to be deleted.

```
$ ./ioxclient  platform network bridge delete svcbr_1
Currently active profile :  local
Command Name: plt-network-bridge-delete
Networks on bridge %s deleted successfully! svcbr_1

$ ./ioxclient  platform network list
Currently active profile :  local
Command Name: plt-network-list
List of networks:
 1. name=>iox-bridge0     :: type=>bridge, source_bridge=>svcbr_0
 2. name=>iox-nat0        :: type=>nat, source_bridge=>svcbr_0

```

#### Get network configuration

To view the current network configuration of the platform:

```
~$ ioxclient  platform network getconfig
Currently using profile :  default
Command Name: plt-network-getconfig
Current Network Configuration:
-------------------------------------
{
 "default_bridge": "svcbr_0",
 "enabled": true,
 "host_mode": false,
 "hosting_bridges": {
  "svcbr_0": {
   "default_mode": "bridge",
   "dhcp_lease_file": "/var/lib/dhcp/dhclient.svcbr_0.leases",
   "external_interface": "VPG0",
   "nat": {
    "gateway_ip": "192.168.223.1",
    "ip_range": "192.168.223.10-192.168.223.254",
    "setup_private_routing": false,
    "subnet_mask": "255.255.255.0"
   },
   "supported_modes": [
    "nat",
    "bridge"
   ]
  }
 },
 "local_mac_registry": true,
 "network_name_prefix": "iox",
 "tcp_pat_port_range": "40000-41000",
 "udp_pat_port_range": "42000-43000"
}

```

#### Setting network configuration

Currently setting network configuration is not allowed. This section will be updated when it is supported.

#### Get MAC registry mapping

You can view the MAC Registry maintained by the platform that associates an app with a MAC address.

```
~$ ioxclient  platform network getmacregistry
Currently using profile :  default
Command Name: plt-network-getmacregistry
Mac Registry:
-------------------------------------
{
 "generated_addresses": [
  "52:54:99:99:00:00"
 ],
 "registry": {
  "nettest": {
   "eth0": {
    "mac_address": "52:54:99:99:00:00",
    "network_name": "iox-nat0"
   }
  }
 }
}

```

#### Get port registry mapping

You can view the port registry metadata that maintains port mapping for apps.

```
~$ ioxclient  platform network getportregistry
Currently using profile :  default
Command Name: plt-network-getportregistry
Port Registry:
-------------------------------------
{
 "PORT_REGISTRY": {
  "nettest": {
   "eth0": {
    "mappings": {
     "tcp": [
      [
       9000,
       40003
      ]
     ],
     "udp": [
      [
       10000,
       42003
      ]
     ]
    },
    "network_type": "nat"
   }
  },
 }
}

```

#### Get default network on the platform

Out of the available logical networks, one of them will be used as a default network.

To view this information:

```
~$ ioxclient  platform network getdefaultnetwork
Currently using profile :  default
Command Name: plt-network-getdefaultnetwork
Default Network:
-------------------------------------
{
 "default_network": "iox-bridge0"
}

```

#### Set default network on the platform

The default network can also be set by supplying the right payload. In the below case, we are sending a json file that has the following:

```
# File:
{
    "default_network": "iox-nat0"
}
```

Use :

```
~$ ioxclient  platform network setdefaultnetwork dn.json
Currently using profile :  default
Command Name: plt-network-setdefaultnetwork
Payload file : dn.json. Will pass it as application/json in request body..
Default Network:
-------------------------------------
{
 "default_network": "iox-nat0"
}

```

### Manage platform log files

#### Download platform logs (including CAF and system logs)

You can view the list of platform log files, choose one of them and download it current working directory.

```
~$ ioxclient  platform logs download
Currently active profile :  local
Command Name: plt-logs-download
1. boot.log
2. syslog.1
3. alternatives.log.1
4. caf.log
5. syslog.2.gz
6. syslog
Choose the log file you want to download [1-6] : 4
Retrieved log file successfully. Content stored at plog-Y2FmLmxvZy40

```

#### Get CAF logger levels

View the current log levels for different CAF loggers.

```
$ ioxclient  platform logs getlevel
Currently active profile :  local
Command Name: plt-logs-getlevel
-------------CAF Log levels----------------
{
 "cartridge": "debug",
 "command_wrapper": "debug",
 "connector_management": "debug",
 "oauth_service": "debug",
 "oauthlib": "debug",
 "other": "debug",
 "overrides": "debug",
 "pdservices": "debug",
 "rest_apis": "debug",
 "rfs_composer": "debug",
 "runtime.proxy": "debug",
 "system_information": "debug",
 "utils": "debug"
}

```

#### Set CAF logger levels

```
$ ioxclient platform logs setlevel info
Currently active profile :  local
Command Name: plt-logs-setlevel
Successfully set log level to info

```
### View platform capability information

Each platform exposes its capabilities in terms of available resources, supported language runtimes, application types etc.,

```
~$ ioxclient  platform capability
Currently using profile :  default
Command Name: plt-capability
-------------Platform Capability----------------
{
 "compute_nodes": [
  {
   "apphosting_cpu_shares": 8192,
   "id": "564D7AD1-641A-3FC3-0C41-3313E82D27AB",
   "installed_cartridges": [
    {
     "author": "Cisco Systems",
     "authorLink": "http://www.cisco.com",
     "cpuarch": "x86_64",
     "dependson": null,
     "description": "Yocto 1.7.2 iox-core-image-minimal rootfs",
     "handleas": [
      "overlay",
      "mountable"
     ],
     "id": "Yocto_1.7.2_for_IR800_1.0_x86_64",
     "name": "Yocto 1.7.2 for IR800",
     "payload": "ir800_yocto-1.7.2.ext2",
     "provides_info": [
      {
       "id": "urn:cisco:system:cartridge:baserootfs:yocto",
       "used_by": [
        {
         "id": "Azul_Java_1.8_for_IR800_1.0_x86_64",
         "type": "cartridge"
        },
        {
         "id": "Python_2.7_for_IR800_1.0_x86_64",
         "type": "cartridge"
        }
       ],
       "version": "1.7.2"
      }
     ],
     "runtime": "None",
     "runtime_version": "None",
     "type": "baserootfs",
     "version": "1.0"
    },
    {
     "author": "Cisco Systems",
     "authorLink": "http://www.cisco.com",
     "cpuarch": "x86_64",
     "dependson": [
      {
       "id": "urn:cisco:system:cartridge:baserootfs:yocto",
       "version": "1.7.2"
      }
     ],
     "description": "Python 2.7 language runtime bundle",
     "handleas": [
      "overlay",
      "mountable"
     ],
     "id": "Python_2.7_for_IR800_1.0_x86_64",
     "name": "Python 2.7 for IR800",
     "payload": "ir800_yocto-1.7.2_python-2.7.3.ext2",
     "provides_info": [
      {
       "id": "urn:cisco:system:cartridge:language-runtime:python",
       "used_by": [
        {
         "id": "nettest",
         "type": "app"
        }
       ],
       "version": "2.7.3"
      }
     ],
     "runtime": "None",
     "runtime_version": "None",
     "type": "language-runtime",
     "version": "1.0"
    },
    {
     "author": "Cisco Systems",
     "authorLink": "http://www.cisco.com",
     "cpuarch": "x86_64",
     "dependson": [
      {
       "id": "urn:cisco:system:cartridge:baserootfs:yocto",
       "version": "1.7.2"
      }
     ],
     "description": "Java 1.8 language runtime bundle 1.8.0_65-8.10.0.1",
     "handleas": [
      "overlay",
      "mountable"
     ],
     "id": "Azul_Java_1.8_for_IR800_1.0_x86_64",
     "name": "Azul Java 1.8 for IR800",
     "payload": "ir800_yocto-1.7.2_zre1.8.0_65.8.10.0.1.ext2",
     "provides_info": [
      {
       "id": "urn:cisco:system:cartridge:language-runtime:java",
       "used_by": [],
       "version": "1.8"
      }
     ],
     "runtime": "None",
     "runtime_version": "None",
     "type": "language-runtime",
     "version": "1.0"
    }
   ],
   "installed_services": [],
   "name": "hvishwanath-tiramisu",
   "resources": {
    "cpu": {
     "available": 800,
     "info": {
      "cpu_arch": "x86_64",
      "family": 0,
      "frequency": 0,
      "model": 0,
      "model_name": "",
      "number_cores": 4,
      "stepping": 0
     },
     "total": 1000,
     "vcpu_count": 1
    },
    "devices": {
     "serial": [
      {
       "available": true,
       "device_id": "/dev/ttyS2",
       "device_name": "async1",
       "port": null,
       "slot": null,
       "used_by": null
      },
      {
       "available": true,
       "device_id": "/dev/ttyS1",
       "device_name": "async0",
       "port": null,
       "slot": null,
       "used_by": null
      }
     ]
    },
    "memory": {
     "available": 192,
     "total": 256
    },
    "networks": [
     {
      "app_ip_map": {},
      "external_interface": "VPG0",
      "gateway_ip": null,
      "ip_end": null,
      "ip_start": null,
      "name": "iox-bridge0",
      "network_type": "bridge",
      "private_route_table": "10",
      "repofolder": "/sw/opt/cisco/caf/work/network",
      "source_linux_bridge": "svcbr_0",
      "subnet_mask": null
     },
     {
      "app_ip_map": {
       "nettest": {
        "eth0": {
         "ipv4": "192.168.223.10",
         "mac_address": "52:54:99:99:00:00"
        }
       }
      },
      "external_interface": "VPG0",
      "gateway_ip": "192.168.223.1",
      "ip_end": "192.168.223.254",
      "ip_start": "192.168.223.10",
      "name": "iox-nat0",
      "network_type": "nat",
      "private_route_table": "10",
      "repofolder": "/sw/opt/cisco/caf/work/network",
      "source_linux_bridge": "svcbr_0",
      "subnet_mask": "255.255.255.0"
     }
    ],
    "storage": {
     "available": 246,
     "total": 256
    }
   },
   "supported_app_schemas": [
    {
     "validator_schema": "schema_1.0.json",
     "version": "1.0"
    },
    {
     "validator_schema": "schema_2.0.json",
     "version": "2.0"
    }
   ],
   "supported_app_types": [
    "docker",
    "paas",
    "lxc",
    "vm"
   ],
   "supported_profile_types": [
    "c1.tiny",
    "c1.small",
    "c1.medium",
    "c1.large",
    "default",
    "custom"
   ]
  }
 ],
 "mgmt_api_version": "2.0",
 "min_app_manifest_version": "1.0",
 "product_id": "default"

```

### View platform events

Every operation on a platform generates events. Events can be viewed using this command.

```
~$ ioxclient  platform events
Currently using profile :  default
Command Name: plt-events
Host ID : 564D7AD1-641A-3FC3-0C41-3313E82D27AB
Event : 1
	event_type : caf_started
	severity : INFO
	timestamp: 2016-01-08 09:30:50 +0530 IST
	app_id : <nil>
	message : CAF started
	sequence_number : 1

```

This command also can take optional [fromseq] and [toseq] numbers that fetches a subset of events.

```
~$ ioxclient  platform events -h
NAME:
   events - Get platform events

USAGE:
   command events [fromseq] [toseq]. If not specified, default value is -1

```

### Get system health

System health information provides valuable data about the what is going on in the platform.

```
~$ ioxclient  platform health
Currently using profile :  default
Command Name: plt-health
-------------System Health----------------
{
 "cpu": {
  "cpu_count": 4,
  "load_average": {
   "min1": 0.45,
   "min15": 0.3,
   "min5": 0.42
  },
  "tasks": {
   "stopped": 0,
   "total": 547,
   "zombie": 0
  },
  "utilization": {
   "idle": 0.9764563446970509,
   "io_wait": 0.00015042774858185456,
   "system": 0.004910452673346573,
   "user": 0.017777448568410233
  }
 },
 "interfaces": [
  {
   "bandwidth_available": "N/A",
   "bandwidth_used_rx": 0,
   "bandwidth_used_tx": 0,
   "name": "docker0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 0,
   "packets_tx": 0,
   "tx_queue_len": 0
  },
  {
   "bandwidth_available": "N/A",
   "bandwidth_used_rx": 512,
   "bandwidth_used_tx": 512,
   "name": "lo",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 3039,
   "packets_tx": 3039,
   "tx_queue_len": 0
  },
  {
   "bandwidth_available": "N/A",
   "bandwidth_used_rx": 0,
   "bandwidth_used_tx": 0,
   "name": "virbr0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 0,
   "packets_tx": 0,
   "tx_queue_len": 0
  },
  {
   "bandwidth_available": "10000Mb/s",
   "bandwidth_used_rx": 217,
   "bandwidth_used_tx": 806,
   "name": "vnet0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 7542,
   "packets_tx": 18277,
   "tx_queue_len": 1000
  },
  {
   "bandwidth_available": "10Mb/s",
   "bandwidth_used_rx": 0,
   "bandwidth_used_tx": 0,
   "name": "dpbr_0-nic",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 0,
   "packets_tx": 0,
   "tx_queue_len": 500
  },
  {
   "bandwidth_available": "10000Mb/s",
   "bandwidth_used_rx": 517,
   "bandwidth_used_tx": 506,
   "name": "veth0_0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 7037,
   "packets_tx": 3082,
   "tx_queue_len": 1000
  },
  {
   "bandwidth_available": "N/A",
   "bandwidth_used_rx": 762,
   "bandwidth_used_tx": 261,
   "name": "svcbr_0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 33114,
   "packets_tx": 28337,
   "tx_queue_len": 0
  },
  {
   "bandwidth_available": "10Mb/s",
   "bandwidth_used_rx": 0,
   "bandwidth_used_tx": 0,
   "name": "dpbr_n_0-nic",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 0,
   "packets_tx": 0,
   "tx_queue_len": 500
  },
  {
   "bandwidth_available": "N/A",
   "bandwidth_used_rx": 302,
   "bandwidth_used_tx": 721,
   "name": "dpbr_n_0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 7535,
   "packets_tx": 8219,
   "tx_queue_len": 0
  },
  {
   "bandwidth_available": "N/A",
   "bandwidth_used_rx": 1024,
   "bandwidth_used_tx": 0,
   "name": "dpbr_0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 2955,
   "packets_tx": 0,
   "tx_queue_len": 0
  },
  {
   "bandwidth_available": "10000Mb/s",
   "bandwidth_used_rx": 506,
   "bandwidth_used_tx": 517,
   "name": "veth1_0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 3082,
   "packets_tx": 7037,
   "tx_queue_len": 1000
  },
  {
   "bandwidth_available": "1000Mb/s",
   "bandwidth_used_rx": 706,
   "bandwidth_used_tx": 317,
   "name": "eth0",
   "packets_dropped_rx": 0,
   "packets_dropped_tx": 0,
   "packets_rx": 30039,
   "packets_tx": 35810,
   "tx_queue_len": 1000
  }
 ],
 "memory": {
  "free": 1.787211776e+09,
  "swap_used": 507904,
  "total": 4.130541568e+09,
  "used": 2.343329792e+09
 },
 "storage": [
  {
   "free": 1.2095512576e+10,
   "name": "/dev/sda1",
   "reads_sec": 1.010304e+09,
   "size": 1.89862912e+10,
   "writes_sec": 2.5219072e+08
  },
  {
   "free": 1.1388100608e+10,
   "name": "/dev/sdb1",
   "reads_sec": 5.52911872e+08,
   "size": 3.1571570688e+10,
   "writes_sec": 3.9825408e+08
  },
  {
   "free": 3.075072e+06,
   "name": "/dev/loop0",
   "reads_sec": 0,
   "size": 1.2762112e+07,
   "writes_sec": 0
  },
  {
   "free": 0,
   "name": "/dev/loop1",
   "reads_sec": 0,
   "size": 5.7787392e+07,
   "writes_sec": 0
  },
  {
   "free": 0,
   "name": "/dev/loop2",
   "reads_sec": 0,
   "size": 1.9841024e+07,
   "writes_sec": 0
  },
  {
   "free": 1.872896e+06,
   "name": "/dev/loop3",
   "reads_sec": 0,
   "size": 2.018304e+06,
   "writes_sec": 0
  },
  {
   "free": 1.0617856e+07,
   "name": "/dev/loop4",
   "reads_sec": 0,
   "size": 1.2131328e+07,
   "writes_sec": 0
  }
 ],
 "system": {
  "localtime": 1.452264874e+09,
  "tzone": "IST(UTC+5:30:00)",
  "uptime": 17568
 }
}
```

### View platform information

Platform information provides details about cpu, network, storage etc., on the platform.

```
~$ ioxclient  platform info
Currently using profile :  d829
Command Name: plt-info
-------------System Info----------------
{
 "arp_cache": [
  {
   "address": "10.78.106.27",
   "hwaddress": "00:0c:29:53:8d:6b",
   "iface": "svcbr_0"
  },
  {
   "address": "9.42.7.33",
   "hwaddress": "88:5a:92:f0:51:b9",
   "iface": "svcbr_0"
  },
  {
   "address": "192.168.1.1",
   "hwaddress": "5c:a4:8a:54:02:c7",
   "iface": "svcbr_0"
  },
  {
   "address": "10.78.106.98",
   "hwaddress": "00:0c:29:dd:9d:f2",
   "iface": "svcbr_0"
  },
  {
   "address": "10.78.106.1",
   "hwaddress": "00:00:0c:07:ac:0a",
   "iface": "svcbr_0"
  },
  {
   "address": "10.78.106.18",
   "hwaddress": "00:0c:29:f1:8f:10",
   "iface": "svcbr_0"
  },
  {
   "address": "10.78.106.3",
   "hwaddress": "00:1b:2b:f6:86:80",
   "iface": "svcbr_0"
  },
  {
   "address": "10.78.106.107",
   "hwaddress": "00:0c:29:4d:4d:6c",
   "iface": "svcbr_0"
  },
  {
   "address": "9.42.5.36",
   "hwaddress": "3c:08:f6:5c:5e:c8",
   "iface": "svcbr_0"
  },
  {
   "address": "10.78.106.2",
   "hwaddress": "00:1b:2b:f6:92:80",
   "iface": "svcbr_0"
  },
  {
   "address": "10.78.106.90",
   "hwaddress": "4c:4e:35:e5:4a:46",
   "iface": "svcbr_0"
  }
 ],
 "cpu": {
  "cpu_arch": "x86_64",
  "family": 0,
  "frequency": 0,
  "model": 0,
  "model_name": "",
  "number_cores": 2,
  "stepping": 0
 },
 "dns_resolver": {
  "domain": "",
  "nameservers": [
   "72.163.128.140"
  ],
  "search": "cisco"
 },
 "hostname": "iox-caf",
 "interfaces": [
  {
   "ipv4_address": "172.17.42.1",
   "ipv4_netmask": "255.255.0.0",
   "mtu": 1500,
   "name": "docker0",
   "type": "Ethernet"
  },
  {
   "ipv4_address": "",
   "ipv4_netmask": "",
   "mtu": 1500,
   "name": "dpbr_0",
   "type": "Ethernet"
  },
  {
   "ipv4_address": "10.10.10.1",
   "ipv4_netmask": "255.255.255.0",
   "mtu": 1500,
   "name": "dpbr_n_0",
   "type": "Ethernet"
  },
  {
   "ipv4_address": "",
   "ipv4_netmask": "",
   "mtu": 1500,
   "name": "eth0",
   "type": "Ethernet"
  },
  {
   "ipv4_address": "127.0.0.1",
   "ipv4_netmask": "255.0.0.0",
   "mtu": 65536,
   "name": "lo",
   "type": "Local"
  },
  {
   "ipv4_address": "10.78.106.63",
   "ipv4_netmask": "255.255.255.128",
   "mtu": 1500,
   "name": "svcbr_0",
   "type": "Ethernet"
  },
  {
   "ipv4_address": "192.168.122.1",
   "ipv4_netmask": "255.255.255.0",
   "mtu": 1500,
   "name": "virbr0",
   "type": "Ethernet"
  }
 ],
 "ipv4_routing": [
  {
   "destination": "0.0.0.0",
   "flags": "UG",
   "gateway": "10.78.106.1",
   "genmask": "0.0.0.0",
   "iface": "svcbr_0",
   "metric": 0
  },
  {
   "destination": "10.10.10.0",
   "flags": "U",
   "gateway": "0.0.0.0",
   "genmask": "255.255.255.0",
   "iface": "dpbr_n_0",
   "metric": 0
  },
  {
   "destination": "10.78.106.0",
   "flags": "U",
   "gateway": "0.0.0.0",
   "genmask": "255.255.255.128",
   "iface": "svcbr_0",
   "metric": 0
  },
  {
   "destination": "172.17.0.0",
   "flags": "U",
   "gateway": "0.0.0.0",
   "genmask": "255.255.0.0",
   "iface": "docker0",
   "metric": 0
  },
  {
   "destination": "192.168.122.0",
   "flags": "U",
   "gateway": "0.0.0.0",
   "genmask": "255.255.255.0",
   "iface": "virbr0",
   "metric": 0
  }
 ],
 "memory": {
  "size": 2.098847744e+09,
  "swap": 1.071640576e+09
 },
 "ntp_server": "",
 "storage": [
  {
   "filesystem": "ext4",
   "mount": "/",
   "name": "/dev/sda1",
   "size": 1.5718137856e+10
  },
  {
   "filesystem": "ext2",
   "mount": "/sw/opt/cisco/caf/cartridges/rootfs-dhcp_1.0_x86_64/mntpoint",
   "name": "/dev/loop0",
   "size": 2.537984e+07
  },
  {
   "filesystem": "ext2",
   "mount": "/sw/opt/cisco/caf/cartridges/python2.7_0.4_x86_64/mntpoint",
   "name": "/dev/loop1",
   "size": 6.90432e+07
  },
  {
   "filesystem": "ext2",
   "mount": "/sw/opt/cisco/caf/cartridges/mnt/Yocto_1.7.2_for_IR800_1.0_x86_64",
   "name": "/dev/loop2",
   "size": 1.275392e+07
  },
  {
   "filesystem": "ext2",
   "mount": "/sw/opt/cisco/caf/cartridges/mnt/Python_2.7_1.0_x86_64",
   "name": "/dev/loop3",
   "size": 1.9838976e+07
  }
 ],
 "system_id": "564DB932-AA60-7A0F-EC55-EA3B0E23C966",
 "version": ""
}

```

### SCP files to the platform

On supported platforms, it is possible to copy local files over SCP. Please note that for this feature to work, you should be using `ioxclient` in an environment where `scp` executable is available in `$PATH`. If present, the operation is automatically started. If ioxclient encounters an error, it prints out a command that has to be manually executed.

```
$ ./ioxclient platform scp test_resources/cartridge.tar.gz
Currently active profile :  local
Command Name: plt-scp
Downloaded scp keys to pscp.pem
Running command : [scp -P 22 -i pscp.pem test_resources/cartridge.tar.gz scpuser@127.0.0.1:/]

cartridge.tar.gz                                   100% 1167     1.1KB/s   00:00    

```

> Note that the certificate from the platform will be downloaded to pscp.pem


## Managing cartridges on the platform

A cartridge is a deployable, pluggable piece of software that provides functionality and content to be consumed by the requesting application or service on an IOx node.

> Refer cartridge documentation for more details

Cartridge management commands:

```
~$ ioxclient  cartridge
NAME:
   ioxclient cartridge - Create/Delete/List cartridges

USAGE:
   ioxclient cartridge command [command options] [arguments...]

COMMANDS:
   list, li		List all existing cartridges
   install, in		Install a cartridge from its archive
   uninstall, unin	Uninstall a cartridge
   upgrade, upgr	Upgrade a cartridge
   info, inf		View information of a cartridge
   help, h		Shows a list of commands or help for one command

OPTIONS:
   --help, -h			show help
   --generate-bash-completion


```

### List cartridges installed on the system

```
~$ ioxclient  cartridge list
Currently using profile :  d829
Command Name: cartridge-list
List of installed cartridges :
 1. Python_2.7_1.0_x86_64 : Python 2.7, Python 2.7 language runtime bundle
 2. Yocto_1.7.2_for_IR800_1.0_x86_64 : Yocto 1.7.2 for IR800, Yocto 1.7.2 iox-core-image-minimal rootfs

```

### Installing a cartridge

```
~$ ioxclient  cartridge install ~/Downloads/cartridges/ir800_yocto-1.7.2_zre1.8.0_65.8.10.0.1.tar
Currently using profile :  d829
Command Name: cartridge-install
Installation Successful. Cartridge is available at :  https://10.78.106.63:8443/iox/api/v2/hosting/cartridges/Azul_Java_1.8_for_IR800_1.0_x86_64

```

### Get cartridge information

```
~$ ioxclient  cartridge info Azul_Java_1.8_for_IR800_1.0_x86_64
Currently using profile :  d829
Command Name: cartridge-info
Details of Cartridge : Azul_Java_1.8_for_IR800_1.0_x86_64
-----------------------------
{
 "author": "Cisco Systems",
 "authorLink": "http://www.cisco.com",
 "cpuarch": "x86_64",
 "dependson": [
  {
   "id": "urn:cisco:system:cartridge:baserootfs:yocto",
   "version": "1.7.2"
  }
 ],
 "description": "Java 1.8 language runtime bundle 1.8.0_65-8.10.0.1",
 "handleas": [
  "overlay",
  "mountable"
 ],
 "id": "Azul_Java_1.8_for_IR800_1.0_x86_64",
 "name": "Azul Java 1.8 for IR800",
 "payload": "ir800_yocto-1.7.2_zre1.8.0_65.8.10.0.1.ext2",
 "provides_info": [
  {
   "id": "urn:cisco:system:cartridge:language-runtime:java",
   "used_by": [],
   "version": "1.8"
  }
 ],
 "runtime": "None",
 "runtime_version": "None",
 "type": "language-runtime",
 "version": "1.0"
}

```

### Uninstalling a cartridge

```
~$ ioxclient  cartridge uninstall Azul_Java_1.8_for_IR800_1.0_x86_64
Currently using profile :  d829
Command Name: cartridge-uninstall
Successfully uninstalled cartridge Azul_Java_1.8_for_IR800_1.0_x86_64

```

### Upgrading a cartridge

```
~$ ioxclient  cartridge upgrade
NAME:
   upgrade - Upgrade a cartridge

USAGE:
   command upgrade <cartridge_id> <cartridge_archive>

```

## Troubleshooting

You can turn on ioxclient debugs to get more information about the requests being sent to the platform.

To turn on/off debug, pass on or off to debug command.

```
~$ ioxclient  debug on
Setting ioxclient debug to  true
```

Turning on debugging prints additional information for commands:

```
~$ ioxclient  cartridge info Python_2.7_1.0_x86_64
Currently using profile :  d829
Command Name: cartridge-info
2016/01/08 15:21:15 GET /iox/api/v2/hosting/cartridges/Python_2.7_1.0_x86_64 HTTP/1.1
Host: 10.78.106.63:8443
X-Token-Id: 8877176d-f843-441a-ad87-09994ac42763

<snip>

```

## Fog Portal Management


Fog portal commands are

```
NAME:
   ioxclient fogportal - FogPortal operations

USAGE:
   ioxclient fogportal command [command options] [arguments...]

COMMANDS:
   init, in             Initialize fog profile
   service, svc         Service management operations using Fogportal
   help, h              Shows a list of commands or help for one command
```

### Initializing Fog Portal

The details of the fog portal, i.e the URL at which the fog portal can be reached has to be set in order execute operations on the fog portal using the fogportal init command

```
~$ioxclient fogportal init
Enter the Fog portal IP[127.0.0.1] :
10.78.106.35
Enter the fogportal Port[443]:
8090
Enter the API prefic[/api/v1/fogportal]:
/api/v1/fogportal/
Saving current configuration

```

### Fog portal service list

In order to list all the services available in the fog portal, use the fogportal service list command as follows

```
~$ioxclient fogportal svc li
Currently active profile :  vm211
Command Name: fogportal-service-list
The following services are present in the fog portal
Middleware Message Broker
         urn:cisco:system:service:message-broker  -  0.9.4
IOx Middleware Services
         urn:cisco:system:service:nbi  -  0.9.4
         urn:cisco:system:service:provisioning  -  0.9.4
         urn:cisco:system:service:mqttstoreandforward  -  0.9.4
         urn:cisco:system:service:coapstoreandforward  -  0.9.4
         urn:cisco:system:service:stream-analytics  -  0.9.4
         urn:cisco:system:service:plugin:coap-client  -  0.9.4
         urn:cisco:system:service:coap-proxy  -  0.9.4
         urn:cisco:system:service:plugin:mqtt-broker  -  0.9.4
         urn:cisco:system:service:plugin:coap-server  -  0.9.4
```

### Fog portal service info

This command provides all the information regarding a particular service that is available in the fog portal

```
~$ioxclient fogp svc info "Middleware Message Broker"
Currently active profile :  vm211
Command Name: fogportal-service-info
{
        "_links": {
                "package": "/api/v1/fogportal/service_bundles/downloads/0725bf1de53025ce1065cfe58519681e873b33074a1f0c319f0db3705a6c8fe9"
        },
        "id": "0725bf1de53025ce1065cfe58519681e873b33074a1f0c319f0db3705a6c8fe9",
        "Metadata": {
                "app": {
                        "cpuarch": "x86_64",
                        "type": "lxc",
                        "depends-on": {
                                "services": null
                        },
                        "resources": {
                                "cpu": "200"
                        }
                },
                "service-bundle": {
                        "provides": [
                                {
                                        "id": "urn:cisco:system:service:message-broker",
                                        "api-version": 1,
                                        "version": "0.9.4",
                                        "port-mapping": [
                                                "eth0:tcp:8080"
                                        ]
                                }
                        ]
                }
        },
        "name": "Middleware Message Broker"
}

```


### Fog portal service install

The fog portal service install command is used to install a service that is available in the fog portal. The service install can be proceeded in two types


#### With dependency resolution

If the user wants the ioxclient to take care of installing the required dependencies for the service, the user can specify the --rd flag which looks for the required dependencies in the fog portal and installs them before installing the specified service. The user can also specify a payload for the activation of the dependent services using the service-activation-payload flag.

```
~$ioxclient fogp svc in middleware-core --rd --p test_resources\nat-activation.json

```
**Sample Output**

```
Currently active profile :  vm211
Command Name: fogportal-service-install
Requesting  http://10.78.106.35:8090/api/v1/fogportal/service_bundles/
Requesting -   http://10.78.106.35:8090/api/v1/fogportal/service_bundles/
The following services are available in the Fog portal
1 .  Middleware Message Broker
2 .  middleware-core
Checking CAF for the already existing services
Existing services in CAF are -
0 .  Middleware Message Broker
|_middleware-core
|_|_Middleware Message Broker
Checking CPU architecture compatibility of the service  Middleware Message Broker
Middleware Message Broker  is present in the FogPortal
Downloading  Middleware Message Broker ....
200 OK

C:\Users\xyz\AppData\Local\Temp\0725bf1de53025ce1065cfe58519681e873b33074a1f0c319f0db3705a6c8fe9 with 27648719 bytes downloaded
Service bundle to be stored in  C:\Users\cheb\AppData\Local\Temp\0725bf1de53025ce1065cfe58519681e873b33074a1f0c319f0db3705a6c8fe9
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/MiddlewareMessageBroker
Successfully deployed
Payload file : test_resources\nat-activation.json. Will pass it as application/json in request body..
Service MiddlewareMessageBroker is Activated
Service MiddlewareMessageBroker is Started

Resolved status of  Middleware Message Broker  -  true
200 OK

C:\Users\xyz\AppData\Local\Temp\a01a7a94565479f90d1525b25ca53f75292bff5b18844076ab76adc4169944a6 with 13265026 bytes downloaded
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/middlewareCore
Successfully deployed

```

#### Without dependency resolution

This follows a straight forward installation of the specified service from the fog portal without checking for any of the dependencies.


```
~$ ioxclient fogp svc in middleware-core --p test_resources\nat-activation.json

```
**Sample Output**

```
Currently active profile :  vm211
Command Name: fogportal-service-install
Requesting  http://10.78.106.35:8090/api/v1/fogportal/service_bundles/
The following services are available in the Fog portal
1 .  Middleware Message Broker
2 .  middleware-core

200 OK

C:\Users\xyz\AppData\Local\Temp\a01a7a94565479f90d1525b25ca53f75292bff5b18844076ab76adc4169944a6 with 13265026 bytes downloaded
Installation Successful. Service is available at : https://10.78.106.211:8443/iox/api/v2/hosting/service-bundles/middlewareCore
Successfully deployed

```

## IOx Services Infrastructure commands

IOx infrastructure is a set of services that can be used to apply functions on the data streams. The infrastructure service provides a common data model that represents a normalized form of the data stream to be consumed by any service or application. All incoming and outgoing data streams are consumed and emitted in this normalized data model enabling services and applications to be developed independent of the source and destinations of the data streams.

IOx Service Infrastructure Commands:

```
~$ioxclient svc infra
NAME:
   ioxclient service infrastructure - Used for device provisioning, messaging,

USAGE:
   ioxclient service infrastructure command [command options] [arguments...]

COMMANDS:
   nbi                  Supports RESTful / Websocket interface for configuring the services
   metrics, met         Get middleware metrics
   provisioning, prov   Provisions the specified function
   messaging, msg       Provides messaging services
   logservice           Use log services to view the available modules and set their log levels
   help, h              Shows a list of commands or help for one command

OPTIONS:
   --help, -h                   show help
   --generate-bash-completion


```

### Initializing a profile
Usually, the NorthBound REST / Websocket Interface is automatically initialized by the ioxclient. But for situations which require manual initialization, the user can choose to use the nbi init function

Command structure

```
 ~$ ioxclient svc infra nbi
 
 NAME:
    ioxclient service infrastructure nbi - Supports RESTful / Websocket interface for configuring the services

 USAGE:
    ioxclient service infrastructure nbi command [command options] [arguments...]

 COMMANDS:
    init, in     Initialise North bound gateway details manually
    help, h      Shows a list of commands or help for one command

 OPTIONS:
    --help, -h                   show help
    --generate-bash-completion
```

 Sample initialization -

 ```
 ~$ioxclient svc infra nbi init
 Enter the North bound gateway IP address[ 10.78.106.211 ] :
 10.78.106.211
 Enter the North bound gateway Port[40001]: 443
 Enter the North bound gateway api prefix[/api/v1/mw/]:/api/v1/mw
 Enter the North bound gateway URL scheme[https]:https
 Saving current configuration
 
 ```

### Device Provisioning

All devices that IOx infrastructure service is going to monitor, manage and communicate with, needs to be configured using RESTful APIs. The device provisioning is three steps process, where data models like data-schema(s), deviceType and device endpoint are configured. A device is of a certain device type. The device type defines one or more sensors and schema of the data emitted by each sensor. The device type also defines the protocol(s) supported by that class of devices, and properties that are relevant for the corresponding protocol handlers.

```
NAME:
   ioxclient service infrastructure provisioning - Provisions the specified function

USAGE:
   ioxclient service infrastructure provisioning command [command options] [arguments...]

COMMANDS:
   dataschemas, ds      Provision dataschemas
   devicetypes, dt      Display the details of the device
   devices, dev         Display the details of the device
   help, h              Shows a list of commands or help for one command
```

#### Provision Data-schema

As data would be consumed from variety of data sources, this data needs to be represented in a common normalized form. The Data Schema defines such a contract and once protocol handler acquires the data from a device it needs to be mapped to the corresponding data schema.

We can create, delete, update or read the information of a particular data schema using below commands.

Dataschema provisioning commands are -

```
~$ioxclient service infrastructure provisioning dataschemas
NAME:
   	ioxclient service infrastructure provisioning dataschemas - Provision dataschemas

USAGE:
   ioxclient service infrastructure provisioning dataschemas command [command options] [arguments...]

COMMANDS:
   create, cr   Add a dataschema
   info, inf    List all/specified dataschemas
   delete, del  Delete a dataschema
   update, up   Update a given schema
   help, h      Shows a list of commands or help for one command

OPTIONS:
   --help, -h                   show help
   --generate-bash-completion

```

##### Create dataschema
```
~$ioxclient service infrastructure provisioning dataschemas create -f test_resources\middleware-files\dataschema.json

Currently active profile :  vm211
Command Name: provisioning-dataschemas-create
Sending https request to  https://10.78.106.211:40001/api/v1/mw/provisioning/dataschemas/
Successfully added object
```

##### Update dataschema
```
~$ioxclient service infrastructure prov ds up temperatureSchema -f test_resources\middleware-files\dataschemaUpdate.json

Currently active profile :  vm211
Command Name: provisioning-dataschemas-update
Updating at https://10.78.106.211:40001/api/v1/mw/provisioning/dataschemas/temperatureSchema
Successfully updated Policies
```

##### Dataschema Info
```
~$ioxclient service infrastructure prov ds info

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-dataschemas-info
https://10.78.106.211:40001/api/v1/mw/provisioning/dataschemas/

```

The user could also specify a particular dataschemaId to view information of only a single dataschema

##### Delete dataschema

```
~$ioxclient infrastructure svc prov ds del temperatureSchema

Currently active profile :  vm211
Command Name: service-provisioning-dataschemas-delete
Url is  https://10.78.106.211:40001/api/v1/mw/provisioning/dataschemas/sortingstation
Successfully Deleted  dataschema   temperatureSchema

```

#### Provision Device type

As same type of physical devices can be installed at many places, key common characteristics of these devices are grouped as Device Type. This is not a one-to-one mapping to a serial number or SKU of a manufacturer but tries to abstract out key elements of a device like meta-data and key specifications like sensors and actuator entities.

##### Create devicetype

```
~$ioxclient svc infrastructure prov devicetypes cr -f test_resources\middleware-files\devicetype.json

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-devicetypes-create
Sending https request to  https://10.78.106.211:40001/api/v1/mw/provisioning/devicetypes/
Successfully added the  devicetype
```
##### Device Type Info

```
~$ioxclient svc infrastructure prov dt info

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-devicetypes-info
https://10.78.106.211:40001/api/v1/mw/provisioning/devicetypes/
{
        "kind": "model#devicetype#collection",
        "deviceTypes": [
                {
                        "kind": "model#devicetype",
                        "description": "",
                        "displayName": "",
                        "createdAt": "2016-06-08T20:13:03.267+0000",
                        "updatedAt": "2016-06-08T20:13:03.267+0000",
                        "deviceTypeId": "TestModbusDeviceType",
                        "protocol": "modbus",
                        "protocolHandler": "urn:cisco:system:service:protocolHandler:modbus-tcp",
                        "sensors": [
                                {
                                        "name": "LightSensor",
                                        "dataSchemaId": "sortingstation",
                                        "description": "",
                                        "contentHandler": {
                                                "contentType": "raw",
                                                "protocolProperties": {},
                                                "contentMappings": [
                                                        {
                                                                "fieldName": "sensor1",
                                                                "expression": ".",
                                                                "protocolProperties": {
                                                                        "style": "digital",
                                                                        "mode": "write",
                                                                        "registerRange": "10001-1"
                                                                }
                                                        },
                                                        {
                                                                "fieldName": "sensor2",
                                                                "expression": ".",
                                                                "protocolProperties": {
                                                                        "style": "digital",
                                                                        "mode": "write",
                                                                        "registerRange": "10001-1"
                                                                }
                                                        }
                                                ],
                                                "properties": {}
                                        }
                                }
                        ]
                }
        ]
}
```

##### Update a device type

```
~$ioxclient svc infrastructure prov dt up TestModbusDeviceType -f test_resources\middleware-files\devicetype.json

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-devicetypes-update
Updating at  https://10.78.106.211:40001/api/v1/mw/provisioning/devicetypes/TestModbusDeviceType
Successfully updated  devicetype

```

##### Delete a device type

```
~$ioxclient svc infrastructure prov dt delete TestModbusDeviceType

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-devicetypes-delete
Updating at  https://10.78.106.211:40001/api/v1/mw/provisioning/devicetypes/TestModbusDeviceType
Successfully deleted devicetype

```

#### Provision Device

Devices are representation of connected physical entity that conforms to a device type. A device can be representing a person with a heart monitor implant, a farm animal with a bio-chip transponder, an automobile that has built-in sensors to alert the driver when tire pressure is low or any other natural or man-made object that can be assigned an IP address and provided with the ability to transfer data over a network.

##### Create a device
```
~$ioxclient svc infrastructure prov devices cr -f test_resources\middleware-files\device.json

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-devices-create
Sending https request to  https://10.78.106.211:40001/api/v1/mw/provisioning/devices/
Successfully added the  device
```

##### Device Info

```
~$ioxclient svc infrastructure prov devices info

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-devices-info
https://10.78.106.211:40001/api/v1/mw/provisioning/devices/
{
        "kind": "model#device#collection",
        "devices": [
                {
                        "kind": "model#device",
                        "description": "",
                        "displayName": "",
                        "createdAt": "2016-06-08T20:39:37.362+0000",
                        "updatedAt": "2016-06-08T20:39:37.362+0000",
                        "deviceId": "DeviceA",
                        "deviceTypeId": "TestModbusDeviceType",
                        "metadata": {
                                "skuCode": "sk3465tyu",
                                "serialNo": "567e",
                                "urn": "shipping/container/A",
                                "additionalProperties": {}
                        },
                        "connectionProperties": [
                                {
                                        "protocol": "modbus",
                                        "properties": {
                                                "host": "10.10.10.10",
                                                "port": 502,
                                                "pollingInterval": 10,
                                                "healthCheckInterval": 5000
                                        }
                                }
                        ]
                }
        ]
}
```

##### Delete a device
```
~$ioxclient svc infrastructure prov dev del DeviceA

Currently active profile :  vm211
Command Name: service-infrastructure-provisioning-devices-delete
Url is  https://10.78.106.211:40001/api/v1/mw/provisioning/devices/DeviceA         Successfully Deleted  device   DeviceA

```

> Note: A device is dependent on a device type which is also dependent on a dataschema. And hence, in order to remove a dataschema, there should not be any device type using that particular dataschema, and no device should come under that device type.

#### IOx Messaging Service

##### Managing topics

Commands under managing topics are:

```
~$ioxclient service infrastructure messaging topics
NAME:
ioxclient service infrastructure messaging topics - create/delete/publish topics

USAGE:
ioxclient service infrastructure messaging topics command [command options] [arguments...]

COMMANDS:
create, cr   Create a topic
delete, del  Delete a topic
publish, pub Publish into a topic
help, h      Shows a list of commands or help for one command

```

###### Creating a topic

Any topic of the user's choice can be created by specifying a name for a topic to be created

```
~$ioxclient svc infrastructure messaging topics cr sampleTopic

Currently active profile :  vm211
Command Name: service-infrastructure-topics-create
Url formed is -  https://10.78.106.211:40001/api/v1/mw/topics/sampleTopic
Successfully added Topic
```

###### Publishing to a topic

Data can be published to a topic either by passing the json data in the required format as command line argument or by specifying a file using the --file flag

```
~$ioxclient svc infrastructure messaging topics publish --file test_resources\middleware-files\topics.json

Currently active profile :  vm211
Command Name: service-infrastructure-topics-publish-create
Sending https request to  https://10.78.106.211:40001/api/v1/mw/topics/publish/
{
    "topic": "sampleTopic",
    "context" : {
        "prop1": "value1",
        "prop2": "value2"
    },
    "message" : {
        "id": 5,
        "severity": "warn",
        "description": "unable to contact northbound"
    }
}


Successfully published the  topic
```

###### Deleting a topic

A topic can be deleted by specifying the name of the topic

```
~$ioxclient svc infrastructure messaging topics del sampleTopic

Currently active profile :  vm211
Command Name: service-infrastructure-topics-delete
Url is  https://10.78.106.211:40001/api/v1/mw/topics/sampleTopic
Successfully Deleted sampleTopic

```
##### Publish / Subscribe Messages using Websockets

IOx Service infrastructure allows using websockets to allow the user to publish or subscribe to/from a topics.

```
~$ioxclient service infrastructure websocket

NAME:
   ioxclient service infrastructure websocket - To stream data from the socket

USAGE:
   ioxclient service infrastructure websocket command [command options] [arguments...]

COMMANDS:
   subscribe, sub       Stream data from a websocket
   publish, pub         Publish data through a websocket
   help, h              Shows a list of commands or help for one command
```
###### Topic Subscription using websocket

```
~$ioxclient svc infra msg ws sub sampleTopic

Currently active profile :  vm211
Command Name: service-infrastructure-messaging-websocket-subscribe
{"context":{"prop1":"value1","prop2":"value2"},"topic":"sampleTopic","message":{"id":5,"severity":"warn","description":"This is a sample publish"}}
{"context":{"prop1":"value1","prop2":"value2"},"topic":"sampleTopic","message":{"id":5,"severity":"warn","description":"This is a sample 2nd publish"}}
{"context":{"prop1":"value1","prop2":"value2"},"topic":"sampleTopic","message":{"id":5,"severity":"warn","description":"This is a sample 3rd publish"}}
```

###### Publish Messages Using websocket

```
~$ioxclient svc infra msg ws pub test_resources\middleware-files\topics.json

Currently active profile :  vm211
Command Name: service-infrastructure-messaging-websocket-publish
No of characters written  247
```

#### IOx Service Infrastructure - Metrics

In order to aid in troubleshooting issues, IOX Service Infrastructure maintains various metrics. These metrics are mostly in the form of counters, meters, guages, histograms, etc

##### View metrics

```
~$ioxclient service infrastructure metrics
Currently active profile :  vm211
Command Name: service-infrastructure-metrics
https://10.78.106.211:40001/api/v1/mw/metrics
0 .  system:service:protocolHandler:mqtt-broker
1 .  system:service:mqttstoreandforward
2 .  logconfig
3 .  system:service:coapstoreandforward
4 .  token
5 .  system:service:coap-proxy
6 .  system:service:protocolHandler:modbus-async-tcp
7 .  system:service:protocolHandler:coap-server
8 .  mlib-rpc.IOxMiddlewareServices
9 .  mlib-threadpool.IOxMiddlewareServices
10 .  system:service:provisioning
11 .  system:service:data:snapshot
14 .  mlib-pubsub.IOxMiddlewareServices
Enter the serial Number of the required metric
1
{
       "stats": [
               {
                       "name": "numberOfNBIRequestsFailed",
                       "type": "counter",
                       "count": 0
               },
               {
                       "name": "numberOfNBIRequestsSucceeded",
                       "type": "counter",
                       "count": 0
               },
               {
                       "name": "numberOfPolicies",
                       "type": "counter",
                       "count": 0
               }
       ],
       "policies": {
               "type": "composite",
               "kind": "sf#policy#collection"
       }
}

```

### Log services

The log services allow us to list the modules and their log levels of a particular service. A user could also set the log level of a particular module with this command
The command structure of log services is 

```
~$ioxclient service infrastructure logservice --help
NAME:
   logservice - Use log services to view the available modules and set their log levels

USAGE:
   command logservice [command options]

DESCRIPTION:
   To list the modules of a service -
ioxclient service infra --service service_name
In order to set the log level of a module in a given service,
ioxclient service infra --service svc_name --module mod_name -- level log_level

OPTIONS:
   --service, --svc     Specify the service of the module
   --module, --mod      Specify the module who's log level has to be set
   --level, --lvl       Specify the log level that is to be set

```

#### List modules

To list th modules and their log levels of a given service, specify the service name using the --service flag as follows 

```
~$ioxclient service infra logservice --svc mw
Currently active profile :  vm211
Command Name: service-infrastructure-logservice
Sending HTTP request to  -  https://10.78.106.211:40001/api/v1/mw/logs/mw/modules
-------------HTTP Response----------------
{
 "system:service:protocolHandler:modbus-async-tcp": "warning",
 "urn:cisco:system:service:data:snapshot": "trace",
 "urn:cisco:system:service:provisioning": "error"
}
```

#### Set log level module 

To set the log level of a module, specify the service name using the --service flag, the module with the --module flag and the log level using the --level flag
The log levels could be INFO, WARN,ERROR,DEBUG,TRACE

```
~$ioxclient service infra logservice --service mw --module system:service:protocolHandler:modbus-async-tcp --level trace
Currently active profile :  vm211
Command Name: service-infrastructure-logservice
Sending HTTP request to  -  https://10.78.106.211:40001/api/v1/mw/logs/mw/modules/system:service:protocolHandler:modbus-async-tcp?level=trace
Successfully changed the log level of  system:service:protocolHandler:modbus-async-tcp  to  trace
```

In order to verify the succesful setting of the log level, list the modules using 
```
~$ioxclient service infra logservice --service mw
```

The log level of the module which was updated should show the same log level 
In the above example, we set the log level of "system:service:protocolHandler:modbus-async-tcp" to "trace"
Hence, the list should be displaying this - 
```
~$ioxclient service infra logservice --service mw
Currently active profile :  vm211
Command Name: service-infrastructure-logservice
Sending HTTP request to  -  https://10.78.106.211:40001/api/v1/mw/logs/mw/modules
-------------HTTP Response----------------
{
 "system:service:protocolHandler:modbus-async-tcp": "trace",
 "urn:cisco:system:service:data:snapshot": "trace",
 "urn:cisco:system:service:provisioning": "error"
}
```




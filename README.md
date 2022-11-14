## LAMP Stack for Faveo Helpdesk Development Environment on Ubuntu 20.04 and 22.04

Set up the development environment for Faveo Helpdesk with a simplified bash script installer.

## Usage
___

Note: This script must be run only on freshly installed Ubuntu 20.04 or 22.04 and it should be run as a root user or with sudo privilege.


* Now clone the Faveo Development LAMP Stack repository.

```sh
git clone https://github.com/ladybirdweb/faveo-dev-lamp-stack.git
```
* Navigate inside the cloned directory.
```sh
cd faveo-dev-lamp-stack/
```

* Once downloaded, navigate to the folder where the script has been downloaded and execute the below command to provide executable permission to the lamp.sh script

```sh
sudo chmod +x lamp.sh
```

* Now, execute the script by running the below command, and following the instructions, you will be asked to input the Nodejs version, PHP Version, Database Root user password, and the Domain name of your choice. Consult your respective Team Leaders for the version numbers of Nodejs and PHP. Refer to the below image as an example.


```sh
sudo bash lamp.sh
```

<img src="/contents/prompt.png" alt="Prompt"/>

Note: On Ubuntu 22.04, you might encounter "Daemons using outdated libraries" Prompts several times during the installation. Leave the default values and press the [TAB] key and [Spacebar].

<img src="/contents/needrestartprompt1.png" alt="Prompt"/>
<img src="/contents/needrestartprompt2.png" alt="Prompt"/>

When the installation is completed you will be displayed with your login URL, phpMyAdmin URL, Web Server root directory, and Database username and password. These details will also be saved in a file named "credentials.txt" under /var/www directory.

<img src="/contents/credentials.png" alt="credentials"/>

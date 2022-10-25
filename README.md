## LAMP Stack for Faveo Helpdesk Development Environment on Ubuntu 20.04 and 22.04

A pretty simplified bash script installer to set up the development environment for Faveo Helpdesk 

## Usage
___

Note: This script must be run only on freshly installed Ubuntu 20.04 or 22.04 and it should be run as root user or with sudo privilege.

* click on the below link and download the file "lamp.sh".

* [Installation Script](https://github.com/ladybirdweb/faveo-dev-lamp-stack/blob/main/contents/lamp.sh)
<a href="https://github.com/ladybirdweb/faveo-dev-lamp-stack/blob/main/contents/lamp.sh" download>Click to Download</a>

* Once Downloaded navigate to the folder where the script has downloaded and execute the below command to provide executable permission to the lamp.sh script

```sh
chmod +x lamp.sh
```
* Next switch to root user by executing the below command and enter the password when prompted.
```sh
sudo -s
```
* Now execute the script and follow the Instructions you will be asked to input the Nodejs version, PHP Version, Database Root user password, and the Domain name of your choice. Consult your respective Team Leaders for the version numbers of Nodejs and PHP. Refer to the below image as an example.

<img src="/contents/prompt.png" alt="Prompt"/>

Note: On Ubuntu 22.04 you might come across "Daemons using outdated libraries" Prompts several times during the installation. Leave the deault values and simply press [TAB] key and [Spacebar].

<img src="/contents/needrestartprompt1.png" alt="Prompt"/>
<img src="/contents/needrestartprompt2.png" alt="Prompt"/>

When the installation is completed you will be disaplyed with your login URL, phpMyAdmin URL, Web Server root directory, and Database username and password. This details will also be saved in a file named "credentials.txt" under /var/www directory. 
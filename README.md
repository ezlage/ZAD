# Zabbix Agent Deployer (ZAD)
  
This set of scripts was developed and tested with the aim of facilitating the deployment and updating of Zabbix Agents in large environments. Also called ZAD, Zabbix Agent Deployer is a FOSS that hopes to help everyone and get better and better with time.
  
### Dependencies (self-managed)
  
- [cURL](https://curl.haxx.se/download.html)
- [7-Zip Extra](https://www.7-zip.org/download.html)
- [PsTools' PsExec](https://docs.microsoft.com/en-us/sysinternals/downloads/pstools)
- [Uninstall](https://tarma.com/tools/uninstall)
  
PsExec is the only one that is not included in this repository, due to PsTools license restrictions. I tried to get Mark Russinovich's authorization to distribute it, but to no avail.  
  
### Usage
  
The executor credential needs to have appropriate privileges on the ZAD base directory and on all target servers, as well as all devices and credentials involved must be part of mutually trusted forests or domains of a directory service.
  
1. Run ***update-dependencies.bat*** or ***update-dependencies.ps1*** at least once to download and update dependencies (in this way the PsExec will be obtained)
2. Get the Zabbix Agent MSI packages in the desired versions, save them in the ***pkg*** folder, replacing the current ones and reusing their names
3. Edit lines 5 to 13 and/or 42 to 47 of the ***cfg\callback.bat*** to reflect your monitoring environment (Zabbix Agent 2 is also supported - just change lines 5 and 6)
4. Edit the ***cfg\servers.txt*** file to reference your monitored servers, one per line
5. In recent and well-configured environments, execute ***run-with-psremoting.ps1***; On old or poorly configured environments, execute ***run-with-psexec.bat***
6. Track progress through your monitoring or inventory system; In case of failure, send us the ***zad-install.log***, ***zad-uninstall.log*** and ***zad-control.log*** logs, present in ***C:\Windows\Temp*** of each failed server
7. Help us to get better sharing any and all questions, suggestions or criticisms, as well as logs and screenshots
  
### Roadmap and changelog
  
#### Probable future development
  
- Autofetch desired Zabbix Agent package versions
- Support for non-Windows operating systems (source and/or target)

#### v1.0.0.1: Updating packages and binaries (2022-07-15)

- Updated Zabbix Agent from 6.0.2 LTS to 6.0.6 LTS
- Updated dependencies to latest versions on 2022-07-15

#### v1.0.0.0: First public release
  
- Accompanied by 32-bit and 64-bit Zabbix Agent 6.0.2 LTS MSI packages
- Self-managed dependencies
- Support for PowerShell with PSRemoting (asynchronous)
- Support for Windows Command Prompt with PsExec (synchronous)
- Tested in Microsoft Active Directory environments
- Tested support for Windows Server versions 2003 and 2008 with 32-bit and 64-bit x86 architecture
- Tested support for Windows Server versions 2008 R2, 2012, 2012 R2, 2016, 2019 and 2022 with 64-bit x86 architecture
- Tested with Brazilian and USA language and regional settings
- Tested with the latest Zabbix Agent MSI packages of all major versions from 3.x.x LTS to 6.x.x LTS
  
### License, credits, feedback and donation
  
[BSD 3-Clause "New" or "Revised" License](./LICENSE.md)  
Developed by [Ezequiel Lage](https://twitter.com/ezlage), Sponsored by [Lageteck](https://lageteck.com)  
Any and all suggestions, criticisms and contributions are welcome!  
Get in touch via Issues, Discussions and Pull Requests  
  
Credits to Igor Pavlov for developing the 7-Zip<sup>[1](./bin/7za-license.txt)</sup>, to Tarma Software for the Uninstall<sup>[2](./bin/uninstall-license.txt)</sup> tool, to Sysinternals for the PsTools<sup>[3](./bin/psexec-license.txt)</sup> toolkit, to cURL Project for the cURL<sup>[4](./bin/curl-license.txt)</sup> utility, as well as to Zabbix LLC for Zabbix<sup>[5](./pkg/zabbixagent-license.txt)</sup> itself.  
  
#### Please, support this initiative!
BTC: 1KMBgg1h3TGPCWZyi4iFo55QvYrdo5JyRc  
DASH: Xt7BNFyCBxPdnubx5Yp1MjTn7sJLSnEd5i  
DCR: Dscy8ziqa2qz1oFNcbTXDyt3V1ZFZttdRcn  
ETH: 0x06f1382300723600b3fa9c16ae254e20264cb955  
LTC: LZJPrFv7a7moL6oUHPo8ecCC9FcbY49uRe  
USDC: 0x38be157daf7448616ba5d4d500543c6dec8214cc  
ZEC: t1eGBTghmxVbPVf4cco3MrEiQ8MZPQAzBFo  
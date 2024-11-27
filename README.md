# Zabbix Agent Deployer (ZAD)

A set of scripts developed with the aim of facilitating the deployment and updating of Zabbix Agents in large environments.  

## Requirements and Dependencies

- [cURL](https://curl.se/download.html)
- [7-Zip Extra](https://www.7-zip.org/download.html)
- [PsTools' PsExec](https://docs.microsoft.com/en-us/sysinternals/downloads/pstools)
- [Tarma Uninstall](https://tarma.com/tools/uninstall)

For licensing reasons, it was not possible to include PsExec in this repository. Therefore, at least once, before the first use, you must run **Update-ZadDeps.ps1** or **Update-ZadDeps.bat**. Running one of these scripts will download and/or update PsExec along with other dependencies.  
  
**Start-PsRemoZad.ps1** uses PSRemoting and runs asynchronously, while **Start-PsExecZad.bat** uses PsExec and runs synchronously. The executor must have the appropriate privileges on the ZAD base directory and target servers. Additionally, all devices and credentials involved must be part of trusted forests or domains within a directory service.  

## Usage Instructions

- On Windows (the only supported operating system for now)

1. Prefer to clone the repository to ensure that the binaries are healthy, as downloading in ZIP format sometimes does not include the LFS objects
2. Run **Update-ZadDeps.ps1** or **Update-ZadDeps.bat** at least once to satisfy the requirements and dependencies
3. Get the desired [32-bit and 64-bit packages of Zabbix Agent or Zabbix Agent 2](https://www.zabbix.com/download_agents), save them in the **pkg** folder, replacing the old files and reusing their names
4. The default settings target LTS releases of Zabbix Agent 2, so edit lines **4 to 9** and/or **42 to 46** of the **cfg\callback.bat** to reflect your monitoring environment
5. Edit the **cfg\servers.txt** file to reference the servers that will receive the agent, one per line, without blank lines, tabulations or spaces
6. Choose the script and run it! **Start-PsRemoZad.ps1** is expected to be faster than **Start-PsExecZad.bat**, so prefer to run the first one and, in case of failure, try the second one; Remember to remove successful servers from **cfg\servers.txt** before the next attempt
7. Track progress through your monitoring or inventory system; In case of failure, send us the logs **zad-install.log**, **zad-uninstall.log** and **zad-control.log**, present in **C:\Windows\Temp** of each failed server

## Roadmap and Changelog

This repository is based on and inspired by - but not limited to - [Keep a Changelog](https://keepachangelog.com/), [Semantic Versioning](https://semver.org/) and the [ezGTR](https://github.com/ezlage/ezGTR) template. Therefore, any changes made, expected or intended will be documented in the [Roadmap and Changelog](./RMAP_CLOG.md) file.  

## Credits, Sponsorship and Licensing

Developed by [Ezequiel Lage](https://github.com/ezlage), Sponsored by [Lageteck](https://lageteck.com) and Published under the [MIT License](./LICENSE.txt).  
  
Credits to Igor Pavlov for developing the 7-Zip<sup>[1](./bin/7za-license.txt)</sup>, to Tarma Software for the Uninstall<sup>[2](./bin/uninstall-license.txt)</sup> tool, to Sysinternals for the PsTools<sup>[3](./bin/psexec-license.txt)</sup> toolkit, to cURL Project for the cURL<sup>[4](./bin/curl-license.txt)</sup> utility, as well as to Zabbix LLC for Zabbix<sup>[5](./pkg/zabbixagent-license.txt)</sup> itself.  

All suggestions, criticisms and contributions are welcome!  

### Support this initiative!

BTC: 1Nw2fzDgtXM5X219Q9VtJ7WaSTDPua3oe8  
ERC20*: 0x089499f57ee20fd2c19f57612d9af69d645dff0d  
\* Any ERC20 token supported by Binance (ETH, USDC, USDT, etc.)  
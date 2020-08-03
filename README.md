# cf-module
A Powershell Module that borrows heavily from https://github.com/philips-software/powershell-cf-api but is more focused on collecting reporting data.

## Installation
1. Clone this repo
2. In Powershell in the directory you checked this repo out into call `Import-Module cf-module.psm1 -Force`
   
## Usage
1. First, call the `Get-CFToken` Cmdlet, and pipe it into the `Set-CFHeaders` Cmdlet to get an OAuth2 token that will be used by subsequent Cmdlets to make CF API Calls: `Get-CFToken "https://api.my.cf.domain.com" "me@here.com" | Set-CFHeaders`
   - Note, this command will prompt you for a password interactivly to protect your password from leaking into your command history. There is a way to pass in a password by converting a literal string into a SecureString using the `ConvertTo-SecureString` cmdlet.  Use the `Get-Help Get-CFToken -Examples` for some options you have for getting a token.
2. Next, you can start calling the various scripts to get info from the CF APIs.  For example, you can use `Get-Organizations` to get a collection of PSObjects representing the converted JSON from calling the `/v3/orgs` REST API:
```PS > Get-Organizations 

guid          : 31f74fef-3404-4c48-8fab-d856227d5033
created_at    : 3/26/2019 6:50:59 PM
updated_at    : 8/3/2020 4:56:35 PM
name          : system
suspended     : False
relationships : @{quota=}
links         : @{self=; domains=; default_domain=; quota=}
metadata      : @{labels=; annotations=}
...
```
3. Many cmdlets are built to be called via a pipeline so that you can perform some complicated queries of the various APIs.  Here's a way to get a report on the buildpacks in use for all the orgs except some platform managed orgs, grouped by buildpack name:
```PS > Get-Organizations | where { $_.Name -notin 'system','credhub-service-broker-org','appdynamics-org' } | Get-Spaces | Get-Apps | group-object -Property {$_.lifecycle.data.buildpacks} | select Name,@{ Name="Apps"; Expression={$_.Group.name}}

Name             Apps
----             ----
                 {spring-music, cf-scale-boot, simple,resource-server-sample}
hwc_buildpack    dot-net-app-16
nodejs_buildpack browsefiles
```
   - Note that in the above example, some applications might not have buildpacks listed if the have been running through a large number of upgrades.  These cmdlets simply reflect what is returned from the CF API.
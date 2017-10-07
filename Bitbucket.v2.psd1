@{
# Version number of this module.
ModuleVersion = '1.1.2'

# ID used to uniquely identify this module
GUID = 'b0ccaa70-a67f-4232-ad58-467fc362edf6'

# Author of this module
Author = 'Paul Towler'

# Company or vendor of this module
# CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2017 Paul Towler and contributors. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Provides cmdlets for obtaining Consumer Keys and Secrets, an Access Token and Refesh Token for a specfic Consumer and the option to Refresh a Token to be used with the Bitbucket API.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Bitbucket', 'OAuth2', 'PowerShell')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/mrptsai/Bitbucket.v2/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/mrptsai/Bitbucket.v2/tree/master'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '
## 1.1.2
* Fixed psm1 file and added Export-ModuleMember to exoort the functions

## 1.1.1
* Fixed release Notes

## 1.1.0
* Rewrote Module. Found I had a cached credential giving me a false positive.
* New modules: ConvertTo-Base64String, Connect-Bitbucket, Get-BitbucketKey, New-BitbucketToken & Update-BitbucketToken
* Removed modules: Get-BitbucketAuthCode, Get-Bitbucket
* Added Human mode to display nice output. Default is non-Human
        
## 1.0.0
* Updated functionality initially created by Yohan Belval https://www.powershellgallery.com/packages/Bitbucket/1.0.5
* Added the ability to get Consumer Keys and Secrets or an Access Token for a Consumer
'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/mrptsai/Bitbucket.v2'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


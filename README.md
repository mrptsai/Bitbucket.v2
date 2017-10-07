# Bitbucket.v2

Logs into Bitbucket as a User or is Authorized by Bitbucket as a Consumer and the Credential is used with the Bitbucket API.

## Functions

### Connect-Bitbucket
**Description**

Stores Credential in your current PowerShell session for later use 

**Parameters**
- **User** - Sets Credentials as a Bitbucket User using the User Bitbucket UserID and Password
- **Consumer** - Sets Credentials as a Consumer using the Consumer Key (ClientID) and Secret

**Examples**
```PowerShell
	Connect-Bitbucket -Mode User

	Connect-Bitbucket -Mode User -Credential $UserCredential

	Connect-Bitbucket -Mode Consumer

	Connect-Bitbucket -Mode Consumer -Credential $ConsumerCredential
```

### Get-BitbucketKey
**Description**

 Obtains all Consumer Keys (ClientID) and Secrest using the Bitbucket API.

**Parameters**
- **UserID** - The Bitbucket User Name used in the Bitbucket URL e.g. https://bitbucket.org/bloggsj
- **Credential** - Optional - Existing Credential Object to access Private Bitbucket Account
- **Human** - Optional - Specify if Human is running function to show formatted display. Default is false

**Examples**
```PowerShell
	Get-BitbucketKey -UserID bloggsj

	Get-BitbucketKey -UserID bloggsj -Credential $UserCreds
```
### New-BitbucketToken
**Description**

Uses the 'password' Grant OAuth2 flow to acquire an Access Token and Refresh Token for a specified consumer.               

**Parameters**
- **UserCredential** - Optional - Existing Credential Object to access Private Bitbucket Account
- **ConsumerCredential** - Optional - Existing Credential Object for Consumer Key (ClientID) and Secret
- **Human** - Optional - Specify if Human is running function to show formatted display. Default is false

**Examples**
```PowerShell
	New-BitbucketToken -Human $true

	New-BitbucketToken -UserCredential $UserCreds

	New-BitbucketToken -UserCredential $UserCreds -ConsumerCredential $ConsumerCreds
```
### Update-BitbucketToken
**Description**

 Uses the 'refresh_token' Grant OAuth2 flow to acquire a new Access Token for the specified consumer.               

**Parameters**
- **RefreshToken** - Refresh Token required to generate a new Access Token for the Consumer
- **Credential** - Optional - Existing Credential Object for Consumer Key (ClientID) and Secret
- **Human** - Optional - Specify if Human is running function to show formatted display. Default is false

**Examples**
```PowerShell
	Update-BitbucketToken -RefreshToken $Token

	Update-BitbucketToken -RefreshToken $Token -Credential $ConsumerCreds

	Update-BitbucketToken -RefreshToken $Token -Human $true
```

## Prerequisites

- Bitbucket Private Account
- Configured Consumer(s)
- PowerShell V5

## Versioning

[Github](http://github.com/) for version control.

## Authors

* **Paul Towler** - *Initial work* - [Bitbucket.v2](https://github.com/mrptsai/External-Cloud/tree/feature-pattern-1/modules/Bitbucket.v2)

See also the list of [contributors](https://github.com/mrptsai/External-Cloud/graphs/contributors) who participated in this project.

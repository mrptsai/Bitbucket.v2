Function ConvertTo-Base64String {
    
    <# 
        .Synopsis 
            Encodes Credentials to a Base64 String
        .DESCRIPTION 
            Takes a Credential as input and return a Base64 String to used in OAuth2 Authentication. 
        .EXAMPLE 
            ConvertTo-Base64String -Creds $Creds
    #>

    param (

        [Parameter(mandatory)]
        [PSCredential]$Creds            

    )

    $tmp = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ( "{0}:{1}" -f $creds.UserName, [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR( $creds.Password ) ) ) ) )

    return $tmp
    
}

Function Connect-Bitbucket {    
    
    <# 
        .Synopsis 
            Logs into Bitbucket as a User or is Authorized by Bitbucket as a Consumer and the Credential are used with the Bitbucket API.
        .DESCRIPTION 
            Stores Credential in your current PowerShell session for later use. 
        .EXAMPLE 
            Connect-Bitbucket -Mode User
        .EXAMPLE 
            Connect-Bitbucket -Mode User -Credential $UserCredential
        .EXAMPLE 
            Connect-Bitbucket -Mode Consumer
        .EXAMPLE 
            Connect-Bitbucket -Mode Consumer -Credential $Credential
        .PARAMETER Mode
            Must be either User or Consumer
            User - Sets Credentials as a Bitbucket User using the User Bitbucket UserID and Password
            Consumer - Sets Credentials as a Consumer using the Consumer Key (ClientID) and Secret
    #>
    
    [CmdLetBinding()]
    param (
                
        [Parameter(mandatory)]
        [ValidateSet("User", "Consumer")]
        [string]$Mode,

        [Parameter()]
        [PSCredential]$Credential
            
    )
    
    begin {

        if ($Credential -and $Mode -eq "User") { $global:bbCredential = $Credential }
        if ($Credential -and $Mode -eq "Consumer") { $global:bbConsumer = $Credential }

    }

    process {

        if ($Mode -eq "User") {
    
            if( !(Test-Path Variable::global:bbCredential) -or ($global:bbCredential -isnot [PSCredential]) ) {

                $global:bbCredential = Get-Credential -Message "Enter your Bitbucket UserID and Password."
    
            }

        } elseif ($Mode -eq "Consumer") {

            if( !(Test-Path Variable::global:bbConsumer) -or ($global:bbConsumer -isnot [PSCredential]) ) {

                $global:bbConsumer = Get-Credential -Message "Enter your Bitbucket Consumer Key and Secret."
    
            }

        }

    }

}

Function Get-BitbucketKey {
    
    <# 
        .Synopsis 
           Obtains all Consumer Keys (ClientID) and Secrest using the Bitbucket API.
        .DESCRIPTION 
            Uses the 'password Grant' OAuth2 flow to list all Consumers for a specified Bitbucket User.
        .EXAMPLE 
           Get-BitbucketKey -UserID bloggsj
        .EXAMPLE 
           Get-Bitbucket -UserID bloggsj -Credential $UserCreds
        .PARAMETER UserID
            The Bitbucket User Name used in the Bitbucket URL e.g. https://bitbucket.org/bloggsj
        .PARAMETER Credential
            Existing Credential Object to access Private Bitbucket Account
        .PARAMETER Human
            Specify if Human is running function to show formatted display. Default is false
    #>

    [CmdLetBinding()]
    Param (

        [Parameter(mandatory)]
        [string]$UserID,

        [Parameter()]
        [PSCredential]$Credential,

        [Parameter()]
        [bool]$Human = $false

    )

    begin {
    
       Connect-Bitbucket -Mode User -Credential $Credential

       [string]$EndpointUrl = "https://api.bitbucket.org/1.0/users/" + $UserID + "/consumers" 
               
    }

    process {

        try {           
                    
            $base64AuthInfo = ConvertTo-Base64String -Creds $global:bbCredential
                
            $output = Invoke-RestMethod -Uri $endpointUrl -Headers @{ Authorization = ("Basic {0}" -f $base64AuthInfo) } -Method Get -ErrorVariable _Err -ErrorAction SilentlyContinue

            if ($Human) {

                $output | % {
                    
                    Write-Host " Consumer:`t" -ForegroundColor Green -NoNewline
                    Write-Host $output.name -ForegroundColor White
                    Write-Host " Key:`t`t" -ForegroundColor Green -NoNewline
                    Write-Host $output.key -ForegroundColor White
                    Write-Host " Secret:`t" -ForegroundColor Green -NoNewline
                    Write-Host $output.secret -ForegroundColor White
                    Write-Host
                }

            } else {

                $output

            }

        }
        catch { Write-Error $_ }
        
    }
        
}

Function New-BitbucketToken {
    
    <# 
        .Synopsis 
           Obtains an Access Token and Refresh Token to use with the Bitbucket API.
        .DESCRIPTION 
            Uses the 'password' Grant OAuth2 flow to acquire an Access Token and Refresh Token for a specified consumer. 
        .EXAMPLE 
           New-BitbucketToken -Human $true
        .EXAMPLE 
           New-BitbucketToken -UserCredential $UserCreds
        .EXAMPLE 
           New-BitbucketToken -UserCredential $UserCreds -ConsumerCredential $ConsumerCreds
        
    #>

    [CmdLetBinding()]
    Param (

        [Parameter()]
        [PSCredential]$UserCredential,

        [Parameter()]
        [PSCredential]$ConsumerCredential,

        [Parameter()]
        [bool]$Human = $false

    )

    begin {
               
        Connect-Bitbucket -Mode User -Credential $UserCredential
        Connect-Bitbucket -Mode Consumer -Credential $ConsumerCredential

        [string]$EndpointUrl = "https://bitbucket.org/site/oauth2/access_token"

    }

    process {
                    
        try {

            $base64AuthInfo = ConvertTo-Base64String -creds $global:bbConsumer

            $requestBody = @{
                grant_type = 'password'
                username = $global:bbCredential.UserName
                password = $global:bbCredential.GetNetworkCredential().Password 
            }
                                
            $output = Invoke-RestMethod -Uri $EndpointUrl -Headers @{ Authorization = ("Basic {0}" -f $base64AuthInfo) } -Method Post -Body $requestBody -ErrorVariable _Err -ErrorAction SilentlyContinue

            if ($Human) {

                Write-Host " Access Token is: " -ForegroundColor Green -NoNewline
                Write-Host $output.access_token -ForegroundColor White
                Write-Host
                Write-Host " Refresh Token is: " -ForegroundColor Green -NoNewline
                Write-Host $output.refresh_token -ForegroundColor White
                Write-Host

            } else {

                $output
                
            }
                
        }
        catch { Write-Error $_ }

    }
        
}

Function Update-BitbucketToken {
    
    <# 
        .Synopsis 
           Obtains an Access Token using a Refresh Token.
        .DESCRIPTION 
           Uses the 'refresh_token' Grant OAuth2 flow to acquire a new Access Token for the specified consumer. 
        .EXAMPLE 
           Update-BitbucketToken -RefreshToken $Token
        .EXAMPLE 
           Update-BitbucketToken -RefreshToken $Token -Credential $ConsumerCreds
        .EXAMPLE 
           Update-BitbucketToken -RefreshToken $Token -Human $true
    #>

    [CmdLetBinding()]
    Param (

        [Parameter()]
        [string]$RefreshToken,

        [Parameter()]
        [PSCredential]$Credential,
                
        [Parameter()]
        [bool]$Human = $false

    )

    begin {
               
       Connect-Bitbucket -Mode Consumer -Credential $Credential

       [string]$EndpointUrl = "https://bitbucket.org/site/oauth2/access_token"

    }

    process {       
        
        try {
        
            $base64AuthInfo = ConvertTo-Base64String -creds $global:bbConsumer

            $requestBody = @{
                grant_type = 'refresh_token'
                refresh_token = $RefreshToken
            }
                                
            $output = Invoke-RestMethod -Uri $EndpointUrl -Headers @{ Authorization = ("Basic {0}" -f $base64AuthInfo) } -Method Post -Body $requestBody -ErrorVariable _Err -ErrorAction SilentlyContinue

            if ($Human) {

                Write-Host " Access Token is: " -ForegroundColor Green -NoNewline
                Write-Host $output.access_token -ForegroundColor White
                Write-Host

            } else {

                $output
                
            }
                
        }
        catch { Write-Error $_ }

    }
        
}

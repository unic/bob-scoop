$ErrorActionPreference = 'Stop'
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

Function Sync-Unicorn {
	Param(
		[Parameter(Mandatory=$True)]
		[string]$ControlPanelUrl,

		[Parameter(Mandatory=$True)]
		[string]$SharedSecret,

		[string[]]$Configurations,

		[string]$Verb = 'Sync'
	)

	# PARSE THE URL TO REQUEST
	$parsedConfigurations = ($Configurations) -join "^"

	$url = "{0}?verb={1}&configuration={2}" -f $ControlPanelUrl, $Verb, $parsedConfigurations

	Write-Host "Sync-Unicorn: Preparing authorization for $url"

	# GET AN AUTH CHALLENGE
	$challenge = Get-Challenge -ControlPanelUrl $ControlPanelUrl

	Write-Host "Sync-Unicorn: Received challenge: $challenge"

	$signature = CreateSignature $challenge $url $SharedSecret

	Write-Host "Sync-Unicorn: Created signature $signature, executing $Verb..."

	# USING THE SIGNATURE, EXECUTE UNICORN
	HttpGet $url -Headers @{ "X-MC-MAC" = $signature; "X-MC-Nonce" = $challenge } -Timeout 10800 

	$result
}

Function HttpGet($url, $headers = @{}, $timeout = 360) {
    $request = [System.Net.WebRequest]::Create($url)
    $request.Timeout = $timeout * 1000
    foreach($key in $headers.Keys) {
        $request.Headers.Add($key, $headers[$key])
    }
    
    try {
        $response = $request.GetResponse()
    }
    catch [System.Net.WebException] {
        $statusCode = [int]$_.Exception.Response.StatusCode
        $content = (New-Object System.IO.StreamReader $_.Exception.Response.GetResponseStream()).ReadToEnd()
        throw "Error when performing Unicorn sync.`nStatus Code: $statusCode `n`n=====`n`n$content`n`n====="
    }
    
    if($response.StatusCode -gt 400) {
        throw "Error, status code $($response.StatusCode), $((New-Object System.IO.StreamReader $response.GetResponseStream()).ReadToEnd())"
    }
    (New-Object System.IO.StreamReader $response.GetResponseStream()).ReadToEnd()
}

Function Get-Challenge {
	Param(
		[Parameter(Mandatory=$True)]
		[string]$ControlPanelUrl
	)

	HttpGet "$($ControlPanelUrl)?verb=Challenge"
    
    
	#$result = Invoke-WebRequest -Uri $url -TimeoutSec 360 -UseBasicParsing

	#$result.Content
}

Function CreateSignature {
    param(
        $challenge,
        $url,
        $sharedSecret
    )
    
    $uri = New-Object Uri $url
    $url = ($uri.Host + $uri.PathAndQuery).ToUpperInvariant()
    
    $signature = "$challenge|$sharedSecret|$url"
    $sha = New-Object System.Security.Cryptography.SHA512Managed
    $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($signature));
    return [System.Convert]::ToBase64String($hash)
}

Export-ModuleMember -Function Sync-Unicorn
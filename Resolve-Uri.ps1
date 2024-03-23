<#
    .SYNOPSIS

    Resolve a URI to the URIs it redirects to

    .EXAMPLE

    PS> Resolve-Uri https://bit.ly/e0Mw9w

    https://bit.ly/e0Mw9w
    http://www.leeholmes.com/projects/ps_html5/Invoke-PSHtml5.ps1
#>

Function Resolve-Uri {

    param(
        ## The URI to resolve
        [Parameter(Mandatory, Position = 0)]
        $Uri
    )
    $ProgressPreference = "Ignore"
    $ErrorActionPreference = "Stop"

    ## While we still have a URI to process
    while ($Uri) {
        $Uri

        ## Connect to the URI. Don't allow redirects, so that we can see
        ## where it redirects to.
        $wc = [System.Net.HttpWebRequest]::Create($Uri)
        $wc.AllowAutoRedirect = $false
        try {
            $response = $wc.GetResponse()
        
            ## If it was a redirect (with a "Location" header), store that and
            ## process it the next time around.
            if ($response.Headers["Location"]) {
                $Uri = $response.Headers["Location"]
            }
            else {
                $Uri = $null
            }
        }

        catch {
            ## Some scenarios handle the scenario above through an exception, so
            ## handle that here.
            if ($_.Exception.InnerException.Response.StatusCode -eq "Moved") {
                $Uri = $_.Exception.InnerException.Response.Headers["Location"]
            }

            else {
                throw $_
            }
        }
    }

}
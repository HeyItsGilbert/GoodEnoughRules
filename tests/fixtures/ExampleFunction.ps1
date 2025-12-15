function Get-Example {
    [CmdletBinding()]
    param ()

    begin {
        $beginIWR = Invoke-WebRequest -Uri "https://example.com"
    }

    process {
        $processIWR = Invoke-WebRequest -Uri "https://example.org"
        $processIWR
        $badParam = Invoke-WebRequest -Uri "https://example.net" -UseBasicParsing
        $badParam.Forms
    }

    end {
        $beginIWR.Forms
        $badParam.AllElements
    }
}

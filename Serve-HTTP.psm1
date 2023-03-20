function Serve-HTTP {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]$port = 8080
    )

    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://*:$port/")
    $listener.Start()

    Write-Host "Listening on http://localhost:$port/"
    Write-Host "Web root: $(Get-Location)"
    Write-Host "Press Ctrl+C to stop the server."

    try {
        while ($true) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response

            Write-Host "RawUrl: $($request.RawUrl)"

            $filePath = $request.RawUrl.TrimStart('/')
            $filePath = [System.Uri]::UnescapeDataString($filePath)
            $filePath = Join-Path (Get-Location) $filePath

            if (-not $request.RawUrl -or $request.RawUrl -eq "/") {
                $fileList = Get-ChildItem | ForEach-Object {
                    "<li><a href='$($_.Name)' target='_blank'>$($_.Name)</a></li>"
                }
                $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>File List</title>
</head>
<body>
    <h1>File List</h1>
    <ul>
        $($fileList -join "`n")
    </ul>
</body>
</html>
"@
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
                $response.ContentLength64 = $buffer.Length
                $response.ContentType = "text/html"
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            } elseif (Test-Path $filePath -PathType Leaf) {
                $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
                $response.ContentLength64 = $fileBytes.Length
                $response.ContentType = [System.Net.Mime.MediaTypeNames]::Application.Octet
                $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
            } else {
                $response.StatusCode = 404
                $response.StatusDescription = 'File not found'
                $response.OutputStream.Close()
            }

            $response.Close()
        }
    } catch [System.Threading.ThreadAbortException] {
        Write-Host "Stopping server..."
    } finally {
        $listener.Stop()
        $listener.Close()
    }
}

Export-ModuleMember -Function 'Serve-HTTP'

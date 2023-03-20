# Serve-HTTP PowerShell Module
The Serve-HTTP module is a PowerShell module that provides a simple web server that can be used to serve static files or dynamic content over HTTP.

## Installation
To install the Serve-HTTP module, download the Serve-HTTP.psm1 file and save it to a location in your PowerShell module path. You can then import the module using the Import-Module cmdlet:

```
Import-Module .\Serve-HTTP.psm1
```
Usage
The Serve-HTTP module provides a single function, Serve-HTTP, that starts the web server. By default, the server listens on port 8080, but you can specify a different port using the -port parameter: Serve-HTTP -port 8081

Once the server is running, you can access it using a web browser by navigating to http://localhost:8080/ (or the port you specified).

The server serves files from the current directory by default. If you navigate to http://localhost:8080/ in a web browser, you will see a list of files in the current directory. You can navigate to individual files by clicking on their links.

If the requested file is not found, the server returns a 404 error.

## Serve-HTTPData.ps1
The Serve-HTTPData.ps1 file provides a one-liner that starts a simple web server that serves a single string response, stored in the $data variable, on http://localhost:8080/. This can be useful for testing or for providing a simple API endpoint or transferring a file to another host. 

You can run this file using the following command:
```
.\Serve-HTTPData.ps1
```

or by creating your own $data variable and then copy and pasting the oneliner:
```
$listener = New-Object System.Net.HttpListener;$listener.Prefixes.Add("http://localhost:8080/");$listener.Start();while ($listener.IsListening){$context = $listener.GetContext();$request = $context.Request;$response = $context.Response; $buffer = [System.Text.Encoding]::UTF8.GetBytes($data); $response.OutputStream.Write($buffer, 0, $buffer.Length); $response.Close() }
```
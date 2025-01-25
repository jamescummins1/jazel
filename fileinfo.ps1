function Get-FileInfo {
    [CmdletBinding()]
    param (
        # Specify the directory path
        [Parameter(Mandatory = $true)]
        [string]$Path,

        # Filter files by extension (e.g., "*.txt")
        [Parameter(Mandatory = $false)]
        [string]$Filter = "*.*"
    )

    begin {
        # Validate the directory path
        if (-not (Test-Path -Path $Path)) {
            Write-Error "The specified path '$Path' does not exist."
            return
        }

        Write-Verbose "Retrieving file information from '$Path' with filter '$Filter'"
    }

    process {
        try {
            # Get files matching the filter
            $files = Get-ChildItem -Path $Path -Filter $Filter

            # Output file information
            foreach ($file in $files) {
                [PSCustomObject]@{
                    Name         = $file.Name
                    FullName     = $file.FullName
                    SizeBytes    = $file.Length
                    SizeMB       = [math]::Round($file.Length / 1MB, 2) # Convert bytes to MB and round to 2 decimal places
                    LastModified = $file.LastWriteTime
                    Extension    = $file.Extension
                }
            }
        } catch {
            Write-Error "An error occurred: $_"
        }
    }

    end {
        Write-Verbose "File information retrieval completed."
    }
}
```

### Key Changes:
1. **SizeMB**: Added a new property `SizeMB` to the output object. It converts the file size from bytes to megabytes using `[math]::Round($file.Length / 1MB, 2)` and rounds it to 2 decimal places for readability.

### Example Output:
If you run the function, the output will now include both the file size in bytes (`SizeBytes`) and megabytes (`SizeMB`):

```powershell
# Get all .txt files in the "C:\Documents" directory
Get-FileInfo -Path "C:\Documents" -Filter "*.txt" -Verbose
```

Example output:
```
Name       : example.txt
FullName   : C:\Documents\example.txt
SizeBytes  : 1048576
SizeMB     : 1.00
LastModified: 1/25/2025 10:00:00 AM
Extension  : .txt
```

Let me know if you need further enhancements! 😊
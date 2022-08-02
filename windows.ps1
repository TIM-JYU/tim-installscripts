new-module -name installer -scriptblock {
    Function Install-Project() {
        param (
            [Parameter(Mandatory)]
            [ValidateSet("prod", "dev", "test")]
            [string]
            $Profile = "prod",
            [Parameter(Mandatory = $false)]
            [string]
            $Destination = "C:\",
            [Parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
            [string[]]
            $ScriptArgs
        )
        
        $ScriptsUrlBase = "https://raw.githubusercontent.com/TIM-JYU/tim-installscripts/master"
        Invoke-WebRequest -Uri "$ScriptsUrlBase/setup.ps1" -OutFile "setup.ps1"
        # concatinate scriptargs
        $ScriptArgsJoined = $ScriptArgs -join " "
        Start-Process -FilePath PowerShell.exe -ArgumentList "-ExecutionPolicy Bypass -File setup.ps1 -Profile $Profile -Destination `"$Destination`" $ScriptArgsJoined"
    }
  
    set-alias install -value Install-Project
  
    export-modulemember -function 'Install-Project' -alias 'install'
}
param (
    [Parameter(Mandatory)]
    [ValidateSet("prod", "dev", "test")]
    [string]
    $InstallProfile,
    [Parameter(Mandatory = $false)]
    [string]
    $Destination = "C:\\",
    [Parameter(Mandatory = $false)]
    [string]
    $Stage = "",
    [Parameter(Position = 0, Mandatory = $false, ValueFromRemainingArguments = $true)]
    [string[]]
    $ScriptArgs
)

$Cmd = $PSCommandPath
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $EscapedDestination = [Management.Automation.WildcardPattern]::Escape($Destination).Replace("\", "\\")
        $CommandLine = "-ExecutionPolicy Bypass -NoProfile -NonInteractive -NoExit -File `"$Cmd`" -InstallProfile $InstallProfile -Destination `"$EscapedDestination`" -Stage $Stage $($ScriptArgs -join " ")"
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

function Install-Winget {
    if (!(Get-Command -Name winget)) {
        if (!(Test-Path "$HOME\.winget")) {
            New-Item -Path "$HOME\.winget" -ItemType Directory -Force
        }
        if ([Environment]::Is64BitOperatingSystem) { $arch = "x64" } else { $arch = "x86" }
        Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$HOME\.winget\winget.msix"
        Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.$arch.14.00.Desktop.appx" -OutFile "$HOME\.winget\vclibs.appx"
        Add-AppxPackage -Path "$HOME\.winget\vclibs.appx"
        Add-AppPackage -path "$HOME\.winget\winget.msix"
        Remove-Item -path "$HOME\.winget\winget.msix" -Force
    }
}

function Reset-EnvVars {
    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Install-Main-Deps {
    Write-Output "Installing Git"
    winget install --accept-source-agreements --accept-package-agreements -e --id Git.Git
    Write-Output "Installing Python 3"
    winget install --accept-source-agreements --accept-package-agreements -e --id Python.Python.3
}

function Install-Dev-Deps {
    # if Profile is dev, install dev dependencies
    if ($InstallProfile -eq "dev") {
        Write-Output "Installing NodeJS"
        winget install --accept-source-agreements --accept-package-agreements -e --id OpenJS.NodeJS.LTS
        Reset-EnvVars
        Write-Output "Downgrading NPM to 6.x"
        npm install --accept-source-agreements --accept-package-agreements --global npm@6
        Write-Output "Installing PyCharm"
        winget install --accept-source-agreements --accept-package-agreements -e --id JetBrains.PyCharm.Professional
    }
}

function Restart-Stage {
    Param ([string]$Target)
    $EscapedDestination = [Management.Automation.WildcardPattern]::Escape($Destination).Replace("\", "\\")
    $CommandLine = "powershell -ExecutionPolicy Bypass -NoProfile -NoExit -File `"$Cmd`" -InstallProfile $InstallProfile -Destination `"$EscapedDestination`" -Stage $Target $($ScriptArgs -join " ")"
    Set-Location -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
    New-ItemProperty . TimInstall -Force -PropertyType String -Value $CommandLine
    Restart-Computer
}

function Install-Docker {
    Write-Output "Installing Docker"
    winget install --accept-source-agreements --accept-package-agreements -e --id Docker.DockerDesktop
    Restart-Stage "UpdateWSL2"
}

function Update-Wsl2 {
    Write-Output "Updating WSL2 kernel"
    wsl --update
    Restart-Stage "InstallTIM"
}

function Install-TIM {
    # Ensure Docker Desktop is started
    Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    # Make directory to $Destination/tim
    if (!(Test-Path "$Destination\tim")) {
        New-Item -Path "$Destination\tim" -ItemType Directory -Force
    }
    Set-Location -Path "$Destination\tim"
    # Download TIM
    git clone "https://github.com/TIM-JYU/TIM.git" .
    # Because we don't directly have shell, run py command manually
    py -m cli.tim setup --profile $InstallProfile $ScriptArgs
}

if ($Stage -eq "") {
    Install-Main-Deps
    Install-Dev-Deps
    Install-Docker
}
elseif ($Stage -eq "UpdateWSL2") {
    Update-Wsl2
}
elseif ($Stage -eq "InstallTIM") {
    Install-TIM
}
else {
    Write-Output "Invalid step"
}
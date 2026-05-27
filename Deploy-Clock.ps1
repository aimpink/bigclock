[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$HostName,

    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$UserName = 'abellaspecialtie'
$PrivateKeyPath = 'C:\Users\aimpi\OneDrive\Documents\Personal\abella-guessingsucks'
$RemoteDestination = '/home/abellaspecialtie/www/clock'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Validate required external dependencies first for clearer failures.
$requiredCommands = @('ssh', 'scp')
foreach ($commandName in $requiredCommands) {
    if (-not (Get-Command -Name $commandName -ErrorAction SilentlyContinue)) {
        throw "Required command '$commandName' was not found in PATH. Install OpenSSH client tools and retry."
    }
}

# Validate SSH key path before collecting files.
if (-not (Test-Path -LiteralPath $PrivateKeyPath -PathType Leaf)) {
    throw "SSH private key file not found at: $PrivateKeyPath"
}

# Core app files required for deployment.
$coreFiles = @(
    'index.html',
    'manifest.json',
    'pwa.js',
    'sw.js',
    'favicon.svg',
    'favicon.ico'
)

$filesToDeploy = New-Object System.Collections.Generic.List[string]

foreach ($relativePath in $coreFiles) {
    $fullPath = Join-Path -Path $ScriptDir -ChildPath $relativePath
    if (Test-Path -LiteralPath $fullPath -PathType Leaf) {
        $item = Get-Item -LiteralPath $fullPath
        if (-not $item.Attributes.HasFlag([IO.FileAttributes]::Hidden)) {
            $filesToDeploy.Add($item.FullName)
        }
    }
}

# Include all non-hidden PNG files in the project root.
$pngFiles = Get-ChildItem -LiteralPath $ScriptDir -File -Filter '*.png' -ErrorAction SilentlyContinue |
    Where-Object { -not $_.Attributes.HasFlag([IO.FileAttributes]::Hidden) } |
    Select-Object -ExpandProperty FullName

foreach ($png in $pngFiles) {
    if (-not $filesToDeploy.Contains($png)) {
        $filesToDeploy.Add($png)
    }
}

if ($filesToDeploy.Count -eq 0) {
    throw 'No deployable files found. Ensure required files exist in the script directory.'
}

Write-Host 'Files selected for deployment:' -ForegroundColor Cyan
$filesToDeploy |
    Sort-Object |
    ForEach-Object { Write-Host " - $(Split-Path -Leaf $_)" }

Write-Host ''
Write-Host "Target: ${UserName}@${HostName}:${RemoteDestination}" -ForegroundColor Cyan

$sshTarget = "${UserName}@${HostName}"

# Ensure destination exists before upload.
$mkdirArgs = @(
    '-i', $PrivateKeyPath,
    $sshTarget,
    "mkdir -p '$RemoteDestination'"
)

# Upload selected files only; hidden files are never included.
$scpArgs = @(
    '-i', $PrivateKeyPath
) + $filesToDeploy + @(
    "${sshTarget}:${RemoteDestination}/"
)

if ($DryRun) {
    Write-Host ''
    Write-Host 'DRY RUN: no remote changes will be made.' -ForegroundColor Yellow
    Write-Host "Would run: ssh $($mkdirArgs -join ' ')"
    Write-Host "Would run: scp $($scpArgs -join ' ')"
    return
}

Write-Host ''
Write-Host 'Starting deployment...' -ForegroundColor Green

& ssh @mkdirArgs
& scp @scpArgs

Write-Host 'Deployment completed successfully.' -ForegroundColor Green

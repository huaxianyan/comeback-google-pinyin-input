[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ApkPath,
    [Parameter(Mandatory = $true)][string]$ApktoolJar,
    [Parameter(Mandatory = $true)][string]$SignerJar,
    [Parameter(Mandatory = $true)][string]$Keystore,
    [Parameter(Mandatory = $true)][string]$KeyAlias,
    [Parameter(Mandatory = $true)][string]$StorePassword,
    [Parameter(Mandatory = $true)][string]$KeyPassword
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$WorkDir = Join-Path $RepoRoot "work/decoded"
$BuildDir = Join-Path $RepoRoot "build"
$DistDir = Join-Path $RepoRoot "dist"
$FrameworkDir = Join-Path $RepoRoot "work/apktool-framework"
$TempDir = Join-Path $RepoRoot "work/tmp"

$ApkPath = (Resolve-Path $ApkPath).Path
$ApktoolJar = (Resolve-Path $ApktoolJar).Path
$SignerJar = (Resolve-Path $SignerJar).Path
$Keystore = (Resolve-Path $Keystore).Path

New-Item -ItemType Directory -Force $BuildDir, $DistDir, $FrameworkDir, $TempDir | Out-Null
if (Test-Path $WorkDir) {
    Remove-Item -Recurse -Force $WorkDir
}

# Keep Java/apktool/signer temporary files inside the repository workspace.
$env:TEMP = $TempDir
$env:TMP = $TempDir
$env:JAVA_TOOL_OPTIONS = "-Djava.io.tmpdir=$TempDir"

Write-Host "[1/4] Decoding original APK..."
& java -jar $ApktoolJar d -f -p $FrameworkDir -o $WorkDir $ApkPath
if ($LASTEXITCODE -ne 0) { throw "apktool decode failed" }

Write-Host "[2/4] Applying compatibility patches..."
& python (Join-Path $PSScriptRoot "apply_patches.py") $WorkDir
if ($LASTEXITCODE -ne 0) { throw "patching failed" }

$UnsignedApk = Join-Path $BuildDir "google-pinyin-4.5.2-a16-a17-compat-v5-unsigned.apk"
Write-Host "[3/4] Rebuilding APK..."
& java -jar $ApktoolJar b -p $FrameworkDir -o $UnsignedApk $WorkDir
if ($LASTEXITCODE -ne 0) { throw "apktool build failed" }

Write-Host "[4/4] Aligning, signing and verifying APK..."
& java -jar $SignerJar `
    -a $UnsignedApk `
    --ks $Keystore `
    --ksAlias $KeyAlias `
    --ksPass $StorePassword `
    --ksKeyPass $KeyPassword `
    -o $DistDir
if ($LASTEXITCODE -ne 0) { throw "APK signing failed" }

Write-Host "Done. Signed APK is in: $DistDir"

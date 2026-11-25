param([ValidateSet('x64','arm64')][string]$Architecture = $(if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {'arm64'} else {'x64'}))
$ErrorActionPreference = 'Stop'
if (-not $IsWindows) { throw 'Execute com PowerShell 7 em Windows.' }
$native = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {'arm64'} else {'x64'}
if ($Architecture -ne $native) { throw 'Use um host da arquitetura solicitada.' }
$root = (Resolve-Path "$PSScriptRoot/../..").Path
function Invoke-Checked { param([string]$Command, [string[]]$Arguments) & $Command @Arguments; if ($LASTEXITCODE -ne 0) { throw "$Command falhou: $LASTEXITCODE" } }
Push-Location "$root/apps/server"
try {
  Invoke-Checked dart @('pub','get')
  Invoke-Checked dart @('build','cli','--target','bin/dPad_server.dart','-o','build/server')
} finally { Pop-Location }
Push-Location "$root/apps/client"
try {
  Invoke-Checked flutter @('pub','get')
  Invoke-Checked flutter @('build','windows','--release')
} finally { Pop-Location }
$bundle = "$root/apps/client/build/windows/$Architecture/runner/Release"
if (Test-Path "$bundle/server") { Remove-Item -Recurse -Force "$bundle/server" }
New-Item -ItemType Directory -Force "$bundle/server", "$root/dist" | Out-Null
Copy-Item -Recurse -Force "$root/apps/server/build/server/bundle/*" "$bundle/server/"
foreach ($file in @('papel_digital.exe','server/bin/dPad_server.exe','flutter_windows.dll','data/flutter_assets/assets/logo.svg')) {
  if (-not (Test-Path "$bundle/$file")) { throw "Arquivo ausente: $file" }
}
$temporary = Join-Path ([IO.Path]::GetTempPath()) ('dpad-' + [guid]::NewGuid())
$port = Get-Random -Minimum 20000 -Maximum 45000
$server = Start-Process "$bundle/server/bin/dPad_server.exe" -ArgumentList @('--data', ('"' + $temporary + '"'), '--port', "$port") -PassThru -NoNewWindow
try {
  $healthy = $false
  for ($i = 0; $i -lt 100; $i++) {
    if ($server.HasExited) { throw 'Servidor encerrou durante a inicialização' }
    try { if ((Invoke-RestMethod "http://127.0.0.1:$port/health" -TimeoutSec 2).application -eq 'papel-digital') { $healthy = $true; break } } catch {}
    Start-Sleep -Milliseconds 200
  }
  if (-not $healthy) { throw 'Servidor não respondeu à rota de saúde' }
} finally {
  if (-not $server.HasExited) { Stop-Process -Id $server.Id; $server.WaitForExit() }
  if (Test-Path $temporary) { Remove-Item -Recurse -Force $temporary }
}
$archive = "$root/dist/DoPapelAoDigital-windows-$Architecture.zip"
Compress-Archive -Path "$bundle/*" -DestinationPath $archive -Force
Write-Host "Bundle: $archive"

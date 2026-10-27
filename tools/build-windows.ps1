$ErrorActionPreference = 'Stop'
if (-not $IsWindows -and $env:OS -ne 'Windows_NT') {
  throw 'Compile em Windows com Flutter e Visual Studio (Desktop development with C++).'
}
$root = Split-Path $PSScriptRoot -Parent
Push-Location "$root/apps/server"
try {
  dart pub get
  if ($LASTEXITCODE) { throw 'Dependências do servidor falharam' }
  dart analyze
  if ($LASTEXITCODE) { throw 'Análise do servidor falhou' }
  dart build cli --target bin/dPad_server.dart -o build/server
  if ($LASTEXITCODE) { throw 'Build do servidor falhou' }
} finally { Pop-Location }
Push-Location "$root/apps/client"
try {
  flutter pub get
  if ($LASTEXITCODE) { throw 'Dependências do cliente falharam' }
  flutter analyze
  if ($LASTEXITCODE) { throw 'Análise do cliente falhou' }
  flutter build windows --release
  if ($LASTEXITCODE) { throw 'Build Windows falhou' }
  $bundle = "$root/apps/client/build/windows/x64/runner/Release"
  New-Item -ItemType Directory -Force "$bundle/server" | Out-Null
  Copy-Item -Recurse -Force "$root/apps/server/build/server/bundle/*" "$bundle/server/"
  foreach ($required in @("$bundle/papel_digital.exe", "$bundle/server/bin/dPad_server.exe", "$bundle/flutter_windows.dll", "$bundle/data/flutter_assets/assets/logo.svg")) {
    if (-not (Test-Path $required)) { throw "Arquivo obrigatório ausente: $required" }
  }
  $temporary = Join-Path ([System.IO.Path]::GetTempPath()) ("dpad-bundle-" + [guid]::NewGuid())
  $port = Get-Random -Minimum 20000 -Maximum 45000
  $server = Start-Process "$bundle/server/bin/dPad_server.exe" -ArgumentList @('--data', ('"' + $temporary + '"'), '--port', "$port") -PassThru -NoNewWindow
  try {
    $healthy = $false
    for ($i = 0; $i -lt 100; $i++) {
      if ($server.HasExited) { throw 'Servidor empacotado encerrou durante a inicialização' }
      try {
        $health = Invoke-RestMethod "http://127.0.0.1:$port/health"
        if ($health.application -eq 'papel-digital') { $healthy = $true; break }
      } catch {}
      Start-Sleep -Milliseconds 200
    }
    if (-not $healthy) { throw 'Servidor empacotado não respondeu à rota de saúde' }
  } finally {
    if (-not $server.HasExited) { Stop-Process -Id $server.Id; $server.WaitForExit() }
    if (Test-Path $temporary) { Remove-Item -Recurse -Force $temporary }
  }
  New-Item -ItemType Directory -Force "$root/dist" | Out-Null
  $archive = "$root/dist/DoPapelAoDigital-windows-x64.zip"
  Compress-Archive -Path "$bundle/*" -DestinationPath $archive -Force
  Get-FileHash -Algorithm SHA256 $archive | Format-List
  Write-Host "Bundle: $archive"
} finally { Pop-Location }

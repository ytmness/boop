# Script para agregar Flutter al PATH del sistema
Write-Host "🔧 Agregando Flutter al PATH..." -ForegroundColor Cyan

$flutterPath = "C:\Users\PC\flutter\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)

if ($currentPath -notlike "*$flutterPath*") {
    Write-Host "Agregando Flutter al PATH del sistema..." -ForegroundColor Yellow
    
    # Agregar al PATH del sistema (requiere permisos de administrador)
    $newPath = $currentPath + ";$flutterPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::Machine)
    
    Write-Host "✅ Flutter agregado al PATH del sistema" -ForegroundColor Green
    Write-Host "⚠️  IMPORTANTE: Reinicia Cursor para que los cambios surtan efecto" -ForegroundColor Yellow
} else {
    Write-Host "✅ Flutter ya está en el PATH" -ForegroundColor Green
}

# También agregar al PATH de la sesión actual
$env:Path += ";$flutterPath"

Write-Host "`nVerificando instalación..." -ForegroundColor Cyan
flutter --version

Write-Host "`n📝 Próximos pasos:" -ForegroundColor Cyan
Write-Host "   1. Cierra y vuelve a abrir Cursor" -ForegroundColor White
Write-Host "   2. Abre la terminal en Cursor (Ctrl + `)" -ForegroundColor White
Write-Host "   3. Ejecuta: flutter doctor" -ForegroundColor White
Write-Host "   4. Si aún no funciona, ejecuta: flutter config --enable-web" -ForegroundColor White


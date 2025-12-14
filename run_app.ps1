# Script para ejecutar la app BOOP
Write-Host "🚀 Verificando Flutter..." -ForegroundColor Cyan

# Verificar si Flutter está instalado
$flutterCheck = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterCheck) {
    Write-Host "✅ Flutter encontrado!" -ForegroundColor Green
    $version = flutter --version 2>&1 | Select-Object -First 1
    Write-Host $version -ForegroundColor Gray
    
    Write-Host "`n📦 Instalando dependencias..." -ForegroundColor Cyan
    flutter pub get
    
    Write-Host "`n🌐 Ejecutando app en Chrome..." -ForegroundColor Cyan
    Write-Host "   (Presiona 'q' para salir)" -ForegroundColor Yellow
    flutter run -d chrome
} else {
    Write-Host "`n❌ Flutter no está instalado o no está en el PATH" -ForegroundColor Red
    Write-Host "`n📖 Instrucciones para instalar Flutter:" -ForegroundColor Yellow
    Write-Host "   1. Ve a: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "   2. Descarga el SDK de Flutter" -ForegroundColor White
    Write-Host "   3. Extrae a C:\src\flutter (o donde prefieras)" -ForegroundColor White
    Write-Host "   4. Agrega C:\src\flutter\bin al PATH del sistema" -ForegroundColor White
    Write-Host "   5. Reinicia PowerShell y ejecuta este script nuevamente" -ForegroundColor White
    Write-Host "`n   O ejecuta manualmente:" -ForegroundColor Yellow
    Write-Host "   flutter pub get" -ForegroundColor Cyan
    Write-Host "   flutter run -d chrome" -ForegroundColor Cyan
}

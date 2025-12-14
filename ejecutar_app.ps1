# Script para ejecutar la app BOOP
# Este script agrega Flutter al PATH y ejecuta la app

Write-Host "🚀 Configurando Flutter..." -ForegroundColor Cyan

# Agregar Flutter al PATH de esta sesión
$flutterPath = "C:\Users\PC\flutter\bin"
if ($env:Path -notlike "*$flutterPath*") {
    $env:Path += ";$flutterPath"
    Write-Host "✅ Flutter agregado al PATH de esta sesión" -ForegroundColor Green
}

# Verificar Flutter
Write-Host "`n📦 Verificando Flutter..." -ForegroundColor Cyan
flutter --version | Select-Object -First 1

# Instalar dependencias si es necesario
Write-Host "`n📥 Verificando dependencias..." -ForegroundColor Cyan
flutter pub get

# Ejecutar la app
Write-Host "`n🌐 Ejecutando app en Chrome..." -ForegroundColor Cyan
Write-Host "   (Presiona 'q' para salir cuando la app esté corriendo)" -ForegroundColor Yellow
flutter run -d chrome


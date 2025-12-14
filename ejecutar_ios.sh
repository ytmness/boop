#!/bin/bash

# Script para ejecutar BOOP en el simulador iOS
echo "🚀 Ejecutando BOOP en el simulador iOS..."

# Ruta de Flutter
FLUTTER_PATH="/Users/user284318/flutter/bin/flutter"

# Verificar que Flutter existe
if [ ! -f "$FLUTTER_PATH" ]; then
    echo "❌ Error: Flutter no encontrado en $FLUTTER_PATH"
    exit 1
fi

# Ir al directorio del proyecto
cd /Users/user284318/Desktop/boop

# Listar dispositivos disponibles
echo ""
echo "📱 Dispositivos disponibles:"
$FLUTTER_PATH devices

# Preguntar si desea continuar
echo ""
echo "¿Deseas ejecutar la app en el simulador? (s/n)"
read -r respuesta

if [ "$respuesta" = "s" ] || [ "$respuesta" = "S" ]; then
    echo ""
    echo "⚙️  Instalando dependencias..."
    $FLUTTER_PATH pub get
    
    echo ""
    echo "🏗️  Compilando y ejecutando en el simulador iOS..."
    $FLUTTER_PATH run -d ios
else
    echo "❌ Ejecución cancelada"
fi


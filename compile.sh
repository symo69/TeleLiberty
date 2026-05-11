#!/bin/bash

# Script para compilar el APK de Telegram sin grupos ni canales
# Ejecutar desde /workspaces/TeleLiberty

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Compilando Telegram Fork - Sin Grupos ni Canales        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📍 Directorio: $(pwd)"
echo "📦 Módulo: TMessagesProj_App"
echo ""

# Paso 0: Asegurar Java 17
for candidate in \
    /usr/lib/jvm/java-17-openjdk-amd64 \
    /usr/lib/jvm/temurin-17-jdk-amd64 \
    /usr/lib/jvm/temurin-17-jdk \
    /usr/lib/jvm/java-17-temurin \
    /opt/java/17 \
    /opt/jdk-17; do
    if [ -x "$candidate/bin/java" ]; then
        export JAVA_HOME="$candidate"
        export PATH="$JAVA_HOME/bin:$PATH"
        break
    fi
done

if ! java -version >/dev/null 2>&1; then
    echo "❌ No se encontró Java 17 en este entorno."
    exit 1
fi

# Paso 1: Preparar gradle
echo "🔧 Preparando Gradle..."
chmod +x gradlew

# Paso 2: Limpiar compilaciones previas (opcional)
echo "🧹 Limpiando compilaciones previas..."
./gradlew clean --parallel --daemon --no-daemon

# Paso 3: Compilar el APK
echo ""
echo "⏳ Compilando APK (esto puede tomar 15-30 minutos)..."
echo ""

./gradlew :TMessagesProj_App:assembleRelease \
    -x test \
    --parallel \
    --no-daemon \
    --info

# Paso 4: Verificar resultado
echo ""
echo "✅ Compilación completada!"
echo ""

if [ -f "TMessagesProj_App/build/outputs/apk/release/TMessagesProj_App-release.apk" ]; then
    echo "📦 APK generado exitosamente:"
    ls -lh TMessagesProj_App/build/outputs/apk/release/TMessagesProj_App-release.apk
    echo ""
    echo "📥 Para instalar en tu dispositivo:"
    echo "   adb install TMessagesProj_App/build/outputs/apk/release/TMessagesProj_App-release.apk"
    echo ""
    echo "✨ El apk está listo para compartir o instalar"
else
    echo "❌ Error: No se encontró el APK generado"
    echo "   Revisa los logs anteriores para más detalles"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ¡Compilación exitosa!                                    ║"
echo "╚════════════════════════════════════════════════════════════╝"

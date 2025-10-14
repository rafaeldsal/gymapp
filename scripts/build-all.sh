#!/bin/bash
# scripts/build-all.sh

echo "🏗️  Construindo TODAS as aplicações do GymApp..."

# 1. Backend - Spring Boot
echo "🔨 Construindo API Spring Boot..."
cd apps/api
./gradlew clean build -x test
if [ $? -ne 0 ]; then
    echo "❌ Falha ao construir API"
    exit 1
fi

# 2. Frontend - Angular
echo "🔨 Construindo Angular Web Admin..."
cd ../web-admin
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Falha ao construir Web Admin"
    exit 1
fi

# 3. Mobile - Android (quando tiver)
echo "🔨 Construindo Android App..."
cd ../mobile-android
./gradlew assembleDebug
if [ $? -ne 0 ]; then
    echo "❌ Falha ao construir Android App"
    exit 1
fi

echo ""
echo "✅ TODAS as construções completadas com sucesso!"
echo "📦 Artefatos gerados:"
echo "   - API: apps/api/build/libs/*.jar"
echo "   - Web: apps/web-admin/dist/"
echo "   - Android: apps/mobile-android/app/build/outputs/apk/"
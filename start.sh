#!/bin/bash

# 🚀 CRM System - Полный запуск системы
echo "🚀 Полный запуск CRM системы..."

# Проверяем наличие Docker и Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker Desktop."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен. Установите Docker Compose."
    exit 1
fi

# Проверяем, запущен ли Docker
if ! docker info &> /dev/null; then
    echo "❌ Docker не запущен. Запустите Docker Desktop."
    exit 1
fi

echo "✅ Docker и Docker Compose готовы"

# Проверяем наличие SSL сертификатов
if [ ! -d "ssl" ] || [ ! -f "ssl/admin.stage.seniorpomidornaya.ru.crt" ]; then
    echo "🔐 SSL сертификаты не найдены. Генерируем..."
    chmod +x generate-ssl.sh
    ./generate-ssl.sh
fi

# Устанавливаем зависимости если нужно
if [ ! -d "frontend/node_modules" ]; then
    echo "📦 Устанавливаем зависимости frontend..."
    cd frontend && npm install && cd ..
fi

if [ ! -d "backend/node_modules" ]; then
    echo "📦 Устанавливаем зависимости backend..."
    cd backend && npm install && cd ..
fi

# Останавливаем существующие контейнеры
echo "⏹️  Останавливаем существующие контейнеры..."
docker-compose down

# Очищаем старые образы (опционально)
echo "🧹 Очищаем старые образы..."
docker system prune -f

# Запускаем все сервисы
echo "🚀 Запускаем все сервисы..."
docker-compose up --build -d

# Ждем запуска
echo "⏳ Ждем запуска сервисов..."
sleep 30

# Проверяем статус
echo "📊 Статус сервисов:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ Система полностью запущена!"
echo "📱 Доступные URL:"
echo "   Основное приложение: https://admin.stage.seniorpomidornaya.ru"
echo "   Grafana:            https://grafana.stage.seniorpomidornaya.ru"
echo "   Kafka UI:           https://kafka-ui.stage.seniorpomidornaya.ru"
echo ""
echo "🔐 Учетные данные:"
echo "   Email:        admin@crm.local"
echo "   Пароль:       admin123"
echo ""
echo "📊 Grafana:"
echo "   Логин:        admin"
echo "   Пароль:       admin123"
echo ""
echo "🔧 Полезные команды:"
echo "   Логи:         docker-compose logs -f"
echo "   Остановить:   docker-compose down"
echo "   Перезапустить: ./restart.sh"
echo "   SSL сертификаты: ./generate-ssl.sh"

#!/bin/bash

# 🚀 CRM System - Быстрый перезапуск
echo "🔄 Перезапуск CRM системы..."

# Останавливаем контейнеры
echo "⏹️  Останавливаем контейнеры..."
docker-compose down

# Очищаем кэш Docker
echo "🧹 Очищаем Docker кэш..."
docker system prune -f

# Запускаем заново
echo "🚀 Запускаем систему..."
docker-compose up --build -d

# Ждем запуска
echo "⏳ Ждем запуска сервисов..."
sleep 20

# Проверяем статус
echo "📊 Статус сервисов:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ Система перезапущена!"
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
echo "   Полный запуск: ./start.sh"
echo "   SSL сертификаты: ./generate-ssl.sh"

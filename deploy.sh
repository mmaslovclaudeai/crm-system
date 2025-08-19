#!/bin/bash

# 🚀 CRM System - Деплой на сервер
echo "🚀 Деплой CRM системы на сервер..."

# Проверяем наличие необходимых файлов
if [ ! -f ".env" ]; then
    echo "❌ Файл .env не найден!"
    echo "📝 Скопируйте env.example в .env и настройте переменные:"
    echo "   cp env.example .env"
    echo "   nano .env"
    exit 1
fi

# Проверяем наличие SSL сертификатов
if [ ! -d "ssl" ] || [ ! -f "ssl/admin.stage.seniorpomidornaya.ru.crt" ]; then
    echo "🔐 Генерируем SSL сертификаты..."
    chmod +x generate-ssl.sh
    ./generate-ssl.sh
fi

# Проверяем права на выполнение скриптов
chmod +x start.sh
chmod +x restart.sh

# Останавливаем существующие контейнеры
echo "⏹️  Останавливаем существующие контейнеры..."
docker-compose down

# Очищаем старые образы и контейнеры
echo "🧹 Очищаем старые образы и контейнеры..."
docker system prune -f
docker volume prune -f

# Запускаем полный деплой
echo "🚀 Запускаем полный деплой..."
./start.sh

# Проверяем статус после деплоя
echo "📊 Проверяем статус после деплоя..."
sleep 10

# Проверяем доступность сервисов
echo "🔍 Проверяем доступность сервисов..."

# Проверяем Nginx
if curl -k -s -o /dev/null -w "%{http_code}" https://admin.stage.seniorpomidornaya.ru | grep -q "200\|301\|302"; then
    echo "✅ Nginx работает"
else
    echo "❌ Nginx недоступен"
fi

# Проверяем Backend
if curl -k -s -o /dev/null -w "%{http_code}" https://admin.stage.seniorpomidornaya.ru/api/health | grep -q "200"; then
    echo "✅ Backend API работает"
else
    echo "❌ Backend API недоступен"
fi

# Проверяем Grafana
if curl -k -s -o /dev/null -w "%{http_code}" https://grafana.stage.seniorpomidornaya.ru | grep -q "200\|301\|302"; then
    echo "✅ Grafana работает"
else
    echo "❌ Grafana недоступна"
fi

# Проверяем Kafka UI
if curl -k -s -o /dev/null -w "%{http_code}" https://kafka-ui.stage.seniorpomidornaya.ru | grep -q "200\|301\|302"; then
    echo "✅ Kafka UI работает"
else
    echo "❌ Kafka UI недоступен"
fi

echo ""
echo "🎉 Деплой завершен!"
echo ""
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
echo ""
echo "⚠️  ВНИМАНИЕ:"
echo "   - Установите корневой сертификат ssl/ca.crt в браузер"
echo "   - Настройте DNS записи для доменов"
echo "   - Для продакшена используйте Let's Encrypt сертификаты"

# 🚀 Деплой CRM системы на сервер

## 📋 Требования

- Docker и Docker Compose
- Открытые порты 80 и 443
- Настроенные DNS записи для доменов
- Доступ к серверу с правами sudo

## 🌐 Домены

Система настроена для работы со следующими доменами:
- **Основное приложение**: https://admin.stage.seniorpomidornaya.ru
- **Grafana**: https://grafana.stage.seniorpomidornaya.ru
- **Kafka UI**: https://kafka-ui.stage.seniorpomidornaya.ru

## 🔧 Подготовка к деплою

### 1. Настройка переменных окружения

```bash
# Копируем пример файла переменных
cp env.example .env

# Редактируем переменные
nano .env
```

**Важные переменные для изменения:**
- `DB_PASSWORD` - пароль для базы данных
- `JWT_SECRET` - секретный ключ для JWT токенов
- `TELEGRAM_BOT_TOKEN` - токен Telegram бота
- `TELEGRAM_CHAT_ID` - ID чата для уведомлений

### 2. Настройка DNS

Добавьте A записи в DNS для всех доменов, указывающие на IP вашего сервера:

```
admin.stage.seniorpomidornaya.ru    A    YOUR_SERVER_IP
grafana.stage.seniorpomidornaya.ru  A    YOUR_SERVER_IP
kafka-ui.stage.seniorpomidornaya.ru A    YOUR_SERVER_IP
```

## 🚀 Деплой

### Быстрый деплой

```bash
# Делаем скрипты исполняемыми
chmod +x *.sh

# Запускаем полный деплой
./deploy.sh
```

### Пошаговый деплой

```bash
# 1. Генерируем SSL сертификаты
./generate-ssl.sh

# 2. Запускаем систему
./start.sh

# 3. Проверяем статус
docker ps
```

## 📊 Проверка работы

После деплоя проверьте доступность сервисов:

```bash
# Основное приложение
curl -k https://admin.stage.seniorpomidornaya.ru

# Backend API
curl -k https://admin.stage.seniorpomidornaya.ru/api/health

# Grafana
curl -k https://grafana.stage.seniorpomidornaya.ru

# Kafka UI
curl -k https://kafka-ui.stage.seniorpomidornaya.ru
```

## 🔐 SSL сертификаты

### Самоподписанные сертификаты (для разработки)

Система автоматически генерирует самоподписанные сертификаты. Для работы в браузере:

1. Скопируйте файл `ssl/ca.crt` на ваш компьютер
2. Установите его как доверенный корневой сертификат:
   - **Chrome/Edge**: Настройки → Безопасность → Сертификаты → Центры сертификации
   - **Firefox**: Настройки → Приватность и защита → Сертификаты → Просмотр сертификатов

### Let's Encrypt сертификаты (для продакшена)

Для продакшена рекомендуется использовать Let's Encrypt:

```bash
# Установка certbot
sudo apt install certbot

# Получение сертификатов
sudo certbot certonly --standalone -d admin.stage.seniorpomidornaya.ru
sudo certbot certonly --standalone -d grafana.stage.seniorpomidornaya.ru
sudo certbot certonly --standalone -d kafka-ui.stage.seniorpomidornaya.ru

# Копирование сертификатов
sudo cp /etc/letsencrypt/live/admin.stage.seniorpomidornaya.ru/fullchain.pem ssl/
sudo cp /etc/letsencrypt/live/admin.stage.seniorpomidornaya.ru/privkey.pem ssl/
# Повторить для других доменов
```

## 🔧 Управление системой

### Полезные команды

```bash
# Просмотр логов
docker-compose logs -f

# Просмотр логов конкретного сервиса
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f nginx

# Остановка системы
docker-compose down

# Перезапуск системы
./restart.sh

# Полный перезапуск
./start.sh

# Просмотр статуса контейнеров
docker ps

# Просмотр использования ресурсов
docker stats
```

### Обновление системы

```bash
# Остановка
docker-compose down

# Обновление кода
git pull origin stage

# Перезапуск
./start.sh
```

## 📊 Мониторинг

### Grafana

- **URL**: https://grafana.stage.seniorpomidornaya.ru
- **Логин**: admin
- **Пароль**: admin123

### Kafka UI

- **URL**: https://kafka-ui.stage.seniorpomidornaya.ru
- Доступен для мониторинга Kafka топиков и сообщений

## 🔐 Учетные данные

### CRM система
- **Email**: admin@crm.local
- **Пароль**: admin123

### Grafana
- **Логин**: admin
- **Пароль**: admin123

## 🚨 Устранение неполадок

### Проблемы с SSL

```bash
# Проверка сертификатов
openssl x509 -in ssl/admin.stage.seniorpomidornaya.ru.crt -text -noout

# Пересоздание сертификатов
rm -rf ssl/
./generate-ssl.sh
```

### Проблемы с контейнерами

```bash
# Проверка логов
docker-compose logs -f

# Пересборка образов
docker-compose build --no-cache

# Очистка Docker
docker system prune -a
```

### Проблемы с сетью

```bash
# Проверка портов
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# Проверка firewall
sudo ufw status
```

## 📝 Логи

Логи системы находятся в следующих местах:

- **Nginx**: `docker-compose logs nginx`
- **Backend**: `docker-compose logs backend`
- **Frontend**: `docker-compose logs frontend`
- **Grafana**: `docker-compose logs grafana`
- **Kafka**: `docker-compose logs kafka`

## 🔄 Автоматическое обновление

Для автоматического обновления сертификатов Let's Encrypt добавьте в crontab:

```bash
# Редактирование crontab
crontab -e

# Добавление задачи (обновление каждые 12 часов)
0 */12 * * * /usr/bin/certbot renew --quiet && docker-compose restart nginx
```

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи: `docker-compose logs -f`
2. Проверьте статус контейнеров: `docker ps`
3. Проверьте доступность сервисов: `curl -k https://admin.stage.seniorpomidornaya.ru`
4. Обратитесь к документации или создайте issue в репозитории

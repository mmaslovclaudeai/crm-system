# 🚀 Быстрый деплой CRM системы

## ⚡ Быстрый старт (5 минут)

### 1. Подготовка
```bash
# Клонируем репозиторий (если еще не сделано)
git clone <repository-url>
cd crm-system
git checkout stage

# Делаем скрипты исполняемыми
chmod +x *.sh
```

### 2. Настройка переменных
```bash
# Копируем и настраиваем переменные окружения
cp env.example .env
nano .env  # Измените пароли и токены
```

### 3. Деплой
```bash
# Запускаем полный деплой
./deploy.sh
```

## 🌐 Доступные URL

После успешного деплоя система будет доступна по адресам:

- **CRM система**: https://admin.stage.seniorpomidornaya.ru
- **Grafana**: https://grafana.stage.seniorpomidornaya.ru  
- **Kafka UI**: https://kafka-ui.stage.seniorpomidornaya.ru

## 🔐 Учетные данные

- **CRM**: admin@crm.local / admin123
- **Grafana**: admin / admin123

## ⚠️ Важно

1. **DNS**: Настройте A записи для всех доменов
2. **SSL**: Установите `ssl/ca.crt` в браузер для самоподписанных сертификатов
3. **Порты**: Откройте порты 80 и 443 на сервере

## 🔧 Управление

```bash
# Перезапуск
./restart.sh

# Остановка
docker-compose down

# Логи
docker-compose logs -f

# Статус
docker ps
```

## 📞 Поддержка

При проблемах проверьте:
1. `docker ps` - статус контейнеров
2. `docker-compose logs -f` - логи
3. `curl -k https://admin.stage.seniorpomidornaya.ru` - доступность

Подробная документация: [DEPLOYMENT.md](DEPLOYMENT.md)

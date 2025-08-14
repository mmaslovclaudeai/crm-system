# 📊 Система логирования CRM

## 🚀 Быстрый старт

### Доступ к Grafana
- **URL**: http://localhost:3001
- **Логин**: `admin`
- **Пароль**: `stage-una-crm-ru-2024`

### Доступ к Loki API
- **URL**: http://localhost:3100

## 📋 Что настроено

### 1. **Loki** - Агрегатор логов
- Собирает логи со всех контейнеров
- Хранит логи в файловой системе
- Retention: 31 день (настраивается в `config/loki/local-config.yaml`)

### 2. **Promtail** - Сборщик логов
- Автоматически собирает логи Docker контейнеров
- Парсит JSON логи
- Добавляет метаданные (container_name, image_name, etc.)

### 3. **Grafana** - Визуализация
- Дашборд "CRM System Logs" с панелями:
  - Все логи CRM системы
  - Ошибки (содержащие "error")
  - HTTP ошибки (400, 401, 403, 404, 500)

## 🔍 Полезные запросы в Grafana Explore

### Базовые фильтры:
```logql
# Все логи
{namespace="stage-una-crm-ru"}

# Только ошибки
{namespace="stage-una-crm-ru"} |= "error"

# HTTP ошибки
{namespace="stage-una-crm-ru"} |= "400" | "401" | "403" | "404" | "500"

# Логи конкретного контейнера
{container_name="crm_backend"}

# Логи по уровню
{level="error"}
```

### Поиск по тексту:
```logql
# Поиск по сообщению
{namespace="stage-una-crm-ru"} |= "database connection"

# Исключение
{namespace="stage-una-crm-ru"} != "debug"

# Регулярные выражения
{namespace="stage-una-crm-ru"} |~ ".*error.*"
```

### Временные фильтры:
```logql
# Последние 5 минут
{namespace="stage-una-crm-ru"} [5m]

# Последний час
{namespace="stage-una-crm-ru"} [1h]
```

## 🛠️ Управление

### Запуск/остановка:
```bash
# Запустить только логирование
docker-compose up -d loki grafana promtail

# Остановить логирование
docker-compose stop loki grafana promtail

# Перезапустить
docker-compose restart loki grafana promtail
```

### Просмотр логов:
```bash
# Логи Loki
docker-compose logs loki

# Логи Promtail
docker-compose logs promtail

# Логи Grafana
docker-compose logs grafana
```

### Очистка данных:
```bash
# Удалить все данные логов
docker-compose down
docker volume rm crm-system-dev_loki_data
docker volume rm crm-system-dev_grafana_data
```

## 📁 Структура файлов

```
config/
├── loki/
│   └── local-config.yaml      # Конфигурация Loki
├── promtail/
│   └── config.yml             # Конфигурация Promtail
└── grafana/
    └── provisioning/
        ├── datasources/
        │   └── loki.yml       # Datasource Loki
        └── dashboards/
            ├── dashboard.yml  # Конфигурация дашбордов
            └── crm-logs.json  # Дашборд CRM
```

## 🔧 Настройка retention

В `config/loki/local-config.yaml`:
```yaml
limits_config:
  retention_period: 744h  # 31 день
```

## 🚨 Мониторинг

### Проверка здоровья:
```bash
# Loki
curl http://localhost:3100/ready

# Grafana
curl http://localhost:3001/api/health
```

### Метрики:
- **Loki**: http://localhost:3100/metrics
- **Promtail**: http://localhost:9080/metrics

## 📝 Следующие шаги

1. **Улучшение логирования в приложениях**:
   - Добавить структурированные JSON логи в backend
   - Настроить логирование ошибок в frontend
   - Добавить логирование в telegram bot

2. **Алерты**:
   - Настроить алерты на критические ошибки
   - Интеграция с Telegram/Slack

3. **Метрики**:
   - Добавить Prometheus для метрик
   - Создать дашборды с графиками

4. **Безопасность**:
   - Настроить аутентификацию для Grafana
   - Ограничить доступ к логам

# 🏢 CRM System - Система управления клиентами

Полноценная CRM система с современной архитектурой, включающая backend API, frontend интерфейс, систему логирования и мониторинга.

## 🚀 Быстрый старт

### Запуск всех сервисов
```bash
docker-compose up -d
```

### Доступ к приложениям
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Grafana**: http://localhost:3001 (admin/stage-una-crm-ru-2024)
- **Kafka UI**: http://localhost:8080

## 📊 Система логирования и мониторинга

### Grafana + Loki + Promtail
- **Централизованное логирование** всех сервисов
- **Структурированные JSON логи** с метаданными
- **TraceID** для связывания связанных логов
- **Дашборды** для мониторинга и анализа

### 🔍 Поиск по TraceID
Каждый HTTP запрос получает уникальный TraceID, который связывает все связанные логи:

```logql
# Поиск всех логов одного запроса
{container_name="crm_backend"} | json | traceId="trace-1755102560119-r746q7g82"

# Поиск ошибок с TraceID
{container_name="crm_backend"} | json | level="error" | traceId != ""
```

Подробное руководство: [TRACEID_GUIDE.md](./TRACEID_GUIDE.md)

## 🏗️ Архитектура

### Backend (Node.js + Express)
- **REST API** с JWT аутентификацией
- **PostgreSQL** для хранения данных
- **Kafka** для асинхронных сообщений
- **Winston** для структурированного логирования
- **Swagger** для документации API

### Frontend (React + Vite)
- **Современный UI** с Tailwind CSS
- **Компонентная архитектура**
- **Реактивные формы** с валидацией
- **Интерактивные таблицы** и дашборды

### Инфраструктура
- **Docker Compose** для оркестрации
- **PostgreSQL** как основная БД
- **Kafka** для событийной архитектуры
- **Loki + Grafana** для логирования и мониторинга

## 📋 Основные функции

### Управление клиентами
- ✅ Создание, редактирование, удаление клиентов
- ✅ Поиск и фильтрация
- ✅ Статусы и этапы работы
- ✅ Привязка к кураторам
- ✅ Документы и контакты

### Финансовый учет
- ✅ Планируемые и фактические платежи
- ✅ Аналитика и отчеты
- ✅ Интеграция с кассами
- ✅ Экспорт данных

### Управление персоналом
- ✅ Сотрудники и роли
- ✅ Кураторы клиентов
- ✅ Статистика по работникам

### Система уведомлений
- ✅ Telegram бот
- ✅ Kafka события
- ✅ WebSocket уведомления

## 🔧 Разработка

### Структура проекта
```
├── backend/           # Node.js API
├── frontend/          # React приложение
├── services/          # Дополнительные сервисы
├── config/           # Конфигурации Grafana/Loki
├── docker-compose.yml
└── README.md
```

### Переменные окружения
```bash
# Backend
NODE_ENV=development
JWT_SECRET=your-secret-key
DB_HOST=postgres
DB_NAME=crm_dev
DB_USER=crm_user
DB_PASSWORD=crm_password

# Grafana
GRAFANA_PASSWORD=stage-una-crm-ru-2024
```

### Команды разработки
```bash
# Запуск только backend
docker-compose up -d backend postgres kafka

# Пересборка backend
docker-compose build --no-cache backend

# Просмотр логов
docker-compose logs -f backend

# Остановка всех сервисов
docker-compose down
```

## 📚 Документация

- [LOGGING.md](./LOGGING.md) - Система логирования
- [TRACEID_GUIDE.md](./TRACEID_GUIDE.md) - Поиск по TraceID
- [DEVELOPMENT.md](./DEVELOPMENT.md) - Руководство разработчика

## 🔍 Мониторинг и отладка

### Grafana дашборды
1. **CRM System Logs** - основные логи системы
2. **Панели для анализа**:
   - Все логи CRM системы
   - Ошибки
   - HTTP ошибки
   - Логи с TraceID

### Полезные запросы в Grafana
```logql
# Все логи в namespace
{namespace="stage-una-crm-ru"}

# Ошибки аутентификации
{namespace="stage-una-crm-ru"} | json | action="authentication" | status="failed"

# Медленные запросы
{namespace="stage-una-crm-ru"} | json | responseTime=~".*[5-9][0-9][0-9]ms.*"

# Поиск по TraceID
{namespace="stage-una-crm-ru"} | json | traceId="YOUR_TRACE_ID"
```

## 🚨 Устранение неполадок

### Проблемы с логированием
1. Проверьте статус контейнеров: `docker-compose ps`
2. Проверьте логи Loki: `docker-compose logs loki`
3. Проверьте логи Promtail: `docker-compose logs promtail`

### Проблемы с базой данных
1. Проверьте подключение: `docker-compose logs postgres`
2. Проверьте миграции: `docker exec crm_postgres psql -U crm_user -d crm_dev -c "\dt"`

### Проблемы с Kafka
1. Проверьте статус: `docker-compose logs kafka`
2. Проверьте топики: http://localhost:8080

## 📈 Производительность

### Мониторинг
- **Grafana** для визуализации метрик
- **Loki** для быстрого поиска логов
- **TraceID** для связывания связанных событий

### Оптимизация
- **Индексы** в PostgreSQL
- **Кэширование** на уровне приложения
- **Пагинация** для больших списков
- **Асинхронная обработка** через Kafka

## 🔐 Безопасность

- **JWT токены** для аутентификации
- **Ролевая модель** доступа
- **Валидация** всех входных данных
- **Rate limiting** для защиты от атак
- **CORS** настройки

## 📞 Поддержка

Для вопросов и проблем:
1. Проверьте логи в Grafana
2. Используйте TraceID для поиска связанных событий
3. Обратитесь к документации в папке проекта

---

**Версия**: 1.0.0  
**Последнее обновление**: Август 2024 

#!/bin/bash

# 🔐 CRM System - Генерация SSL сертификатов
echo "🔐 Генерация SSL сертификатов для CRM системы..."

# Создаем директорию для сертификатов
mkdir -p ssl

# Домены для которых нужны сертификаты
DOMAINS=(
    "admin.stage.seniorpomidornaya.ru"
    "grafana.stage.seniorpomidornaya.ru"
    "kafka-ui.stage.seniorpomidornaya.ru"
)

# Генерируем корневой CA сертификат
echo "📜 Генерируем корневой CA сертификат..."
openssl genrsa -out ssl/ca.key 4096
openssl req -new -x509 -days 3650 -key ssl/ca.key -out ssl/ca.crt -subj "/C=RU/ST=Moscow/L=Moscow/O=SeniorPomidornaya/OU=IT/CN=SeniorPomidornaya Root CA"

# Генерируем сертификаты для каждого домена
for domain in "${DOMAINS[@]}"; do
    echo "🔐 Генерируем сертификат для $domain..."
    
    # Создаем приватный ключ
    openssl genrsa -out ssl/${domain}.key 2048
    
    # Создаем конфигурационный файл для сертификата
    cat > ssl/${domain}.conf << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = RU
ST = Moscow
L = Moscow
O = SeniorPomidornaya
OU = IT
CN = ${domain}

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${domain}
DNS.2 = *.${domain}
EOF
    
    # Генерируем CSR
    openssl req -new -key ssl/${domain}.key -out ssl/${domain}.csr -config ssl/${domain}.conf
    
    # Подписываем сертификат
    openssl x509 -req -in ssl/${domain}.csr -CA ssl/ca.crt -CAkey ssl/ca.key -CAcreateserial -out ssl/${domain}.crt -days 365 -extensions v3_req -extfile ssl/${domain}.conf
    
    # Создаем полную цепочку сертификатов
    cat ssl/${domain}.crt ssl/ca.crt > ssl/${domain}.fullchain.crt
    
    # Удаляем временные файлы
    rm ssl/${domain}.csr ssl/${domain}.conf
done

# Устанавливаем правильные права доступа
chmod 600 ssl/*.key
chmod 644 ssl/*.crt

echo "✅ SSL сертификаты сгенерированы!"
echo "📁 Сертификаты находятся в директории ssl/"
echo ""
echo "📋 Список созданных файлов:"
ls -la ssl/

echo ""
echo "🔧 Для установки корневого сертификата в браузер:"
echo "   - Скопируйте файл ssl/ca.crt"
echo "   - Установите его как доверенный корневой сертификат"
echo ""
echo "⚠️  ВНИМАНИЕ: Это самоподписанные сертификаты для разработки!"
echo "   Для продакшена используйте Let's Encrypt или другие CA."

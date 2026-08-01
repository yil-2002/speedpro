# 🚀 DEPLOYMENT GUIDE

## 1. Подготовка сервера (Ubuntu 22.04)

```bash
ssh root@YOUR_SERVER_IP
apt update && apt upgrade -y
apt install -y curl wget git nano htop nginx certbot python3-certbot-nginx
```

## 2. Установка Docker

```bash
curl -fsSL https://get.docker.com | sh
systemctl enable docker && systemctl start docker
```

## 3. Клонирование репозитория

```bash
cd /opt
git clone https://github.com/YOUR_USERNAME/speedpro-vpn.git
cd speedpro-vpn
cp .env.example .env
nano .env
```

Заполните `.env`:
- `BOT_TOKEN` — токен от @BotFather
- `ADMIN_IDS` — ваш Telegram ID
- `SECRET_KEY` — пароль 32+ символов
- `XRAY_PANEL_URL` — URL панели 3X-UI
- `XRAY_PANEL_PASSWORD` — пароль от панели

## 4. Установка 3X-UI (Xray)

```bash
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
```

- Панель: `https://IP:2053`
- Логин: `admin`
- **Сразу смените пароль!**

Настройте VLESS + REALITY inbound в панели и скопируйте Public Key, Short ID в `.env`.

## 5. Запуск Docker

```bash
docker compose build
docker compose up -d
docker compose ps
```

## 6. Миграция базы данных

```bash
docker compose exec api alembic upgrade head
docker compose exec db psql -U vpnuser -d vpnbot -c "\dt"
```

## 7. Nginx + SSL

```bash
certbot --nginx -d your-domain.com
certbot renew --dry-run
```

Конфиг Nginx (`/etc/nginx/sites-available/speedpro`):

```nginx
upstream api {
    server localhost:8000;
}

upstream mini_app {
    server localhost:3000;
}

server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    location /api/ {
        proxy_pass http://api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location / {
        proxy_pass http://mini_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

```bash
ln -s /etc/nginx/sites-available/speedpro /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

## 8. Настройка бота в @BotFather

```
/setmenubutton
@your_bot_username
Личный кабинет
https://your-domain.com
```

## 9. Cron задачи

```bash
crontab -e
```

```
# Синхронизация трафика каждый час
0 * * * * cd /opt/speedpro-vpn && docker compose exec -T api python scripts/traffic_sync.py

# Проверка истёкших подписок каждый день в 00:00
0 0 * * * cd /opt/speedpro-vpn && docker compose exec -T api python scripts/check_expiry.py

# Speed test каждые 6 часов
0 */6 * * * cd /opt/speedpro-vpn && docker compose exec -T api python scripts/speed_test.py

# Бэкап базы каждый день в 01:00
0 1 * * * cd /opt/speedpro-vpn && bash scripts/backup_db.sh
```

## 10. Полезные команды

```bash
# Логи
docker compose logs -f api
docker compose logs -f bot
docker compose logs -f db

# Перезапуск
docker compose restart

# Вход в контейнер
docker compose exec api bash
docker compose exec db psql -U vpnuser -d vpnbot

# Остановка
docker compose down

# Полная очистка
docker compose down -v
rm -rf pgdata/

# Обновление
git pull origin main
docker compose build
docker compose up -d
docker compose exec api alembic upgrade head
```

## 11. Бэкап и восстановление

```bash
# Бэкап
docker compose exec db pg_dump -U vpnuser -d vpnbot > backup.sql

# Восстановление
docker compose exec -T db psql -U vpnuser -d vpnbot < backup.sql
```

## 12. Firewall

```bash
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

## ⚠️ Troubleshooting

| Проблема | Решение |
|----------|---------|
| Порт занят | `lsof -i :8000` — найти и остановить процесс |
| Ошибка БД | `docker compose restart db` |
| Сертификат истёк | `certbot renew --force-renewal` |
| Бот не отвечает | `docker compose logs -f bot` |

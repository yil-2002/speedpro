# 📚 SpeedPRO VPN API

**Base URL:** `http://localhost:8000/api/v1`

**Auth:** `Authorization: Bearer {token}`

---

## 🔐 Auth

### POST `/auth/telegram`
Авторизация через Telegram WebApp `initData`

**Request:**
```json
{
  "init_data": "user=%7B%22id%22...",
  "referral_code": null
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGc...",
    "token_type": "bearer"
  }
}
```

---

## 👤 Users

### GET `/me`
Текущий пользователь

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 123456789,
    "username": "user",
    "first_name": "Name",
    "balance_rub": 1500.50,
    "balance_stars": 100,
    "referral_code": "ref123"
  }
}
```

### GET `/me/subscription`
Активная подписка

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "status": "active",
      "plan_type": "1month",
      "devices_count": 2,
      "expires_at": "2024-02-01T12:00:00",
      "config_link": "vless://uuid@domain:443?..."
    }
  ]
}
```

---

## 💳 Tariffs & Subscriptions

### GET `/tariffs`
Все тарифы

**Response:**
```json
{
  "success": true,
  "data": [
    {"plan_type": "1day", "title_ru": "1 день", "duration_days": 1, "price_rub": 39, "price_stars": 29},
    {"plan_type": "1month", "title_ru": "1 месяц", "duration_days": 30, "price_rub": 250, "price_stars": 184}
  ]
}
```

### POST `/me/subscription`
Покупка новой подписки

**Request:**
```json
{
  "plan_type": "1month",
  "devices_count": 2,
  "payment_method": "telegram_stars"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "subscription_id": "uuid",
    "amount_rub": 300,
    "amount_stars": 221
  }
}
```

---

## ⭐ Payments

### POST `/payments/stars`
Создание invoice для оплаты Telegram Stars

**Request:**
```json
{
  "plan_type": "1month",
  "devices_count": 2
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "payment_id": "uuid",
    "invoice": {
      "title": "SpeedPRO VPN — 1 месяц",
      "description": "2 устройства",
      "payload": "{...}",
      "currency": "XTR",
      "prices": [{"label": "1 месяц", "amount": 221}]
    }
  }
}
```

### POST `/payments/stars/success`
Вебхук успешной оплаты

**Request:**
```json
{
  "payment_id": "uuid",
  "telegram_payment_charge_id": "charge_123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {"subscription_id": "uuid"}
}
```

---

## 🎁 Gifts

### POST `/gifts`
Создание подарка

**Request:**
```json
{
  "plan_type": "1month",
  "devices_count": 1,
  "payment_method": "balance"
}
```

**Response:**
```json
{"success": true, "data": {"code": "ABC123XYZ"}}
```

### POST `/gifts/redeem`
Активация кода подарка

**Request:**
```json
{"code": "ABC123XYZ"}
```

**Response:**
```json
{"success": true, "data": {"subscription_id": "uuid"}}
```

---

## 👥 Referrals

### GET `/referrals`
Реферальная статистика

**Response:**
```json
{
  "success": true,
  "data": {
    "invited_count": 5,
    "earned_rub": 1500,
    "pending_rub": 300,
    "referral_link": "https://t.me/bot?start=ref_123",
    "referral_link_web": "https://domain.com?ref=123"
  }
}
```

---

## 🛡️ VPN Config

### GET `/vpn/config`
Мои конфигурации VPN

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "subscription_id": "uuid",
      "config_link": "vless://...",
      "vless_uuid": "uuid",
      "server_address": "domain.com",
      "server_port": 443
    }
  ]
}
```

### DELETE `/vpn/config/{id}`
Удаление конфигурации

**Response:**
```json
{"success": true, "data": {"deleted": true}}
```

---

## 💬 Support

### POST `/support`
Новое обращение в поддержку

**Request:**
```json
{
  "subject": "Проблема",
  "message": "Детали"
}
```

### GET `/support`
Мои обращения

---

## ⚠️ Errors

| Код | Описание |
|-----|----------|
| 400 | Неверный запрос |
| 401 | Недействительный токен |
| 402 | Недостаточно средств |
| 404 | Не найдено |
| 500 | Ошибка сервера |

**Формат ошибки:**
```json
{"success": false, "error": "Сообщение", "data": null}
```


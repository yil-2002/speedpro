cat > README.md << 'EOF'
# 🚀 ORBIT VPN - Telegram Mini App'da VPN Sotuv Tizimi

Telegram ichida ishlaydigan to'liq VPN ekotizimi:
- 📱 Telegram Mini App
- 🤖 Telegram Bot (RUSCHA)
- ⚡ FastAPI Backend
- 🗄️ PostgreSQL Database
- 🔐 VLESS + REALITY Xray Integration
- 💳 Telegram Stars Payment
- 🎁 Referral & Gift System
- 📊 Server Monitoring

## 🛠️ Qo'rish

```bash
# 1. Clone qilish
git clone https://github.com/YOUR_USERNAME/orbit-vpn.git
cd orbit-vpn

# 2. .env sozlash
cp .env.example .env
nano .env

# 3. Docker'da ishga tushirish
docker-compose up -d

# 4. Database migrate
docker-compose exec api alembic upgrade head

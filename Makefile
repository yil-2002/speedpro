.PHONY: help build up down logs clean db-migrate db-reset test

help:
	@echo "ORBIT VPN - Makefile Commands"
	@echo "=============================="
	@echo "make build       - Docker images'ni yaratish"
	@echo "make up          - Services'ni ishga tushirish"
	@echo "make down        - Services'ni to'xtatish"
	@echo "make logs        - Loglarni ko'rish"
	@echo "make clean       - Konteyner va volumes'ni o'chirish"
	@echo "make db-migrate  - Database migration qilish"
	@echo "make db-reset    - Database'ni reset qilish"
	@echo "make test        - Tests'ni ishga tushirish"

build:
	docker-compose build

up:
	docker-compose up -d
	@echo "✅ Services ishga tushdi"

down:
	docker-compose down
	@echo "✅ Services to'xtadi"

logs:
	docker-compose logs -f

logs-api:
	docker-compose logs -f api

logs-bot:
	docker-compose logs -f bot

clean:
	docker-compose down -v
	rm -rf pgdata/
	@echo "✅ Tozalandi"

db-migrate:
	docker-compose exec api alembic upgrade head

db-reset:
	docker-compose exec api alembic downgrade base
	docker-compose exec api alembic upgrade head

test:
	docker-compose exec api pytest tests/

lint:
	docker-compose exec api flake8 app/
	docker-compose exec api black app/

format:
	docker-compose exec api black app/

shell-api:
	docker-compose exec api bash

shell-bot:
	docker-compose exec bot bash

shell-db:
	docker-compose exec db psql -U vpnuser -d vpnbot

restart:
	docker-compose restart

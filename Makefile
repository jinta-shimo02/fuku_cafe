.DEFAULT_GOAL := help

COMPOSE := docker compose

.PHONY: help
help: ## コマンド一覧
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

# ---- コンテナ ----
.PHONY: build up down restart ps logs
build: ## イメージをビルド
	$(COMPOSE) build

up: ## 全コンテナを起動（サーバーは起動しない）
	$(COMPOSE) up -d

down: ## 全コンテナを停止
	$(COMPOSE) down

restart: down up ## 全コンテナを再起動

ps: ## コンテナの状態
	$(COMPOSE) ps

logs: ## db のログを追う
	$(COMPOSE) logs -f db

# ---- サーバー起動（フォアグラウンド・Ctrl-C で停止） ----
.PHONY: app web
app: ## Rails サーバーを起動してログを追う
	$(COMPOSE) up -d app
	$(COMPOSE) exec app bash -c "rm -f tmp/pids/server.pid && bin/rails server -b 0.0.0.0 -p 3000"

web: ## Next.js 開発サーバーを起動してログを追う
	$(COMPOSE) up -d web
	$(COMPOSE) exec web npm run dev -- -H 0.0.0.0 -p 3000

# ---- シェル / コンソール ----
.PHONY: app-sh web-sh console db-console
app-sh: ## app コンテナに入る
	$(COMPOSE) exec app bash

web-sh: ## web コンテナに入る
	$(COMPOSE) exec web bash

console: ## rails console
	$(COMPOSE) exec app bin/rails console

db-console: ## psql
	$(COMPOSE) exec app bin/rails dbconsole

# ---- セットアップ ----
.PHONY: setup bundle npm-install db-prepare
setup: build up bundle npm-install db-prepare ## 初回セットアップ

bundle: ## bundle install
	$(COMPOSE) exec app bundle install

npm-install: ## npm install
	$(COMPOSE) exec web npm install

db-prepare: ## DB 作成・マイグレーション
	$(COMPOSE) exec app bin/rails db:prepare

# ---- テスト / Lint ----
.PHONY: test lint
test: ## backend のテスト
	$(COMPOSE) exec app bin/rails test

lint: ## backend / frontend の lint
	$(COMPOSE) exec app bin/rubocop
	$(COMPOSE) exec web npm run lint

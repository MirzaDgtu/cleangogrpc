# Makefile для генерации Go кода из .proto файлов

# Переменные
PROTO_DIR = api/v1
OUTPUT_DIR = gen/go
PROTO_SOURCES = $(shell find $(PROTO_DIR) -name "*.proto")
GO_SOURCES = $(PROTO_SOURCES:$(PROTO_DIR)/%.proto=$(OUTPUT_DIR)/$(PROTO_DIR)/%.pb.go)

# Основные цели
.PHONY: all generate clean help install-deps

# По умолчанию - генерация
all: generate

# Генерация всех proto файлов
generate: create-dirs $(GO_SOURCES)
	@echo "Генерация завершена!"

# Создание структуры папок
create-dirs:
	@echo "Создание структуры папок..."
	@mkdir -p $(OUTPUT_DIR)/$(PROTO_DIR)/auth
	@mkdir -p $(OUTPUT_DIR)/$(PROTO_DIR)/user

# Правило для генерации .pb.go файлов из .proto
$(OUTPUT_DIR)/$(PROTO_DIR)/%.pb.go: $(PROTO_DIR)/%.proto
	@echo "Генерация $< -> $@"
	@protoc -I . \
		--go_out=$(OUTPUT_DIR) \
		--go_opt=paths=source_relative \
		--go-grpc_out=$(OUTPUT_DIR) \
		--go-grpc_opt=paths=source_relative \
		$<

# Генерация только auth модуля
generate-auth: create-dirs
	@echo "Генерация auth модуля..."
	@if [ -n "$$(find $(PROTO_DIR)/auth -name "*.proto" 2>/dev/null)" ]; then \
		protoc -I . \
			--go_out=$(OUTPUT_DIR) \
			--go_opt=paths=source_relative \
			--go-grpc_out=$(OUTPUT_DIR) \
			--go-grpc_opt=paths=source_relative \
			$(PROTO_DIR)/auth/*.proto; \
	else \
		echo "Нет .proto файлов в $(PROTO_DIR)/auth"; \
	fi

# Генерация только user модуля
generate-user: create-dirs
	@echo "Генерация user модуля..."
	@if [ -n "$$(find $(PROTO_DIR)/user -name "*.proto" 2>/dev/null)" ]; then \
		protoc -I . \
			--go_out=$(OUTPUT_DIR) \
			--go_opt=paths=source_relative \
			--go-grpc_out=$(OUTPUT_DIR) \
			--go-grpc_opt=paths=source_relative \
			$(PROTO_DIR)/user/*.proto; \
	else \
		echo "Нет .proto файлов в $(PROTO_DIR)/user"; \
	fi

# Очистка сгенерированных файлов
clean:
	@echo "Очистка сгенерированных файлов..."
	@rm -rf $(OUTPUT_DIR)
	@echo "Очистка завершена!"

# Установка зависимостей
install-deps:
	@echo "Установка зависимостей..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@echo "Зависимости установлены!"

# Проверка установленных инструментов
check-deps:
	@echo "Проверка установленных инструментов..."
	@which protoc > /dev/null || (echo "❌ protoc не установлен" && exit 1)
	@which protoc-gen-go > /dev/null || (echo "❌ protoc-gen-go не установлен" && exit 1)  
	@which protoc-gen-go-grpc > /dev/null || (echo "❌ protoc-gen-go-grpc не установлен" && exit 1)
	@echo "✅ Все инструменты установлены!"

# Пересоздание (очистка + генерация)
rebuild: clean generate

# Мониторинг изменений в .proto файлах (требует fswatch)
watch:
	@echo "Мониторинг изменений в .proto файлах..."
	@fswatch -o $(PROTO_DIR) | xargs -n1 -I{} make generate

# Форматирование .proto файлов (требует buf)
format:
	@echo "Форматирование .proto файлов..."
	@if command -v buf > /dev/null; then \
		buf format -w; \
	else \
		echo "buf не установлен. Установите: https://buf.build/docs/installation"; \
	fi

# Линтинг .proto файлов (требует buf)
lint:
	@echo "Линтинг .proto файлов..."
	@if command -v buf > /dev/null; then \
		buf lint; \
	else \
		echo "buf не установлен. Установите: https://buf.build/docs/installation"; \
	fi

# Показать информацию о найденных .proto файлах
info:
	@echo "Найденные .proto файлы:"
	@find $(PROTO_DIR) -name "*.proto" | sort
	@echo ""
	@echo "Целевые .pb.go файлы:"
	@echo "$(GO_SOURCES)" | tr ' ' '\n' | sort

# Справка
help:
	@echo "Доступные команды:"
	@echo "  make generate       - Генерация всех .proto файлов"
	@echo "  make generate-auth  - Генерация только auth модуля"
	@echo "  make generate-user  - Генерация только user модуля"
	@echo "  make clean          - Очистка сгенерированных файлов"
	@echo "  make rebuild        - Очистка + генерация"
	@echo "  make install-deps   - Установка зависимостей"
	@echo "  make check-deps     - Проверка установленных инструментов"
	@echo "  make format         - Форматирование .proto файлов (требует buf)"
	@echo "  make lint          - Линтинг .proto файлов (требует buf)"
	@echo "  make watch         - Мониторинг изменений (требует fswatch)"
	@echo "  make info          - Показать информацию о .proto файлах"
	@echo "  make help          - Эта справка"
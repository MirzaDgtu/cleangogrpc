# Makefile
PROTO_DIR        := api/v1/user
PROTO_FILE       := $(PROTO_DIR)/user.proto
OUT_DIR          := gen/go
PROTOC           := protoc
GO_PLUGIN        := --go_out=$(OUT_DIR)
GO_GRPC_PLUGIN   := --go-grpc_out=$(OUT_DIR)

.PHONY: proto
proto: $(OUT_DIR) ## Генерирует Go-код из .proto
	$(PROTOC) -I . $(GO_PLUGIN) $(GO_GRPC_PLUGIN) $(PROTO_FILE)

$(OUT_DIR):
	mkdir -p $@

.PHONY: clean
clean: ## Удаляет сгенерированные файлы
	rm -rf generated/

.PHONY: help
help: ## Показать доступные цели
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
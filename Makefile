# Makefile для Borland Make 5.2
PROTO_DIR = api/v1/user
PROTO_FILE = $(PROTO_DIR)/user.proto
OUT_DIR = gen/go

.proto:
    if not exist "$(OUT_DIR)" mkdir "$(OUT_DIR)"
    protoc -I . --go_out=$(OUT_DIR) --go_opt=paths=source_relative --go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative $(PROTO_FILE)

.clean:
    if exist "gen" rmdir /s /q "gen"

.help:
    @echo Доступные цели:
    @echo   proto  - Генерирует Go-код из .proto
    @echo   clean  - Удаляет сгенерированные файлы
    @echo   help   - Показать этот экран
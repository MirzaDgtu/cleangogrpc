@echo off
echo Генерация Go кода из .proto файлов...

REM Создание основной структуры папок
if not exist "gen\go" mkdir "gen\go"
if not exist "gen\go\api" mkdir "gen\go\api"
if not exist "gen\go\api\v1" mkdir "gen\go\api\v1"
if not exist "gen\go\api\v1\auth" mkdir "gen\go\api\v1\auth"
if not exist "gen\go\api\v1\user" mkdir "gen\go\api\v1\user"

REM Генерация из proto файлов в auth
if exist "api\v1\auth\*.proto" (
    echo Генерация auth файлов...
    protoc -I . --go_out=gen/go --go_opt=paths=source_relative --go-grpc_out=gen/go --go-grpc_opt=paths=source_relative api/v1/auth/*.proto
)

REM Генерация из proto файлов в user
if exist "api\v1\user\*.proto" (
    echo Генерация user файлов...
    protoc -I . --go_out=gen/go --go_opt=paths=source_relative --go-grpc_out=gen/go --go-grpc_opt=paths=source_relative api/v1/user/*.proto
)

REM Генерация из корневых proto файлов v1 (если есть)
if exist "api\v1\*.proto" (
    echo Генерация корневых v1 файлов...
    protoc -I . --go_out=gen/go --go_opt=paths=source_relative --go-grpc_out=gen/go --go-grpc_opt=paths=source_relative api/v1/*.proto
)

echo.
echo Структура папок создана:
echo gen\go\api\v1\auth\
echo gen\go\api\v1\user\
echo.
echo Генерация завершена!
pause
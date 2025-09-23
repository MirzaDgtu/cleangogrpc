@echo off
echo Генерация Go кода из .proto файлов...

if not exist "gen\go" mkdir "gen\go"

protoc -I . --go_out=gen/go --go_opt=paths=source_relative --go-grpc_out=gen/go --go-grpc_opt=paths=source_relative api/v1/user/user.proto

echo Генерация завершена!
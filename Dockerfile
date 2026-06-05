# 1. Etapa de compilación (SDK de .NET 9)
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar el archivo de proyecto y restaurar dependencias
COPY ["FlappyFoto.csproj", "./"]
RUN dotnet restore "FlappyFoto.csproj"

# Copiar el resto del código y compilar
COPY . .
RUN dotnet build "FlappyFoto.csproj" -c Release -o /app/build

# 2. Etapa de publicación
FROM build AS publish
RUN dotnet publish "FlappyFoto.csproj" -c Release -o /app/publish /p:UseAppHost=false

# 3. Etapa final de ejecución (Runtime de .NET 9)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 8080
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FlappyFoto.dll"]
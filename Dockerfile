FROM microsoft/aspnetcore:2.0-nanoserver-1709 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0-nanoserver-1709 AS build
WORKDIR /src
COPY DockerWebApp/DockerWebApp.csproj DockerWebApp/
RUN dotnet restore DockerWebApp/DockerWebApp.csproj
COPY . .
WORKDIR /src/DockerWebApp
RUN dotnet build DockerWebApp.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish DockerWebApp.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerWebApp.dll"]

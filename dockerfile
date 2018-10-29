# FROM microsoft/dotnet:sdk AS build-env
# WORKDIR /app

# # Copy csproj and restore as distinct layers
# COPY *.csproj ./
# RUN dotnet restore

# # Copy everything else and build
# COPY . ./
# RUN dotnet publish -c Release -o out

# # Build runtime image
# FROM microsoft/dotnet:aspnetcore-runtime
# WORKDIR /app
# COPY --from=build-env /app/out .
# ENTRYPOINT ["dotnet", "Testcore.dll"]

## ------>>>>


# FROM microsoft/dotnet:sdk AS build
# WORKDIR /app

# # copy csproj and restore as distinct layers
# COPY *.sln .
# COPY Testcore/*.csproj ./Testcore/
# RUN dotnet restore

# # copy everything else and build app
# COPY Testcore/. ./aspnetapp/
# WORKDIR /app/aspnetapp
# RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/aspnetapp/out ./
EXPOSE 80
ENTRYPOINT ["dotnet", "aspnetapp.dll"]

WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY *.sln ./
COPY Testcore/*.csproj ./Testcore/
RUN dotnet restore
COPY . .
WORKDIR /src/Testcore
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS production
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Testcore.dll"]
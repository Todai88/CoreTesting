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


# FROM microsoft/dotnet:aspnetcore-runtime AS runtime
# WORKDIR /app
# COPY --from=build /app/aspnetapp/out ./
# EXPOSE 80
# ENTRYPOINT ["dotnet", "aspnetapp.dll"]

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY Testcore/*.csproj ./Testcore/ 
# # TODO: Add test files
# COPY tests/*.csproj ./tests/ 
RUN dotnet restore

# copy and build everything else
COPY Testcore/. ./Testcore/ 
# COPY tests/. ./tests/
RUN dotnet build 

# COPY Testcore/. ./aspnetapp/
# WORKDIR /app/aspnetapp
# RUN dotnet publish -c Release -o out

FROM build AS publish
WORKDIR /app/Testcore
RUN dotnet publish -o out

FROM microsoft/dotnet:2.1-aspnetcore-runtime
WORKDIR /app
COPY --from=publish /app/Testcore/out ./
ENTRYPOINT ["dotnet", "Testcore.dll"]
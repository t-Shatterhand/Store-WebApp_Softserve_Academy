FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app 

# copy csproj and restore as distinct layers
COPY *.sln .
COPY Core/*.csproj ./Core/
COPY Infrastructure/*.csproj ./Infrastructure/
COPY MVC_apple_store/*.csproj ./MVC_apple_store/

RUN dotnet restore

# copy everything else and build app
COPY Core/. ./Core/
COPY Infrastructure/. ./Infrastructure/
COPY MVC_apple_store/. ./MVC_apple_store/ 

WORKDIR /app/MVC_apple_store
RUN dotnet publish -c Production -o out 

WORKDIR /app
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
# WORKDIR /app 

# COPY --from=build /app/MVC_apple_store/out ./
ENV PATH $PATH:/root/.dotnet/tools
RUN dotnet tool install -g dotnet-ef --version 6.0
RUN dotnet dev-certs https
RUN dotnet dev-certs https --trust

EXPOSE 9999
EXPOSE 9998 

CMD dotnet-ef database update --project Infrastructure -c StoreDbContext && dotnet ./MVC_apple_store/out/MVC_apple_store.dll
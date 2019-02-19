# build
FROM microsoft/dotnet:2.2-sdk as build-env

WORKDIR /generator

# restore
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
COPY generator.sln .
RUN dotnet restore generator.sln

#copy src
COPY . .

# test
RUN dotnet test tests/tests.csproj

# publish
RUN dotnet publish api/api.csproj -o /publish

# runtime
FROM microsoft/dotnet:2.2-aspnetcore-runtime
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT [ "dotnet", "api.dll" ]

FROM #TODO AS builder

WORKDIR /src
COPY src/Numbers.Api/Numbers.Api.csproj .
RUN dotnet restore

COPY src/ .
RUN dotnet publish -c Release -o /out Numbers.Api/Numbers.Api.csproj

# app image
FROM #TODO

ENTRYPOINT ["dotnet", "/app/Numbers.Api.dll"]

WORKDIR /app
COPY --from=builder /out/ .

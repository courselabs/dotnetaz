FROM ... AS builder

WORKDIR /src
COPY src/Numbers.Web/Numbers.Web.csproj .
RUN dotnet restore

COPY src/ .
RUN dotnet publish -c Release -o /out Numbers.Web/Numbers.Web.csproj

# app image
FROM ...

ENV RngApi__Url=http://numbers-api/rng

ENTRYPOINT ["dotnet", "/app/Numbers.Web.dll"]

WORKDIR /app
COPY --from=builder /out/ .
#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 6000
ENV ASPNETCORE_URLS=http://+:6000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["easyAppointment.Salon/easyAppointment.Salon.csproj", "easyAppointment.Salon/"]
RUN dotnet restore "easyAppointment.Salon/easyAppointment.Salon.csproj"
COPY . .
WORKDIR "/src/easyAppointment.Salon"
RUN dotnet build "easyAppointment.Salon.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "easyAppointment.Salon.csproj" -c Release -o /app/publish 

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY easyAppointment.Salon/dataSeedSalon.sql ./
ENTRYPOINT ["dotnet", "easyAppointment.Salon.dll"]
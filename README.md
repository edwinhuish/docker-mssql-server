## edwinhuish/mssql-server

### Features
- Remove MSSQL's 2G memory environmental requirements

### Tags
- **latest** : latest stable version.

### Environment variables
- **TZ** : Time zone *(default : UTC)*
- **ACCEPT_EULA** : Accepts the end user license agreement *(default : Y)*
- **MSSQL_PID** : Set the SQL Server edition or product key *(default : Express)*
- **MSSQL_SA_PASSWORD** : Configure the SA user password. *(default : YourStrong!Passw0rd)*
- **MSSQL_TCP_PORT** : Sets the SQL Server TCP listen port *(default : 1433)*. The custom TCP port must be mapped with the -p 1234:1234 command in this example

### Port
- **1433** : MSSQL port.

### Volumes
- **/data** : The directory where the SQL Server database data files (.mdf) and database log files (.ldf) are created.
- **/log** : The location of the errorlog files.
- **/backup** : Default backup directory location.
- **/dump** : The directory where SQL Server will deposit the memory dumps and other troubleshooting files by default.

### Setup

```
docker pull edwinhuish/mssql-server:latest

docker run -d --name mssql-server \
       -v /docker/mssql/data:/data \
       -v /docker/mssql/log:/log \
       -v /docker/mssql/backup:/backup \
       -v /docker/mssql/dump:/dump \
       -e MSSQL_SA_PASSWORD=<YourStrong!Passw0rd> \
       -e MSSQL_PID=Express \
       -e TZ=Asia/Shanghai \
       edwinhuish/mssql-server:latest
```

#### Docker-compose file

```
version: "3"

networks:
    default:

services:
  mssql-server:
    image: edwinhuish/mssql-server:latest
    container_name: mssql-server
    ports:
      - 1433:1433
    volumes:
      - /docker/mssql/data:/data
      - /docker/mssql/backup:/backup
      - /docker/mssql/log:/log
      - /docker/mssql/dump:/dump
    restart: always
    environment:
      - TZ=Asia/Shanghai
      - MSSQL_SA_PASSWORD=<YourStrong!Passw0rd>
      - MSSQL_PID=Express
    networks:
      - default
```
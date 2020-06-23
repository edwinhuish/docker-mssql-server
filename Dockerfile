FROM ubuntu:18.04

ENV TZ=UTC \
    ACCEPT_EULA=Y \
    MSSQL_PID=Express \
    MSSQL_SA_PASSWORD=YourStrong!Passw0rd \
    MSSQL_DATA_DIR=/data \
    MSSQL_LOG_DIR=/data \
    MSSQL_MASTER_DATA_FILE=/var/opt/mssql/data/master.mdf \
    MSSQL_MASTER_LOG_FILE=/var/opt/mssql/data/mastlog.ldf \
    MSSQL_BACKUP_DIR=/backup \
    MSSQL_DUMP_DIR=/dump \
    MSSQL_ERROR_LOG_FILE=/log/err.log


COPY ./unlimited-memory.py /tmp/unlimited-memory.py

RUN export DEBIAN_FRONTEND=noninteractive && \
    # 安装所需软件
    apt-get update && apt-get install -yq sudo curl apt-transport-https gnupg tzdata && \
    # 修改time zone
    rm /etc/localtime && cp "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone && \
    # 添加源
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update
    # 安装 （ 分割，避免单个 layer 不至于太大 ）
RUN apt-get install -y mssql-server
    # 去除 2G 内存限制
RUN chmod +x /tmp/unlimited-memory.py && \
    python /tmp/unlimited-memory.py && \
    chmod +x /opt/mssql/bin/sqlservr && \
    # 清除数据
    apt-get clean && \
    rm -rf /var/cache/apt/archives && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /tmp/*

VOLUME /data /backup /log /dump

EXPOSE 1433

CMD /opt/mssql/bin/sqlservr
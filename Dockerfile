From postgres:16-alpine

#set environment variables
ENV POSTGRES_DB=school_db
ENV POSTGRES_USER=school_admin
ENV POSTGRES_PASSWORD=school_pass_2024

#copy init script
COPY init.sql /docker-entrypoint-initdb.d/

#Expose postgresSQL port
EXPOSE 5432

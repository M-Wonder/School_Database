# School_Database
<<<<<<< HEAD
#Direct PostgreSQL Installation 
# Install PostgreSQL
sudo dnf install postgresql postgresql-server

# Initialize the database
sudo postgresql-setup --initdb

# Start and enable PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Switch to postgres user
sudo -i -u postgres

# Open PostgreSQL prompt
psql

# Run these commands in the PostgreSQL prompt:
CREATE DATABASE school_db;
CREATE USER school_admin WITH PASSWORD 'school_pass_2024';
GRANT ALL PRIVILEGES ON DATABASE school_db TO school_admin;
\q

# Exit postgres user
exit
# Load the init.sql file
sudo -u postgres psql -d school_db -f ~/my_projects/database/school-database/School_Database/init.sql

#Connect to Database
psql -h localhost -U school_admin -d school_db


# Standalone Installation Script For Fedora
#Create a setup script setup_postgres.sh for easy deployment:
🚀 Using the Setup Script
# Make the script executable
chmod +x setup_postgres.sh

# Run it (from the directory containing init.sql)
sudo ./setup_postgres.sh

=======
#to pull snd run on another pc
# Pull the image
docker pull mayabiwonder/school-db:latest

# Run the container
docker run -d -p 5432:5432 \
  -e POSTGRES_DB=school_db \
  -e POSTGRES_USER=school_admin \
  -e POSTGRES_PASSWORD=school_pass_2024 \
  --name school_postgres_db \
  mayabiwonder/school-db:latest
>>>>>>> 9bca8fd (docker deployment and settings)

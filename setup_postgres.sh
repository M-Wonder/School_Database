#!/bin/bash

# School Database Setup Script (Without Docker)
# For Fedora/RHEL-based systems

set -e

echo "🏫 School Database Setup Script"
echo "================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root or with sudo"
    exit 1
fi

# Install PostgreSQL
echo "📦 Installing PostgreSQL..."
dnf install -y postgresql postgresql-server

# Initialize database
echo "🔧 Initializing PostgreSQL..."
if [ ! -d "/var/lib/pgsql/data/base" ]; then
    postgresql-setup --initdb
else
    echo "Database already initialized, skipping..."
fi

# Start PostgreSQL
echo "🚀 Starting PostgreSQL service..."
systemctl start postgresql
systemctl enable postgresql

# Wait for PostgreSQL to start
sleep 3

# Create database and user
echo "👤 Creating database and user..."
sudo -u postgres psql <<EOF
-- Drop existing database and user if they exist
DROP DATABASE IF EXISTS school_db;
DROP USER IF EXISTS school_admin;

-- Create new database and user
CREATE DATABASE school_db;
CREATE USER school_admin WITH PASSWORD 'school_pass_2024';
GRANT ALL PRIVILEGES ON DATABASE school_db TO school_admin;

-- Grant schema privileges
\c school_db
GRANT ALL ON SCHEMA public TO school_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO school_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO school_admin;
EOF

# Check if init.sql exists
if [ -f "init.sql" ]; then
    echo "📊 Loading database schema and data..."
    sudo -u postgres psql -d school_db -f init.sql
    echo "✅ Database schema loaded successfully!"
else
    echo "⚠️  Warning: init.sql not found in current directory"
    echo "Please run this script from the directory containing init.sql"
fi

# Configure for remote access (optional)
read -p "🌐 Configure for remote access? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Configuring remote access..."
    
    # Backup original files
    cp /var/lib/pgsql/data/postgresql.conf /var/lib/pgsql/data/postgresql.conf.bak
    cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf.bak
    
    # Update postgresql.conf
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf
    
    # Update pg_hba.conf
    echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/data/pg_hba.conf
    
    # Open firewall
    firewall-cmd --permanent --add-service=postgresql 2>/dev/null || echo "Firewall not configured (firewalld not running)"
    firewall-cmd --reload 2>/dev/null || true
    
    # Restart PostgreSQL
    systemctl restart postgresql
    
    echo "✅ Remote access configured"
fi

echo ""
echo "✅ Setup Complete!"
echo "=================="
echo ""
echo "📋 Connection Details:"
echo "   Host: localhost (or your server IP)"
echo "   Port: 5432"
echo "   Database: school_db"
echo "   Username: school_admin"
echo "   Password: school_pass_2024"
echo ""
echo "🔌 Connect using:"
echo "   psql -h localhost -U school_admin -d school_db"
echo ""
echo "📊 Quick queries to try:"
echo "   SELECT * FROM student_performance;"
echo "   SELECT * FROM student_averages;"
echo ""
echo "🛑 To stop PostgreSQL:"
echo "   sudo systemctl stop postgresql"
echo ""
echo "🔄 To restart PostgreSQL:"
echo "   sudo systemctl restart postgresql"
echo ""

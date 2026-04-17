#!/bin/bash

# Delay if specified
if [ "$DELAY" ]; then
    sleep $DELAY
fi

# Create database tables if they don't exist
python -c "from app import app; app.app_context().push(); from models import db; db.create_all()"

# Run database migrations
flask db upgrade

for script in /home/add_*.py; do
  python "$script"
done

# Start the application
gunicorn -w 2 -b 0.0.0.0:5000 app:app
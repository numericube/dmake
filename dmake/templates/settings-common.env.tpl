# These are settings common to your whole project
# Makefile parameters
PROJECT_NAME=n3demos
MAKE_DEFAULT_SERVICE=n3demos-django
DEVELOP_COMMAND=python manage.py runserver 0.0.0.0:8000

# PG settings
POSTGRES_DB=myprojectdb
POSTGRES_USER=xxx
POSTGRES_PASSWORD=xxx
DJANGO_DB_HOST=db

# Django settings
DJANGO_STATIC_ROOT=/var/www/static
DJANGO_ADMIN_PASSWORD=xxx
DJANGO_ADMIN_USER=xxx
DJANGO_ADMIN_EMAIL=pjgrizel@numericube.com

# Debug information
DJANGO_DEBUG=
DJANGO_DB_LOG=
DJANGO_RAVEN_DSN=

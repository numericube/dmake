version: '3.4'

services:
  # myproject-nginx-bare:
  #   volumes:
  #     - ./myproject-nginx-bare/conf.d:/etc/nginx/conf.d


  myproject-front:
    build:
      target: build-stage
    # command: sleep 2147483647
    command: npm run serve
    volumes:
      # - ../myproject-vue/docker-entrypoint.sh:/usr/local/bin/docker-entrypoint.sh
      - ../myproject-vue/:/app
    env_file:
      - ./settings-common.env
      - ./settings-${DEPLOY_ENV}.env
    ports:
      - "9080:80"
      - "8080:8080"
      - "8081:8081"

  myproject-django:
    # command: gunicorn myproject.wsgi -b 0.0.0.0:8000 --reload
    command: django-admin runserver 0.0.0.0:8000
    stdin_open: true
    tty: true
    volumes:
      - ../myproject-django/docker-entrypoint.sh:/usr/local/bin/docker-entrypoint.sh
      - ../myproject-django/src:/src

  # We disable the Celery Worker in development mode
  myproject-celery-worker:
    command: sleep infinity
    stdin_open: true
    tty: true
    volumes:
      - ../myproject-django/docker-entrypoint.sh:/usr/local/bin/docker-entrypoint.sh
      - ../myproject-django/src:/src

  myproject-django-setup:
    stdin_open: true
    tty: true
    volumes:
      - ../myproject-django/docker-entrypoint.sh:/usr/local/bin/docker-entrypoint.sh
      - ../myproject-django/django-setup.sh:/usr/local/bin/django-setup.sh
      - ../myproject-django/src:/src

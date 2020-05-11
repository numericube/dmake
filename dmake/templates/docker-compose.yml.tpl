version: '3.4'

services:
  # # NGINX frontend
  # myproject-nginx-bare:
  #   build: ../myproject-nginx-bare
  #   image: ${DOCKER_REGISTRY}numericube/myproject-nginx-bare:${DEPLOY_TAG:-latest}
  #   restart: always
  #   ports:
  #     - "80:80"
  #   volumes:
  #     - htdocs:/htdocs
  #   # volumes_from:
  #   #   - web
  #   links:
  #    - myproject-django
  #   depends_on:
  #     - myproject-django

  # Vue.js frontend.
  # This is the main container of a Vue.js frontend.
  # Now there's a caveat here: putting a simple Dockerfile here won't let you build the project anyway
  # (lots of missing files). You have to build the environment from scratch by leveraging Docker's bare nacked
  # containers to install the necessary Vue.js stuff.
  # Here's how to create such a project from scratch.
  # 1/ Create a <yourproject>/myproject-vue directory
  # 2/ INSIDE THIS DIRECTORY, execute the following commands:
  #     docker run -ti --rm -v $PWD:/app -w /app node:11.5-stretch /bin/bash
  #     npm install -g @vue/cli
  #     vue create myproject-front      # Follow the instructions, unless you know more than me use NPM
  # 3/ Ctrl+D
  # Now your project is created inside <yourproject>/myproject-vue/myproject :)
  myproject-front:
    image: ${DOCKER_REGISTRY:-}numericube/myproject-vue:${DEPLOY_TAG:-latest}
    build: ../myproject-vue
    environment:
      - DEPLOY_ENV
      - DEPLOY_TAG
    env_file:
      - ./settings-common.env
      - ./settings-${DEPLOY_ENV}.env
    ports:
      - "9080:80"

  # Our PG Database
  db:
    image: postgres
    environment:
      - PGDATA=/var/lib/postgresql/data/pgdata
      - DEPLOY_ENV
      - DEPLOY_TAG
    env_file:
      - ./settings-common.env
      - ./settings-${DEPLOY_ENV}.env
    volumes:
      - pgdata:/var/lib/postgresql/data/pgdata

  # Our main Django container
  myproject-django:
    build:
      context: ../myproject-django
    image: ${DOCKER_REGISTRY:-}numericube/myproject-django:${DEPLOY_TAG:-latest}
    command: gunicorn myproject.wsgi -b 0.0.0.0:8000 --reload
    # command: dockerize -wait tcp://db:5432 -timeout 30s gunicorn myproject.wsgi -b 0.0.0.0:8000
    volumes:
      - htdocs:/htdocs
    environment:
      - DEPLOY_ENV
      - DEPLOY_TAG
    env_file:
      - ./settings-common.env
      - ./settings-${DEPLOY_ENV}.env
    ports:
      - "8000:8000"
    links:
      - db
      - rabbitmq
    depends_on:
      - db
      - rabbitmq

  rabbitmq:
    image: rabbitmq:3.7-management
    env_file:
      - ./settings-common.env
      - ./settings-${DEPLOY_ENV}.env

  # Our CELERY worker
  myproject-celery-worker:
    build:
      context: ../myproject-django
    image: ${DOCKER_REGISTRY:-}numericube/myproject-django:${DEPLOY_TAG:-latest}
    command: dockerize -wait tcp://db:5432 -wait tcp://rabbitmq:5672 -timeout 30s celery -A myproject worker -l info
    # volumes:
    #   - htdocs:/htdocs
    env_file:
      - ./settings-common.env
      - ./settings-${DEPLOY_ENV}.env
    # ports:
    #   - "8000:8000"
    links:
      - db
      - rabbitmq
    depends_on:
      - db
      - rabbitmq

  # Our Django setup worker
  myproject-django-setup:
    build:
      context: ../myproject-django
    image: ${DOCKER_REGISTRY:-}numericube/myproject-django:${DEPLOY_TAG:-latest}
    command: bash -c "django-setup.sh && sleep infinity"
    #"
    volumes:
      - htdocs:/htdocs
    env_file:
      - ./settings-common.env
      - ./settings-${DEPLOY_ENV}.env
    # ports:
    #   - "8000:8000"
    links:
      - db
      - rabbitmq
    depends_on:
      - db
      - rabbitmq

# Persistent volumes
volumes:
  # static: # This is where we put static files (ie. collectstatic)
  htdocs:     # This is where we put static files
  pgdata:     # Where PostgreSQL database is stored
  # mongodata:  # MongoDB data storage

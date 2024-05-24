ARG PYTHON_VERSION=3.11
ARG PYTHON_DISTRO=slim
ARG USER=imran
## BUILD STAGE

FROM python:${PYTHON_VERSION}-${PYTHON_DISTRO} AS build-stage
ARG USER

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TZ=America/Los_Angeles
ENV IS_DOCKER=True
ENV USER=${USER}

# Install build dependencies
RUN apt-get update && apt-get install -y \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && addgroup ${USER} \
    && useradd -m -g ${USER} ${USER} \
    && mkdir -p /wheels && chown -R ${USER}:${USER} /wheels

USER ${USER}

COPY requirements/requirements.txt requirements.txt

RUN python -m pip install --upgrade pip \
    && pip wheel --wheel-dir /wheels \
    -r requirements.txt


FROM python:${PYTHON_VERSION}-${PYTHON_DISTRO} AS run-stage
ARG USER
ENV USER=${USER}

# Install build dependencies
RUN apt-get update && apt-get install -y \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && addgroup ${USER} \
    && useradd -m -g ${USER} ${USER}

# Copy upgraded pip from build stage
COPY --from=build-stage /usr/local/bin/pip /usr/local/bin/pip
COPY --from=build-stage /usr/local/bin/pip3 /usr/local/bin/pip3
COPY --from=build-stage /wheels /wheels

USER ${USER}

RUN pip install --user --no-index --find-links=/wheels /wheels/*

WORKDIR /app

COPY ./src /app

CMD [ "python", "main.py" ]
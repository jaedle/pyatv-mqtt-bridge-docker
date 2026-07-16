# pyatv 0.18.0 crashes on Python 3.14 with "RuntimeError: There is no current
# event loop" (asyncio.get_event_loop() no longer creates a loop). Stay on
# Python 3.13 until pyatv supports 3.14.
FROM python:3.14-alpine

WORKDIR /app

RUN apk add --no-cache nodejs npm bash dumb-init && \
    addgroup -g 1000 app && \
    adduser -u 1000 -G app -s /bin/sh -D app

# build-base is needed on platforms without prebuilt wheels (e.g. miniaudio on arm64)
COPY requirements.txt ./
RUN apk add --no-cache --virtual .build-deps build-base && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps

COPY package.json package-lock.json ./
RUN npm ci --omit=dev && \
    ln -s /app/node_modules/.bin/pyatv-mqtt-bridge /usr/local/bin/pyatv-mqtt-bridge

USER app

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["pyatv-mqtt-bridge", "config.json"]

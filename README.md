# pyatv-mqtt-bridge-docker

Docker image for [sebbo2002/pyatv-mqtt-bridge](https://github.com/sebbo2002/pyatv-mqtt-bridge), published as `jaedle/pyatv-mqtt-bridge-docker`.

## Why

The upstream image `sebbo2002/pyatv-mqtt-bridge:11.0.0` bundles pyatv 0.18.0 on Python 3.14, where `atvscript` and `atvremote` crash on startup:

```
RuntimeError: There is no current event loop in thread 'MainThread'
```

`asyncio.get_event_loop()` no longer creates an event loop in Python 3.14. This image rebuilds the bridge on Python 3.13, where pyatv works.

## Contents

- Base: `python:3.13-alpine` (pinned in [`Dockerfile`](Dockerfile))
- `pyatv` via pip (pinned in [`requirements.txt`](requirements.txt))
- `@sebbo2002/pyatv-mqtt-bridge` via npm (pinned in [`package.json`](package.json))

All three are kept up to date by Dependabot. Do not bump the Python base image to 3.14 until pyatv supports it.

## Usage

Drop-in replacement for the upstream image:

```sh
docker run -v $PWD/config.json:/app/config.json jaedle/pyatv-mqtt-bridge-docker:11.0.0-fixed
```

## Release

Built and pushed by [pipeline-service](https://github.com/jaedle/pipeline-service) via [`ci/config.yaml`](ci/config.yaml).

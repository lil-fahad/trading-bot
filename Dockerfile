FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    BRIDGE_CONFIG=/data/config.json

WORKDIR /app

COPY source.b64 /tmp/source.b64
RUN python - <<'PY'
import base64, pathlib, tarfile
src = pathlib.Path('/tmp/source.b64')
archive = pathlib.Path('/tmp/source.tar.gz')
archive.write_bytes(base64.b64decode(src.read_text().strip(), validate=True))
with tarfile.open(archive, 'r:gz') as tf:
    tf.extractall('/app', filter='data')
src.unlink()
archive.unlink()
PY

RUN pip install --no-cache-dir -r requirements.lock
RUN mkdir -p /data && chmod 700 /data

EXPOSE 8787

CMD ["python", "-m", "telegram_bridge.railway_bootstrap"]

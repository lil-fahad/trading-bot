FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    BRIDGE_CONFIG=/data/config.json

WORKDIR /app

COPY source.part.* /tmp/source-parts/
RUN python - <<'PY'
import base64, hashlib, pathlib, tarfile
parts = sorted(pathlib.Path('/tmp/source-parts').glob('source.part.*'))
assert [p.name for p in parts] == [f'source.part.{i:02d}' for i in range(11)], [p.name for p in parts]
encoded = ''.join(p.read_text().strip() for p in parts)
assert hashlib.sha256(encoded.encode()).hexdigest() == '2b419f8810e5d70b76aec5558842aae95d579ea43ebea067762a528a2e753a0b'
raw = base64.b64decode(encoded, validate=True)
assert hashlib.sha256(raw).hexdigest() == 'c8f0ac0417d78f089f0b69ca283757a28e6d43d2ff658bf5af0dfc0d58978251'
archive = pathlib.Path('/tmp/source.tar.gz')
archive.write_bytes(raw)
with tarfile.open(archive, 'r:gz') as tf:
    tf.extractall('/app', filter='data')
archive.unlink()
for p in parts:
    p.unlink()
PY

RUN pip install --no-cache-dir -r requirements.lock
RUN mkdir -p /data && chmod 700 /data

EXPOSE 8787

CMD ["python", "-m", "telegram_bridge.railway_bootstrap"]

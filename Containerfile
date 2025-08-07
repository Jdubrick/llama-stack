FROM registry.access.redhat.com/ubi9/python-312 AS builder
USER root
ENV UV_COMPILE_BYTECODE=0 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=0

WORKDIR /app-root

RUN dnf install -y gcc python3.12-devel make && \
    dnf clean all && \
    pip3.12 install uv

COPY ./pyproject.toml ./run.yaml ./uv.lock ./scripts/entrypoint.sh ./

RUN chmod +x entrypoint.sh
RUN uv sync --locked --no-dev

FROM registry.access.redhat.com/ubi9/python-312-minimal
ARG APP_ROOT=/app-root
WORKDIR /app-root

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONCOERCECLOCALE=0 \
    PYTHONUTF8=1 \
    PYTHONIOENCODING=UTF-8 \
    LANG=en_US.UTF-8

COPY --from=builder --chown=1001:1001 /app-root /app-root

ENV PATH="/app-root/.venv/bin:$PATH"

EXPOSE 8321
ENTRYPOINT ["./entrypoint.sh"]

USER 1001

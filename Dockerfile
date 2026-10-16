# Usamos una base oficial de NVIDIA con CUDA 12.1 y Ubuntu 22.04
FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

# Evitar prompts interactivos durante la instalación de paquetes del sistema
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 1. Instalar dependencias del sistema críticas para audio y red
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    python3-pip \
    python3.11-dev \
    ffmpeg \
    libsndfile1 \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Configurar Python 3.11 como el predeterminado del sistema
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# 2. Instalar el bloque exacto de dependencias de tu archivo setup de Kaggle
RUN pip install --no-cache-dir \
    setuptools==80.9.0 \
    numpy==1.26.4 \
    scipy \
    pandas \
    scikit-learn==1.5.2 \
    tensorflow==2.15.0 \
    keras==2.15.0 \
    h5py \
    crema==0.2.0 \
    jams==0.3.5 \
    pumpp==0.6.0 \
    jsonschema \
    attrs \
    faster-whisper \
    all-in-one-infer \
    demucs \
    sqlalchemy \
    psycopg2-binary \
    psutil \
    boto3 \
    python-dotenv \
    pydantic \
    yt-dlp \
    python-telegram-bot \
    librosa \
    mir_eval \
    soundfile \
    pretty_midi \
    kaggle

# 3. Instalar Torch y Torchaudio con soporte CUDA 13.0
RUN pip install --no-cache-dir torch==2.4.0 torchaudio==2.4.0 --index-url https://pytorch.org/whl/cu121

# Definir el directorio de trabajo
WORKDIR /workspace

CMD ["bash"]
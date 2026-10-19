import json
import os
from urllib.parse import urlparse

# Abrimos el Notebook
with open('procesaraudio.ipynb', 'r') as f:
    nb = json.load(f)

# Procesamos la URL de la base de datos
db_url = os.environ.get('TMP_DATABASE_URL', '')
result = urlparse(db_url)

vars_dict = {
    'DATABASE_URL': db_url.replace('postgresql://', 'postgresql+psycopg2://', 1),
    'DB_USER': result.username or '',
    'DB_PASSWORD': result.password or '',
    'DB_HOST': result.hostname or '',
    'DB_NAME': result.path.lstrip('/'),
    'DB_PORT': str(result.port) if result.port else '5432',
    'GIT_TOKEN': os.environ.get('TMP_GITHUB_PAT', ''),
    'R2_ENDPOINT': os.environ.get('TMP_R2_ENDPOINT', ''),
    'R2_ACCESS_KEY': os.environ.get('TMP_R2_KEY', ''),
    'R2_SECRET_KEY': os.environ.get('TMP_R2_SECRET', ''),
    'R2_BUCKET': os.environ.get('TMP_R2_BUCKET', '')
}

# Creamos la celda con los secretos
codigo_celda = "import os\n"
for k, v in vars_dict.items():
    codigo_celda += f"os.environ[{json.dumps(k)}] = {json.dumps(v)}\n"

# Insertamos la celda al principio del notebook
nb['cells'].insert(0, {
    'cell_type': 'code', 'execution_count': None, 'metadata': {}, 'outputs': [], 'source': [codigo_celda]
})

# Guardamos el notebook modificado
with open('procesaraudio.ipynb', 'w') as f:
    json.dump(nb, f)
print("✅ Secretos inyectados de forma segura.")

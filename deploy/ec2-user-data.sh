#!/bin/bash
# Ejemplo de user-data para una instancia EC2 (Amazon Linux / Ubuntu compatible con apt/yum)
# Este script hace lo básico: instala OpenJDK 11, descarga el jar desde una URL (reemplazar) y configura systemd.

set -e

# Variables (REEMPLAZAR DOWNLOAD_URL con la URL pública del JAR - por ejemplo un bucket S3 público)
JAR_URL="REEMPLAZAR_POR_URL_DEL_JAR"
APP_DIR="/opt/aplicacion-aws"
JAR_NAME="aplicacion-aws.jar"
SERVICE_NAME="aplicacion-aws.service"

echo "Iniciando userdata: instalar Java y desplegar aplicación"

# Detectar apt o yum
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y openjdk-11-jre-headless curl
elif command -v yum >/dev/null 2>&1; then
  yum install -y java-11-amazon-corretto-headless curl || yum install -y java-11-openjdk-headless curl
else
  echo "No se encontró apt-get ni yum. Instala Java manualmente."
  exit 1
fi

mkdir -p ${APP_DIR}
cd ${APP_DIR}

echo "Descargando jar desde ${JAR_URL} (reemplaza en el script antes de lanzar la instancia)"
curl -sSL -o ${JAR_NAME} "${JAR_URL}"
chmod 755 ${JAR_NAME}

cat > /etc/systemd/system/${SERVICE_NAME} <<'EOF'
[Unit]
Description=Aplicacion AWS - Spring Boot
After=network.target

[Service]
User=root
WorkingDirectory=/opt/aplicacion-aws
ExecStart=/usr/bin/java -jar /opt/aplicacion-aws/aplicacion-aws.jar
SuccessExitStatus=143
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ${SERVICE_NAME}
systemctl start ${SERVICE_NAME}

echo "Aplicación iniciada (si el JAR fue descargado correctamente)." 

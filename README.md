# Aplicación Spring Boot - despliegue en EC2

Proyecto de ejemplo: microservicio sencillo en Java con Spring Boot y artefactos para despliegue básico en una instancia EC2.

Contenido:

- `pom.xml` - proyecto Maven
- `src/main/java/...` - código del servicio
- `Dockerfile` - imagen Docker para ejecutar el jar
- `deploy/ec2-user-data.sh` - script para usar como User Data al lanzar una instancia EC2 (modificar JAR_URL)
- `deploy/demo.service` - ejemplo de unit file systemd

Requisitos locales:

- Java 11 (para ejecutar localmente)
- Maven (para compilar)
- Docker (opcional, para crear imagen)

Compilar y ejecutar localmente (PowerShell en Windows):

```powershell
# Compilar
mvn -f . clean package -DskipTests

# Ejecutar
java -jar .\target\aplicacion-aws-0.0.1-SNAPSHOT.jar
```

Endpoints disponibles (cuando la app corre en el puerto 8080):

- GET / => mensaje de bienvenida
- GET /health => {"status":"UP"}
- GET /polizas => lista de pólizas de ejemplo

Crear imagen Docker:

```powershell
# Construir jar primero
mvn -DskipTests package

# Construir imagen (desde la raíz del proyecto)
docker build -t aplicacion-aws:latest .

# Ejecutar contenedor
docker run -p 8080:8080 aplicacion-aws:latest
```

Despliegue básico en EC2 (opciones):

1. Subir el JAR y arrancarlo manualmente por SSH

- Compilar en tu máquina y subir el jar al servidor (ejemplo con scp desde PowerShell):

```powershell
# En PowerShell: reemplaza <USER> y <EC2_HOST>
scp .\target\aplicacion-aws-0.0.1-SNAPSHOT.jar <USER>@<EC2_HOST>:/home/<USER>/aplicacion-aws.jar

# Conectarse por SSH
ssh <USER>@<EC2_HOST>
# En la instancia EC2 (instalar java si es necesario):
sudo apt-get update -y; sudo apt-get install -y openjdk-11-jre-headless
# Mover jar y ejecutar
sudo mkdir -p /opt/aplicacion-aws
sudo mv ~/aplicacion-aws.jar /opt/aplicacion-aws/aplicacion-aws.jar
sudo java -jar /opt/aplicacion-aws/aplicacion-aws.jar &
```

2. Usar systemd (recomendado para producción ligera)

- Copia `deploy/demo.service` a `/etc/systemd/system/` en la instancia (ajusta User/paths). Luego:

```bash
sudo systemctl daemon-reload
sudo systemctl enable demo.service
sudo systemctl start demo.service
sudo journalctl -u demo.service -f
```

3. Usar user-data al lanzar la instancia EC2

- Edita `deploy/ec2-user-data.sh`, reemplaza `REEMPLAZAR_POR_URL_DEL_JAR` por la URL donde pueda descargarse el jar (por ejemplo objeto S3 público). En el panel de AWS EC2, en "Configure Instance" pega ese script en "User data".

Notas y recomendaciones:

- Para producción, usa un bucket S3 privado + IAM role en la instancia o despliegue con CI/CD.
- Asegura el grupo de seguridad de la instancia EC2 para permitir tráfico entrante al puerto 8080 (o usa proxy inverso / ALB).
- Considera usar AWS Systems Manager (SSM) o un pipeline para subir y arrancar el servicio sin SSH.

Si quieres, puedo añadir un archivo `build-and-deploy.ps1` que automatice empaquetado y subida por SCP a tu EC2, o generar un pequeño Playbook/Terraform para crear la instancia con user-data.

## Documentación OpenAPI / Swagger

Se agregó `springdoc-openapi-ui`. Cuando la aplicación esté en marcha (por defecto en el puerto 8081), podrás acceder a la documentación interactiva en:

- http://localhost:8081/swagger-ui.html
- o en: http://localhost:8081/swagger-ui/index.html

También puedes obtener el JSON OpenAPI en:

- http://localhost:8081/v3/api-docs

Nota: si cambias el puerto o el context-path, ajusta las URLs en consecuencia.

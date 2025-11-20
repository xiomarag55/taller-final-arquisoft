param(
    [Parameter(Mandatory=$true)] [string] $Host,
    [Parameter(Mandatory=$false)] [string] $User = "ec2-user",
    [Parameter(Mandatory=$false)] [string] $KeyPath = $null,
    [Parameter(Mandatory=$false)] [string] $JarPath = "target\aplicacion-aws-0.0.1-SNAPSHOT.jar",
    [Parameter(Mandatory=$false)] [string] $RemotePath = "/opt/aplicacion-aws/aplicacion-aws.jar",
    [Parameter(Mandatory=$false)] [switch] $UseSudo
)

Write-Host "Construyendo el proyecto (mvn package)..."
mvn -DskipTests package

if (-not (Test-Path $JarPath)) {
    Write-Error "No se encontró el jar en $JarPath. Revisa si la compilación fue exitosa."
    exit 1
}

$scpCmd = "scp"
$sshCmd = "ssh"

if ($KeyPath) {
    $scpCmd += " -i `"$KeyPath`""
    $sshCmd += " -i `"$KeyPath`""
}

$remoteDest = "$User@$Host:$RemotePath"

Write-Host "Subiendo $JarPath -> $remoteDest"
& $scpCmd $JarPath $remoteDest

Write-Host "Conectando por SSH para mover/arrancar la aplicación"
$remoteCommands = @(
    "sudo mkdir -p /opt/aplicacion-aws",
    "sudo mv $RemotePath /opt/aplicacion-aws/aplicacion-aws.jar || sudo cp $RemotePath /opt/aplicacion-aws/aplicacion-aws.jar",
    "sudo chmod 755 /opt/aplicacion-aws/aplicacion-aws.jar",
    "sudo systemctl daemon-reload || true",
    "sudo systemctl enable demo.service || true",
    "sudo systemctl restart demo.service || (nohup sudo java -jar /opt/aplicacion-aws/aplicacion-aws.jar > /var/log/aplicacion-aws.log 2>&1 &)",
    "sudo journalctl -u demo.service --no-pager | tail -n 50"
)

$cmd = $sshCmd + " " + "$User@$Host " + "'" + ($remoteCommands -join "; ") + "'"

Write-Host "Ejecutando: $cmd"
iex $cmd

Write-Host "Despliegue finalizado. Revisa los logs en la instancia o el endpoint /health en http://$Host:8080/health (asegúrate del puerto y reglas del SG)."

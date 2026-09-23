# ============================================================================
# Liest die Terraform-Outputs und legt daraus die Kubernetes Secrets an.
# Die Zugangsdaten gehen dabei NIE durch das Repository.
#
# Aufruf (PowerShell, im Ordner terraform/databases):
#   .\create-db-secrets.ps1
#   .\create-db-secrets.ps1 -Namespace user-mgmt-staging
# ============================================================================
param(
    [string]$Namespace = "user-mgmt"
)

$ErrorActionPreference = "Stop"

Write-Host "Lese Terraform Outputs..." -ForegroundColor Cyan
$tf = terraform output -json | ConvertFrom-Json

if (-not $tf.user_mgmt_jdbc_url) {
    throw "Keine Terraform Outputs gefunden. Zuerst 'terraform apply' ausfuehren."
}

Write-Host "Stelle sicher, dass der Namespace $Namespace existiert..." -ForegroundColor Cyan
kubectl create namespace $Namespace --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Schreibe Secret 'user-mgmt-db' (PostgreSQL)..." -ForegroundColor Cyan
kubectl create secret generic user-mgmt-db `
    --namespace $Namespace `
    --from-literal=SPRING_DATASOURCE_URL=$($tf.user_mgmt_jdbc_url.value) `
    --from-literal=SPRING_DATASOURCE_USERNAME=$($tf.user_mgmt_db_user.value) `
    --from-literal=SPRING_DATASOURCE_PASSWORD=$($tf.user_mgmt_db_password.value) `
    --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Schreibe Secret 'module-service-db' (MySQL)..." -ForegroundColor Cyan
kubectl create secret generic module-service-db `
    --namespace $Namespace `
    --from-literal=DATABASE_URL=$($tf.module_service_database_url.value) `
    --from-literal=MYSQL_SSL_DISABLED=false `
    --dry-run=client -o yaml | kubectl apply -f -

Write-Host ""
Write-Host "Fertig. Kontrolle:" -ForegroundColor Green
kubectl get secret user-mgmt-db module-service-db -n $Namespace

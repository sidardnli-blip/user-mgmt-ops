# Diese Outputs werden vom Skript create-db-secrets.ps1 gelesen und als
# Kubernetes Secrets in den Cluster geschrieben. Die Werte landen NIE im Git.

output "user_mgmt_jdbc_url" {
  description = "JDBC URL fuer den user_mgmt_service (privates Netz, TLS)"
  value       = "jdbc:postgresql://${digitalocean_database_cluster.postgres.private_host}:${digitalocean_database_cluster.postgres.port}/${digitalocean_database_db.user_mgmt.name}?sslmode=require"
}

output "user_mgmt_db_user" {
  description = "Datenbankbenutzer des user_mgmt_service"
  value       = digitalocean_database_cluster.postgres.user
}

output "user_mgmt_db_password" {
  description = "Passwort des Datenbankbenutzers"
  value       = digitalocean_database_cluster.postgres.password
  sensitive   = true
}

output "module_service_database_url" {
  description = "SQLAlchemy URL fuer den module_service (privates Netz, TLS)"
  value       = "mysql+pymysql://${digitalocean_database_cluster.mysql.user}:${urlencode(digitalocean_database_cluster.mysql.password)}@${digitalocean_database_cluster.mysql.private_host}:${digitalocean_database_cluster.mysql.port}/${digitalocean_database_db.module_service.name}?charset=utf8mb4"
  sensitive   = true
}

output "postgres_public_host" {
  description = "Oeffentlicher Host (nur fuer manuelle Kontrolle mit psql)"
  value       = digitalocean_database_cluster.postgres.host
}

output "mysql_public_host" {
  description = "Oeffentlicher Host (nur fuer manuelle Kontrolle mit mysql)"
  value       = digitalocean_database_cluster.mysql.host
}

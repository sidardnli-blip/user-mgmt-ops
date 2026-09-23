variable "do_token" {
  description = "DigitalOcean API Token (per Umgebungsvariable TF_VAR_do_token setzen)"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Name des bestehenden Kubernetes Clusters (fuer VPC und Firewall)"
  type        = string
  default     = "user-mgmt-cluster"
}

variable "region" {
  description = "Region der Datenbanken (gleiche Region wie der Cluster!)"
  type        = string
  default     = "fra1"
}

variable "database_size" {
  description = "Groesse der Managed Database Nodes"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "postgres_cluster_name" {
  description = "Name des PostgreSQL Clusters bei DigitalOcean"
  type        = string
  default     = "user-mgmt-postgres"
}

variable "postgres_version" {
  description = "PostgreSQL Hauptversion (doctl databases options versions)"
  type        = string
  default     = "17"
}

variable "postgres_database_name" {
  description = "Datenbank des user_mgmt_service"
  type        = string
  default     = "user_mgmt"
}

variable "mysql_cluster_name" {
  description = "Name des MySQL Clusters bei DigitalOcean"
  type        = string
  default     = "module-service-mysql"
}

variable "mysql_version" {
  description = "MySQL Hauptversion"
  type        = string
  default     = "8"
}

variable "mysql_database_name" {
  description = "Datenbank des module_service"
  type        = string
  default     = "module_service"
}

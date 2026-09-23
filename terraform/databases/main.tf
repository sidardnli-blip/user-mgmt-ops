# ============================================================================
# Aufgabe 4: Die selbst betriebene PostgreSQL im Cluster wird durch eine
# DigitalOcean Managed Database ersetzt.
# Aufgabe 6: Zusaetzlich eine Managed MySQL fuer den module_service.
#
# Beide Datenbanken haengen im selben VPC wie der Kubernetes Cluster und sind
# nur aus diesem Cluster erreichbar (Trusted Sources).
# ============================================================================

# Der Cluster selbst wird hier nur GELESEN (er wird im Modul ../cluster verwaltet)
data "digitalocean_kubernetes_cluster" "main" {
  name = var.cluster_name
}

# --- PostgreSQL fuer den user_mgmt_service ---------------------------------
resource "digitalocean_database_cluster" "postgres" {
  name                 = var.postgres_cluster_name
  engine               = "pg"
  version              = var.postgres_version
  size                 = var.database_size
  region               = var.region
  node_count           = 1
  private_network_uuid = data.digitalocean_kubernetes_cluster.main.vpc_uuid
}

resource "digitalocean_database_db" "user_mgmt" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = var.postgres_database_name
}

# Nur der Kubernetes Cluster darf auf die Datenbank zugreifen
resource "digitalocean_database_firewall" "postgres" {
  cluster_id = digitalocean_database_cluster.postgres.id

  rule {
    type  = "k8s"
    value = data.digitalocean_kubernetes_cluster.main.id
  }
}

# --- MySQL fuer den module_service -----------------------------------------
resource "digitalocean_database_cluster" "mysql" {
  name                 = var.mysql_cluster_name
  engine               = "mysql"
  version              = var.mysql_version
  size                 = var.database_size
  region               = var.region
  node_count           = 1
  private_network_uuid = data.digitalocean_kubernetes_cluster.main.vpc_uuid
}

resource "digitalocean_database_db" "module_service" {
  cluster_id = digitalocean_database_cluster.mysql.id
  name       = var.mysql_database_name
}

resource "digitalocean_database_firewall" "mysql" {
  cluster_id = digitalocean_database_cluster.mysql.id

  rule {
    type  = "k8s"
    value = data.digitalocean_kubernetes_cluster.main.id
  }
}

resource "digitalocean_kubernetes_cluster" "main" {
  name    = var.cluster_name
  region  = var.region
  version = var.kubernetes_version

  auto_upgrade                     = var.auto_upgrade
  surge_upgrade                    = var.surge_upgrade
  ha                               = var.ha_control_plane
  tags                             = var.cluster_tags
  destroy_all_associated_resources = false
  registry_integration             = false

  node_pool {
    name       = var.node_pool_name
    size       = var.node_size
    node_count = var.node_count
  }
}

output "cluster_id" {
  description = "UUID des Clusters"
  value       = digitalocean_kubernetes_cluster.main.id
}

output "cluster_endpoint" {
  description = "API Server Endpoint"
  value       = digitalocean_kubernetes_cluster.main.endpoint
}

output "cluster_version" {
  description = "Laufende Kubernetes Version"
  value       = digitalocean_kubernetes_cluster.main.version
}

output "cluster_vpc_uuid" {
  description = "VPC des Clusters (wird von den Managed Databases genutzt)"
  value       = digitalocean_kubernetes_cluster.main.vpc_uuid
}

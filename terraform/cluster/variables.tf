variable "do_token" {
  description = "DigitalOcean API Token (per Umgebungsvariable TF_VAR_do_token setzen)"
  type        = string
  sensitive   = true
}

variable "cluster_id" {
  description = "UUID des bestehenden Clusters (doctl kubernetes cluster list)"
  type        = string
}

variable "cluster_name" {
  description = "Name des bestehenden Kubernetes Clusters"
  type        = string
  default     = "user-mgmt-cluster"
}

variable "region" {
  description = "DigitalOcean Region des Clusters"
  type        = string
  default     = "fra1"
}

variable "kubernetes_version" {
  description = "Exakte Version wie sie doctl anzeigt, z.B. 1.34.1-do.0"
  type        = string
}

variable "node_pool_name" {
  description = "Name des Default Node Pools"
  type        = string
  default     = "pool-1"
}

variable "node_size" {
  description = "Droplet-Groesse der Worker Nodes"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "node_count" {
  description = "Anzahl Worker Nodes im Default Node Pool"
  type        = number
  default     = 2
}

variable "auto_upgrade" {
  description = "Automatische Patch-Updates der Kubernetes-Version"
  type        = bool
  default     = false
}

variable "surge_upgrade" {
  description = "Surge Upgrade (zusaetzliche Node waehrend Updates)"
  type        = bool
  default     = true
}

variable "ha_control_plane" {
  description = "Hochverfuegbare Control Plane (kostet extra)"
  type        = bool
  default     = false
}

variable "cluster_tags" {
  description = "Tags am Cluster"
  type        = list(string)
  default     = []
}

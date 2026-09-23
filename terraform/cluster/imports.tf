# Aufgabe 3: Der bestehende Cluster wird NICHT neu erstellt, sondern als
# bestehende Infrastruktur uebernommen.
#
# Schritt 1:  terraform plan -generate-config-out=generated.tf
# Schritt 2:  generated.tf analysieren und bereinigen (Vorlage: generated.tf.vorlage)
# Schritt 3:  terraform apply   -> Cluster liegt im State
# Schritt 4:  terraform plan    -> "No changes"
import {
  to = digitalocean_kubernetes_cluster.main
  id = var.cluster_id
}

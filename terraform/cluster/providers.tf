# Der Token kommt aus der Umgebungsvariablen TF_VAR_do_token und steht
# damit NICHT im Repository (Akzeptanzkriterium Aufgabe 3).
provider "digitalocean" {
  token = var.do_token
}

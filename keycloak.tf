resource "random_password" "keycloak_admin" {
  length           = 32
  special          = true
  min_special      = 4
  override_special = "*?+_%:"
  keepers = {
    keystore_version = 1
  }
}

locals {
  admin_password = var.admin_password != null ? var.admin_password : random_password.keycloak_admin.result
}

resource "helm_release" "keycloak" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = var.chart_version

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "auth.adminUser"
    value = var.admin_username
  }
  set_sensitive {
    name  = "auth.adminPassword"
    value = local.admin_password
  }

  set {
    name  = "extraEnvVars[0].name"
    value = "KEYCLOAK_EXTRA_ARGS"
  }
  set {
    name  = "extraEnvVars[0].value"
    value = "-Dkeycloak.frontendUrl=https://${var.url}/auth"
  }
  set {
    name  = "ingress.hostname"
    value = var.url
  }
  set {
    name  = "ingress.pathType"
    value = "Prefix"
  }
  set {
    name  = "proxyAddressForwarding"
    value = "true"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "traefik"
  }

  set {
    name  = "ingress.extraTls"
    value = <<EOF
  - hosts:
    - "${var.url}"
    EOF
  }
}


resource "google_compute_ssl_certificate" "ssl_certificate" {
  name        = "${var.name}-ssl-certificate"
  private_key = var.private_key
  certificate = var.certificate
  project     = var.project_id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${var.name}-https-service"
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_ssl_certificate.ssl_certificate.self_link]

  depends_on = [
    google_compute_ssl_certificate.ssl_certificate
  ]
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-url-map"
  description     = "URL proxy map for : ${var.name}"
  default_service = google_compute_backend_service.backend_service.id
}


resource "google_compute_backend_service" "backend_service" {
  name                            = "${var.name}-backend-service"
  enable_cdn                      = true
  timeout_sec                     = 10
  connection_draining_timeout_sec = 10
  health_checks                   = [google_compute_health_check.health_check.id]

  backend {
    group          = var.target_backend_group
  }
}

resource "google_compute_health_check" "health_check" {
  name = "health-check"
  http_health_check {
    port = var.health_check_port
  }
}


resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name                  = "${var.name}-https-forwarding-rule"
  target                = google_compute_target_https_proxy.https_proxy.id
  port_range            = "443" # HTTPS Load Balancer port
  load_balancing_scheme = var.load_balancing_scheme
}

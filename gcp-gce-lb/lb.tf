
resource "google_compute_ssl_certificate" "ssl_certificate" {
  name        = "${var.name}-ssl-certificate"
  private_key = var.private_key
  certificate = var.certificate
  project     = var.project_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${var.name}-https-service"
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_ssl_certificate.ssl_certificate.self_link]
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-url-map"
  description     = "URL proxy map for : ${var.name}"
  default_service = google_compute_backend_service.backend_service.id
}


resource "google_compute_backend_service" "backend_service" {
  name        = "${var.name}-backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 30

  backend {
    group           = google_compute_network_endpoint_group.endpoint_group.id
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
  }
}

resource "google_compute_network_endpoint_group" "endpoint_group" {
  name                  = "${var.name}-endpoint-group"
  network               = var.network
  subnetwork            = var.subnetwork
  default_port          = var.target_port
  zone                  = var.zone
  network_endpoint_type = "GCE_VM_IP_PORT"
}

resource "google_compute_network_endpoint" "endpoint" {
  network_endpoint_group = google_compute_network_endpoint_group.endpoint_group.name
  instance               = var.instance_name
  zone                   = var.zone
  port                   = var.target_port
  ip_address             = var.target_ip
}


resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name                  = "${var.name}-https-forwarding-rule"
  target                = google_compute_target_https_proxy.https_proxy.id
  port_range            = "443" # HTTPS Load Balancer port
  load_balancing_scheme = var.load_balancing_scheme
}


resource "google_compute_ssl_certificate" "ssl_certificate" {
  name        = "${var.name}-ssl-certificate"
  private_key = var.private_key
  certificate = var.certificate
  project     = var.project_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name       = "${var.name}-https-forwarding-rule"
  target     = google_compute_backend_service.backend_service.id
  port_range = "443"  # HTTPS Load Balancer port
  load_balancing_scheme = var.load_balancing_scheme

  ssl_certificates = [google_compute_ssl_certificate.ssl_certificate.self_link]
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
  name        = "${var.name}-endpoint-group"
  network     = var.network
  subnetworks = var.subnetworks
  default_port = var.target_port
  zone         = var.zone
  network_endpoint_type = "GCE_VM_IP_PORT"
}

resource "google_compute_network_endpoint" "endpoint" {
  network_endpoint_group = google_compute_network_endpoint_group.endpoint_group.name
  port = var.target_port
  ip_address = var.target_ip
}
# Define a Google Compute Target Pool
resource "google_compute_target_pool" "target_pool" {
  name      = "${var.name}-target-pool"
  region    = var.region
  instances = var.instances

  health_checks = [
    google_compute_http_health_check.health_check.name,
  ]
}

# Define a Google Compute Forwarding Rule
resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  = "${var.name}-forwarding-rule"
  region                = var.region
  load_balancing_scheme = var.load_balancing_scheme
  target                = google_compute_target_pool.target_pool.self_link
  port_range            = var.target_port
}

resource "google_compute_http_health_check" "health_check" {
  name               = "${var.name}-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = var.target_port
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
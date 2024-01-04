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
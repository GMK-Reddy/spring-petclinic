terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.29.0"
    }
  }
}
provider "google" {
  # Configuration options
}

resource "google_project_iam_member" "BCGCP010005_FAIL" {
  project = "your-project-id-1"
  role    = "roles/owner"
  member  = "user:test@example-project.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "BCGCP010006_FAIL" {
  project = "your-project-id-2"
  role    = "roles/iam.serviceAccountTokenCreator"
}

resource "google_kms_crypto_key" "PARENT_BCGCP010009_FAIL" {
  name            = "my-crypto-key"
  key_ring        = google_kms_key_ring.key_ring.id
}

resource "google_kms_crypto_key_iam_member" "CHILD_BCGCP010009_FAIL" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  member        = "allUsers"
}

resource "google_kms_crypto_key" "BCGCP010010_PASS" {
  name            = "crypto-key-example"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "7776000s"
}

resource "google_compute_instance" "BCGCP020001_FAIL" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    email  = "my-project-compute@developer.gserviceaccount.com"
  }
}

resource "google_compute_instance" "BCGCP020002_FAIL" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    email  = "my-project-compute@developer.gserviceaccount.com"
  }
}

resource "google_compute_instance" "BCGCP020003_PASS" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  metadata = {
    block-project-ssh-keys = true
  }
}

resource "google_compute_instance" "BCGCP020004_PASS" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {}
  metadata = {
    "enable-oslogin" = "TRUE"
  }
}

resource "google_compute_instance" "BCGCP020005_PASS" {
  name         = "test-1"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {}
  metadata = {
    "serial-port-enable" = "FALSE"
  }
}

resource "google_compute_instance" "BCGCP020006_FAIL" {
  name         = "test-2"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  can_ip_forward = true
}

resource "google_compute_disk" "PARENT_BCGCP020007_PASS" {
  disk_encryption_key {
    kms_key_self_link = "https://app.banyancloud.io/kms_key_self_link"
  }
  boot_disk {
    disk_encryption_key_raw = "a1b2c3d4e5f6g7h8i9j0"
  }
}

resource "google_compute_instance" "DEPENDENT_BCGCP020007_PASS" {
  boot_disk {
    disk_encryption_key_raw = "a1b2c3d4e5f6g7h8i9j0"
  }
}

resource "google_compute_instance" "BCGCP020008_FAIL" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {}
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = false
      enable_vtpm                 = false
    }
}

resource "google_compute_instance" "BCGCP020009_FAIL" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {}
  network_interface {
     network    = google_compute_network.vpc_network.id
     subnetwork = google_compute_subnetwork.subnet.id
     access_config {
        nat_ip = "127.0.0.1"
     }
  }
}

resource "google_compute_instance" "BCGCP020011_PASS" {
  confidential_instance_config {
      enable_confidential_compute = true
  }
}

resource "google_storage_bucket_iam_member" "PARENT_BCGCP030001_FAIL" {
  bucket = google_storage_bucket.default.name
  role   = "roles/storage.admin"
  member = "allUsers"
}

resource "google_storage_bucket_iam_binding" "DEPENDENT_BCGCP030001_FAIL" {
  bucket  = google_storage_bucket.default.name
  role    = "roles/storage.admin"
  members = [
    "allAuthenticatedUsers",
    "allUsers"
  ]
}

resource "google_storage_bucket" "BCGCP030002_PASS" {
  name     = "terragoat-${var.environment}"
  bucket_policy_only = true
  uniform_bucket_level_access = true
}

resource "google_project" "BCGCP050001_PASS" {
  name       = "My Project"
  project_id = "your-project-id"
  org_id     = "1234567"
  auto_create_network   = false
}

resource "google_dns_managed_zone" "BCGCP050003_PASS" {
  description  = "Company Domain name"
  dns_name     = "example.com."
  dnssec_config {
    kind          = "dns"
    non_existence = "nsec3"
    state         = "on"
  }
}

resource "google_dns_managed_zone" "BCGCP050004_PASS" {
  name        = "secure-zone"
  dns_name    = "example.com." 
  description = "Managed zone with DNSSEC, avoiding RSASHA1 for KSK and ZSK"

  dnssec_config {
    state = "on" 
    default_key_specs {
      key_type      = "keySigning"
      algorithm     = "rsasha256"
      key_length    = 2048
    }
  }
}

resource "google_dns_managed_zone" "BCGCP050005_FAIL" {
  name        = "secure-zone"
  dns_name    = "example.com."
  description = "Managed zone with DNSSEC, avoiding RSASHA1 for KSK and ZSK"
  dnssec_config {
    state = "on" 
    default_key_specs {
      key_type      = "zoneSigning"
      algorithm     = "rsasha1"
      key_length    = 2048
    }
  }
}

resource "google_compute_firewall" "BCGCP050006_FAIL" {
  name    = "test-firewall"
  network = google_compute_network.default.name
  direction = INGRESS
  allow {
    protocol = "ssh" 
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/24"]
}

resource "google_compute_firewall" "BCGCP050007_FAIL" {
  name    = "test-firewall"
  network = google_compute_network.default.name
  direction = INGRESS
  allow {
    protocol = "all"
    ports    = ["0-65535"]
  }
  source_ranges = ["0.0.0.0/24"]
}

resource "google_compute_subnetwork" "BCGCP050008_PASS" {
  name          = "log-test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom-test.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_sql_database_instance" "BCGCP060027_PASS" {
  name             = "secure-db-instance"
  database_version = "MYSQL_5_7"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = true
      ssl_mode     = "ENCRYPTED_ONLY"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060028_FAIL" {
  name             = "secure-db-instance"
  database_version = "POSTGRES_12"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = true
      ssl_mode     = "NOT_ENCRYPTED"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060029_FAIL" {
  name             = "secure-db-instance"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database_instance" "BCGCP060030_FAIL" {
  name             = "restricted-db-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "my-vpn-range"
        value = "0.0.0.0/0"
      }
      ssl_mode = "ENCRYPTED_ONLY"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060031_PASS" {
  name             = "restricted-db-instance"
  database_version = "POSTGRES_12"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "my-vpn-range"
        value = "172.16.1.0/24"
      }
      ssl_mode = "ENCRYPTED_ONLY"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060032_FAIL" {
  name             = "restricted-db-instance"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "my-vpn-range"
        value = "0.0.0.0/0"
      }
      ssl_mode = "ENCRYPTED_ONLY"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060033_PASS" {
  name             = "master-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"
  settings {
    ip_configuration{
      ipv4_enabled    = "false"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060034_FAIL" {
  name             = "secure-db-instance"
  database_version = "POSTGRES_14"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = true
      private_network = "projects/your-gcp-project-id/global/networks/default"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060035_FAIL" {
  name             = "secure-db-instance"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      private_network = "projects/your-gcp-project-id/global/networks/default"
    }
  }
}

resource "google_sql_database_instance" "BCGCP060036_PASS" {
  name             = "secure-db-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "02:00"
      location           = "us"
      retained_backups   = 7
    }
  }
}

resource "google_sql_database_instance" "BCGCP060037_FAIL" {
  name             = "secure-db-instance"
  database_version = "POSTGRES_14"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    backup_configuration {
      enabled            = false
      binary_log_enabled = true
      start_time         = "02:00"
      location           = "us"
      retained_backups   = 7
    }
  }
}

resource "google_sql_database_instance" "BCGCP060038_FAIL" {
  name             = "secure-db-instance"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    backup_configuration {
      binary_log_enabled = true
      start_time         = "02:00"
      location           = "us"
      retained_backups   = 7
    }
  }
}
resource "google_kms_key_ring" "key_ring" {
  name     = "my-key-ring"
  location = "us-central1"
  project  = "your-project-id-1"
}

resource "google_kms_key_ring" "keyring" {
  name     = "example-key-ring"
  location = "us-central1"
  project  = "your-project-id-1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
  project                 = "your-project-id-1"
}

resource "google_compute_network" "default" {
  name                    = "default"
  auto_create_subnetworks = true
  project                 = "your-project-id-1"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_storage_bucket" "default" {
  name     = "my-default-bucket"
  location = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}

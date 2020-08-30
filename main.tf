provider "google" {
  project = "vocal-mountain-263507"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "vm_instance" {
  #name         = "terraform-instance"
  name         = "e2-standard-2"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20200810"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
  
  metadata_startup_script = "${file("start_script.sh")}"

}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "vpc_network" {
  name    = "allow-jenkins-ssh"
  network = "terraform-network"
  source_ranges = ["0.0.0.0/0"]
  #destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8080","22"]
  }
}

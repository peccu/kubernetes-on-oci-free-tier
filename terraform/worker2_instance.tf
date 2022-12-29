resource "oci_core_instance" "worker2" {
  availability_domain = lookup(data.oci_identity_availability_domains.all.availability_domains[0], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "${var.cluster_name}-worker2"

  source_details {
    source_id = var.image_id
    source_type = "image"
  }
  shape               = var.shape
  shape_config {
    memory_in_gbs = var.shape_worker_memory
    ocpus         = var.shape_worker_ocpu
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.worker.id
    display_name     = "Primaryvnic2"
    assign_public_ip = true
    hostname_label   = "${var.cluster_name}-worker2"
    nsg_ids          = [oci_core_network_security_group.worker.id]
  }

  extended_metadata = {
    roles               = "workers"
    ssh_authorized_keys = file(pathexpand(var.ssh_public_key_path))

    tags      = "group:worker"
  }

  freeform_tags = tomap({"worker": true})
}
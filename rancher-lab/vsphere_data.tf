data vsphere_datacenter "this" {
  for_each = var.vms

  name = each.value.datacenter
}

data vsphere_compute_cluster "this" {
  for_each = var.vms

  name          = each.value.cluster
  datacenter_id = data.vsphere_datacenter.this[each.key].id
}

data vsphere_datastore "this" {
  for_each = var.vms

  name          = each.value.datastore
  datacenter_id = data.vsphere_datacenter.this[each.key].id
}

data vsphere_network "this" {
  for_each = var.vms

  name          = each.value.network
  datacenter_id = data.vsphere_datacenter.this[each.key].id
}


data vsphere_virtual_machine "template" {
  for_each = var.vms

  name          = each.value.template
  datacenter_id = data.vsphere_datacenter.this[each.key].id
}

data template_file "metadataconfig" {
  for_each = var.vms

  # Main cloud-config configuration file.
  template = file("${path.module}/nodes/common/metadata.yaml")
  vars = {
    ip = "${each.value.ip}"
    netmask = "${each.value.netmask}"
    hostname = "${each.value.hostname}"
    instance_id = "${each.value.vmname}"
    gw = "${var.vm_env.gw}"
    dns = "${var.vm_env.dns}"
    
  }
}

data template_file "userdataconfig" {
  for_each = var.vms

  template = file("${path.module}/nodes/${each.value.vmname}/cloudinit/userdata.yaml")
  vars = {
    ip = "${each.value.ip}"
    hostname = "${each.value.hostname}"
    domain_name = "${each.value.domain_name}"
  }
}


data template_file "kickstartconfig" {
  for_each = var.vms

  # Main cloud-config configuration file.
  template = file("${path.module}/nodes/common/kickstart.yaml")
  vars = {
    user = "${each.value.user}"
    password = "${each.value.password}"
  }
}

data template_file "dnsrecord" {
  for_each = var.vms

  # Main cloud-config configuration file.
  template = file("${path.module}/scripts/DnsSetRecord.ps1")
  vars = {
    hostname = "${each.value.hostname}"
    domain_name = "${each.value.domain_name}"
    ip = "${each.value.ip}"
  }
}

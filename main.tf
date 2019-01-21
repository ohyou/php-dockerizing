locals {
  openstack = "${map(
    "auth_url", "${lookup(var.cloud, "auth_url")}",
    "domain_name", "${lookup(var.cloud, "domain_name")}",
    "tenant_name", "${lookup(var.cloud, "tenant_name")}",
    "user_name", "${lookup(var.cloud, "user_name")}",
    "password", "${lookup(var.cloud, "password")}",
    "region", "${lookup(var.cloud, "region", "ru-1")}",
  )}"

  cloud = "${map(
    "name", "${local.openstack["tenant_name"]}",
    "region", "${local.openstack["region"]}",
    "zone", "${lookup(var.cloud, "zone", "${local.openstack["region"]}a")}"
  )}"
}

provider "openstack" {
  auth_url    = "${local.openstack["auth_url"]}"
  domain_name = "${local.openstack["domain_name"]}"
  tenant_name = "${local.openstack["tenant_name"]}"
  user_name   = "${local.openstack["user_name"]}"
  password    = "${local.openstack["password"]}"
  region      = "${local.openstack["region"]}"
}

module "keypair" {
  source  = "github.com/kodix/terraform-selectel/modules/keypair"
  cloud   = "${local.cloud}"
  private = "${lookup(var.ssh, "file")}"
}

module "network" {
  source = "github.com/kodix/terraform-selectel/modules/network"
  cloud  = "${local.cloud}"

  # lan {
  #   cidr    = "192.168.0.0/24"
  #   gateway = "192.168.0.254"
  # }

  # wan {
  #   uuid = "af3d0c8c-382e-4d82-8954-98674b91d9a9"
  # }

  # dns = [
  #   "8.8.8.8",
  #   "1.1.1.1",
  # ]
}


module "manager" {
  source  = "github.com/kodix/terraform-selectel/modules/instance"
  cloud   = "${local.cloud}"
  name    = "manager"
  keypair = "${module.keypair.name}"
}

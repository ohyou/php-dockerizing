locals {
  openstack = "${map(
    "auth_url", "https://api.selvpc.ru/identity/v3",
    "domain_name", "${lookup(var.cloud, "domain_name")}",
    "tenant_name", "${lookup(var.cloud, "tenant_name")}",
    "user_name", "${lookup(var.cloud, "user_name")}",
    "password", "${lookup(var.cloud, "password")}",
    "region", "${lookup(var.cloud, "region")}",
  )}"

  cloud = "${map(
    "name", "${local.openstack["tenant_name"]}",
    "region", "${local.openstack["region"]}",
    "zone", "${lookup(var.cloud, "zone")}"
  )}"

  project_name = "audi-park.ru"
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
  source  = "github.com/ohyou/terraform-selectel/modules/keypair"
  cloud   = "${local.cloud}"
  private = "${file("~/.ssh/id_rsa")}"
}

module "network" {
  source = "github.com/ohyou/terraform-selectel/modules/network"
  cloud  = "${local.cloud}"

  lan {
    cidr    = "192.168.0.0/24"
    gateway = "192.168.0.254"
  }

  wan {
    uuid = "749528d8-485f-4474-bbbc-968c9197010a"
  }

  dns = [
    "8.8.8.8",
    "1.1.1.1",
  ]
}

module "manager" {
  source  = "github.com/ohyou/terraform-selectel/modules/instance"
  cloud   = "${local.cloud}"
  name    = "manager"
  keypair = "${module.keypair.name}"

  lan {
    uuid    = "${module.network.lan["uuid"]}"
    address = "${module.network.lan["gateway"]}"
  }

  wan {
    uuid = "${module.network.wan["uuid"]}"
  }

  flavor {
    cpu = 2
    ram = 2048
  }

  disk {
    size  = 10
    type  = "fast"
    image = "Fedora 28 64-bit"
  }
}

resource "null_resource" "manager-init" {
  depends_on = ["module.manager"]

  connection {
    host        = "${lookup(module.manager.instance[0], "wan")}"
    private_key = "${module.keypair.private}"
  }

  provisioner "file" {
    source      = "../../scripts/install_docker.sh"
    destination = "/tmp/install_docker.sh"
  }

  provisioner "file" {
    source      = "../../scripts/fetch_project.sh"
    destination = "/tmp/fetch_project.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_docker.sh",
      "chmod +x /tmp/fetch_project.sh",
      "/tmp/install_docker.sh",
      "/tmp/fetch_project.sh ${local.project_name}"
    ]
  }
}

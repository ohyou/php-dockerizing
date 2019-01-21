variable "modules" {
  default {
    keypair  = "github.com/kodix/terraform-selectel/modules/keypair"
    network  = "github.com/kodix/terraform-selectel/modules/network"
    instance = "github.com/kodix/terraform-selectel/modules/instance"
  }
}

variable "ssh" {
  default {
    file = "${file("~/.ssh/id_rsa")}"
  }
}

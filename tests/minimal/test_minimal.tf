terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    nxos = {
      source  = "netascode/nxos"
      version = ">=0.1.0"
    }
  }
}

module "main" {
  source = "../.."

  id = "eth1/10"
}

data "nxos_rest" "l1PhysIf" {
  dn = "sys/intf/phys-[eth1/10]"

  depends_on = [module.main]
}

resource "test_assertions" "l1PhysIf" {
  component = "l1PhysIf"

  equal "id" {
    description = "id"
    got         = data.nxos_rest.l1PhysIf.content.id
    want        = "eth1/10"
  }
}

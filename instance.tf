data "ibm_resource_group" "group" {
    name = "sh-rg"
}

data "ibm_is_image" "image" {
    name = var.image
}

resource "ibm_is_vpc" "example" {
  name = "example-vpc"
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_subnet" "example" {
  name            = "example-subnet"
  vpc             = ibm_is_vpc.example.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
  resource_group = data.ibm_resource_group.group.id
}

data "ibm_is_ssh_key" "example" {
  name = "sh-ssh-key"
}

resource "ibm_is_instance" "example" {
  name = "example-instance"
  image = data.ibm_is_image.image.id
  keys = [data.ibm_is_ssh_key.example.id]
  # keys = [ibm_is_ssh_key.example.id]
  profile = "bx2-2x8"
  vpc = ibm_is_vpc.example.id
  zone = "us-south-1"
  resource_group = data.ibm_resource_group.group.id
  primary_network_interface {
    subnet = ibm_is_subnet.example.id
    security_groups = [ibm_is_security_group.example.id]
  }
}

resource "ibm_is_floating_ip" "example" {
  name   = "example-floating-ip"
  target = ibm_is_instance.example.primary_network_interface[0].id
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_security_group" "example" {
  name = "example-security-group"
  vpc  = ibm_is_vpc.example.id
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_security_group_rule" "example1" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "example2" {
  group     = ibm_is_security_group.example.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "example3" {
  group     = ibm_is_security_group.example.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_security_group_rule" "example4" {
  group     = ibm_is_security_group.example.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "example5" {
  group     = ibm_is_security_group.example.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 533
    port_max = 533
  }
}

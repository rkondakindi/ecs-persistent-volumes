
# Subnet ID 
data "aws_subnet" "selected" {
  count = length(var.subnets)
  id    = element(var.subnets, count.index)
}

locals {
 availability_zones = data.aws_subnet.selected.*.availability_zone
}

output "azs" {
  value = join(",", local.availability_zones)
}


variable "subnets" {
  default = ["subnet-00b24048", "subnet-6093904d", "subnet-6deeab08"]
}

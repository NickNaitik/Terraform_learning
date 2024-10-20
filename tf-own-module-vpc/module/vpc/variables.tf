variable "vpc_config" {
    description = "To get the CIDR and Name of VPC from user"
    type = object({
      cidr_block = string
      name       = string
    })

    validation {
      condition = can(cidrnetmask(var.vpc_config.cidr_block))
      error_message = "Invalid CIDR format - ${var.vpc_config.cidr_block}"
    }
}

variable "subnet_config" {

    description = "Fet the CIDR and AZ for the subnets"
    type = map(object({
      cidr_block = string
      az         = string 
    }))

    validation {
      condition = alltrue([for config in var.subnet_config: can(cidrnetmask(config.cidr_block))]) // [true, true, true]
      error_message = "Invalid CIDR format of subnet"
    }
  
}
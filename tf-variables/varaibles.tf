variable "region" {
    description = "Value of region"
    type = string
    default = "ap-south-1" //default dalne ke baad nhi puchta hai console me but we can override it by setting in variable or tfvars file
}

variable "instance_type" {
    description = "Instance Type"
    type = string

    validation {
      condition = var.instance_type=="t2.micro" || var.instance_type=="t3.micro"
      error_message = "This instance type is not allowed!"
    }
    # default = "t3.micro"
  
}

# variable "root_volume_size" {
#     description = "Volume_Size"
#     type = number
#     # default = "t3.micro"
# }

# variable "root_vol_type" {
#     description = "Volume type"
#     type = string
#     default = "gp2"
  
# }

//combining similar type of variable 
variable "ec2_config" {
  type =object({
    v_size = number
    v_type = string
  })

  default = {
    v_size = 10
    v_type = "gp2"
  }
}

variable "additional_tags" {
    type = map(string)
    default = {}
}
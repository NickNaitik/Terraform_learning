//No need of provider here.
terraform {}

#Number list

variable "num_list" {
    type =list(number)
    default = [ 1,2,3,4,5 ]
}

#Object list of person
variable "persion_list" {

    type = list(object({
      f_name = string
      l_name =string
    }))

    default = [ {
      f_name = "Nick"
      l_name = "Naitik"
    } ,
    {
        f_name = "Nick"
        l_name = "Kumar"
    }]
  
}

variable "map_list" {
    type = map(number)
    default = {
      "one" = 1
      "two" = 2
      "three" =3
    }
  
}

#Calculations or operations

locals {
  mul = 2*2
  add = 2+2
  eq = 2 != 3

  #double the list 
  double = [for num in var.num_list: num*2]

  #odd no only
  odd = [for num in var.num_list: num if num%2 != 0]

  #To get only f_name from person list
  f_name_list = [for p in var.persion_list : p.f_name]

  #Work with map - Get Keys
  num_list_key = [for key, value in var.map_list: key]

  #Work with map - multiply value by 5
  num_list_five_times_value = [for key, value in var.map_list: value*5]

  #Work with map - double the values and generate new map with new value
  double_map = { for key, value in var.map_list : key => value*2 }


}

output "output" {
    //value = local.mul
    //value = var.num_list
    //value = local.double
    //value = local.odd
    //value = local.f_name_list
    //value = local.num_list_key
    //value = local.num_list_five_times_value
    value = local.double_map
}

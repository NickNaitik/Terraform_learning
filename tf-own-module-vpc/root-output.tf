output "vpc" {
    description ="Any description"
    value = module.vpc.vpc_id
}

output "public_subnet" {
    description ="Any description"
    value = module.vpc.public_subnets
}

output "private_subnet" {
    description ="Any description"
    value = module.vpc.private_subnets
}
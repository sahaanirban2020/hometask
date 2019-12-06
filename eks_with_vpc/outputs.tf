data "aws_subnet_ids" "public" {
    vpc_id = aws_vpc.hometask.id
    depends_on = [ aws_subnet.pub1, aws_subnet.pub2, aws_subnet.pub3 ]

    tags = {
        Scope = "Public"
    }
}

output "public_subnet_ids" {
  value = data.aws_subnet_ids.public.ids
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "albingcontroller" {
  value = local.albingcontroller
}

output "alb_ing_rbac" {
  value = local.alb_ing_rbac
}

output "tiller_svc_acct" {
  value = local.tiller_svc_acct
}

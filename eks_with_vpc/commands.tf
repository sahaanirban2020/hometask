resource "null_resource" "cluster" {
    depends_on = [
        aws_eks_cluster.cluster,
        aws_autoscaling_group.workerNodes
    ]

    triggers = {
        always_run = "${timestamp()}"
    }

    provisioner "local-exec" {
        command     = "/usr/bin/terraform output kubeconfig > /opt/kubeconfig"
    }

    provisioner "local-exec" {
        command     = "/usr/bin/terraform output config_map_aws_auth > /opt/config_map_aws_auth.yaml"
    }

    provisioner "local-exec" {
        command     = "/usr/bin/terraform output albingcontroller > /opt/albingcontroller.yaml"
    }

    provisioner "local-exec" {
        command     = "/usr/bin/terraform output alb_ing_rbac > /opt/alb_ing_rbac.yaml"
    }

    provisioner "local-exec" {
        command     = "/usr/bin/terraform output tiller_svc_acct > /opt/tiller_svc_acct.yaml"
    }
}

resource "null_resource" "config-update" {
    depends_on = [
        null_resource.cluster
    ]

    triggers = {
        always_run = "${timestamp()}"
    }

    provisioner "local-exec" {
        command     = "/usr/bin/kubectl apply -f /opt/config_map_aws_auth.yaml"
        environment = {
            KUBECONFIG = "/opt/kubeconfig"
        }
    }

    provisioner "local-exec" {
        command     = "/usr/bin/kubectl apply -f /opt/albingcontroller.yaml"
        environment = {
            KUBECONFIG = "/opt/kubeconfig"
        }
    }

    provisioner "local-exec" {
        command     = "/usr/bin/kubectl apply -f /opt/alb_ing_rbac.yaml"
        environment = {
            KUBECONFIG = "/opt/kubeconfig"
        }
    }

    provisioner "local-exec" {
        command     = "/usr/bin/kubectl apply -f /opt/tiller_svc_acct.yaml"
        environment = {
            KUBECONFIG = "/opt/kubeconfig"
        }
    }

    provisioner "local-exec" {
        command     = "/usr/local/bin/helm init --service-account tiller"
        environment = {
            KUBECONFIG = "/opt/kubeconfig"
        }
    }
}

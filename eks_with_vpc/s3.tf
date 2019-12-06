resource "aws_s3_bucket" "spinnaker-bucket" {
    bucket        = format("%s-%s", lookup(var.vpc, "name"), "spinnaker")
    acl           = "private"
    force_destroy = true

    tags = {
          Name       = format("%s-%s", lookup(var.vpc, "name"), "spinnaker")
    }
}

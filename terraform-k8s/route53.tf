data "aws_route53_zone" "selected" {
  name = "academichub.net."
}

resource "aws_route53_record" "golang-deployment-task" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "golang.academichub.net"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }

  allow_overwrite = true
}
# vim:ts=2:sw=2:et

resource "aws_acm_certificate" "crt" {
  domain_name               = var.crt_hostnames[0]
  subject_alternative_names = [ for h in var.crt_hostnames: h if h != var.crt_hostnames[0] ]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_route53_record" "crt-validation" {
  for_each = {
    for dvo in aws_acm_certificate.crt.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [ each.value.record ]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "crt-validation" {
  certificate_arn         = aws_acm_certificate.crt.arn
  validation_record_fqdns = [ for record in aws_route53_record.crt-validation : record.fqdn ]
}

output "crt" {
  value = aws_acm_certificate.crt
}


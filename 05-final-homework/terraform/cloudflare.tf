resource "cloudflare_record" "cname" {
  zone_id         = var.zone
  name            = var.domain
  value           = aws_alb.external_alb.dns_name
  type            = "CNAME"
  proxied         = true
  allow_overwrite = true
}

resource "cloudflare_record" "cname_green" {
  count           = var.enable_green_cloudflare ? 1 : 0
  zone_id         = var.zone
  name            = var.domain
  value           = aws_alb.external_alb_green.dns_name
  type            = "CNAME"
  proxied         = true
  allow_overwrite = true
}

resource "cloudflare_record" "cname_blue" {
  count           = var.enable_blue_cloudflare ? 1 : 0
  zone_id         = var.zone
  name            = var.domain
  value           = aws_alb.external_alb_green.dns_name
  type            = "CNAME"
  proxied         = true
  allow_overwrite = true
}
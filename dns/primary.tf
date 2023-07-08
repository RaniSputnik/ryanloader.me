resource "aws_route53_zone" "primary" {
  name    = var.primary_zone
  comment = "My personal website"

  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

# When creating Route 53 zones, the NS and SOA records for the zone are automatically created. 
# Enabling the allow_overwrite argument will allow managing these records in a single Terraform 
# run without the requirement for terraform import.
resource "aws_route53_record" "ns" {
  allow_overwrite = true
  name            = var.primary_zone
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.primary.zone_id
  records         = aws_route53_zone.primary.name_servers
}

# PF (Sender policy framework) is a spam protection method based on the authorization of the email sender. 
# The SPF record is simply a TXT record added to the DNS settings of your domain that defines which mail servers are authorized to send emails.
resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.primary_zone
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 include:_spf.hostedemail.com include:hover.com ~all"]
}

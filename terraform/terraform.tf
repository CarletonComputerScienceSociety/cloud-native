terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36"
    }
  }

  //   backend "s3" {
  //     bucket = "ccss-terraform"
  //     key    = "terraform/state"
  //     region = "ca-central-1"
  //   }
}

provider "aws" {
  region = "ca-central-1"
}

resource "aws_route53_zone" "discretemath_ca" {
  name = "discretemath.ca"
}

resource "aws_route53_record" "discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "discretemath.ca"
  type            = "A"
  ttl             = 300
  allow_overwrite = true

  records = ["134.117.26.170"]
}

resource "aws_route53_record" "api_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "api"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "cors_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "cors"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "dashboard_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "dashboard"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "grafana_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "grafana"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "pg_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "pg"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "portainer_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "portainer"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "puzzle_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "puzzle"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "scoreboard_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "scoreboard"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "stats_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "stats"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = ["discretemath.ca"]
}

resource "aws_route53_record" "jupyter_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "jupyter.discretemath.ca"
  type            = "A"
  ttl             = "300"
  allow_overwrite = true

  records = ["134.117.26.98"]
}

resource "aws_route53_record" "rancher_discretemath_ca_record" {
  zone_id         = aws_route53_zone.discretemath_ca.zone_id
  name            = "rancher.discretemath.ca"
  type            = "A"
  ttl             = "300"
  allow_overwrite = true

  records = ["134.117.26.98"]
}
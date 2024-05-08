# cloudront distribution with origin from s3 bucket 
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "aws-cloud-resume-terraform-cloudfront-access"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "cf_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_file.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
  aliases = ["chidiukaegbu.com"]


  default_cache_behavior {
    cached_methods = ["GET", "HEAD"]
    allowed_methods  = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      # headers = ["*"]
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    # cloudfront_default_certificate = true 
    acm_certificate_arn      = var.ssl_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

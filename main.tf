resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "jokes_website_bucket" {
  bucket        = "${var.bucket_prefix}-${random_string.bucket_suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "jokes_website_config" {
  bucket = aws_s3_bucket.jokes_website_bucket.id

  index_document {
    suffix = var.index_document
  }
  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "jokes_website_public_access" {
  bucket = aws_s3_bucket.jokes_website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "static_site_upload_object" {
  for_each     = fileset(var.html_source_dir, "*")
  bucket       = aws_s3_bucket.jokes_website_bucket.id
  key          = each.value
  source       = "${var.html_source_dir}/${each.value}"
  etag         = filemd5("${var.html_source_dir}/${each.value}")
  content_type = "text/html"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for Jokes Website"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.jokes_website_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_website_bucket_policy" {
  depends_on = [aws_s3_bucket.jokes_website_bucket, aws_s3_bucket_website_configuration.jokes_website_config]
  bucket = aws_s3_bucket.jokes_website_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_distribution" "jokes_website_distribution" {
  origin {
    domain_name = aws_s3_bucket.jokes_website_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.jokes_website_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = var.index_document

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.jokes_website_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }
}

resource "null_resource" "invalidate_html" {
  triggers = {
    index_file_hash = filemd5("${var.html_source_dir}/${var.index_document}")
    error_file_hash = filemd5("${var.html_source_dir}/${var.error_document}")
  }

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.jokes_website_distribution.id} --paths /index.html /error.html"

    environment = {
      AWS_ACCESS_KEY_ID     = var.aws_access_key_id
      AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
      AWS_DEFAULT_REGION    = var.aws_region
    }
  }

  depends_on = [aws_cloudfront_distribution.jokes_website_distribution]
}

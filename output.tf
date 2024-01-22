output "s3_bucket_url" {
  description = "The website URL of the S3 bucket"
  value       = "http://${aws_s3_bucket.jokes_website_bucket.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.jokes_website_bucket.bucket
}

output "cloudfront_distribution_domain" {
  value = aws_cloudfront_distribution.jokes_website_distribution.domain_name
}

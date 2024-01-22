variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "random-jokes"
}

variable "index_document" {
  description = "The index document of the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document of the website"
  type        = string
  default     = "error.html"
}

variable "html_source_dir" {
  description = "Directory path for HTML source files"
  type        = string
  default     = "static/html/"
}

variable "aws_access_key_id" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
}
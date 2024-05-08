# create an s3 bucket 
resource "aws_s3_bucket" "website_file" {
  bucket =  "${var.project_name}-${var.web_file_bucket_name}"
}

# s3 bucket ownership control 
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.website_file.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#s3 public access block 
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_file.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#s3 bucket acl resource 
resource "aws_s3_bucket_acl" "access-control" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.website_file.id
  acl    = "public-read"
}

#s3 bucket policy 
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_file.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["arn:aws:s3:::${var.project_name}-${var.web_file_bucket_name}/*"]
      }
    ]
  })
}

#resource to refrence my web files 
#https://registry.terraform.io/modules/hashicorp/dir/template/latest

module "template_files" {
  source   = "hashicorp/dir/template"

  base_dir = "${path.module}/web-files"
}

#website configuration resource 
resource "aws_s3_bucket_website_configuration" "web-config" {
  bucket = aws_s3_bucket.website_file.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# uploading files to amazon s3 for hosting static websites 
resource "aws_s3_object" "Bucket_files" {
  bucket =  aws_s3_bucket.website_file.id

  for_each     = module.template_files.files
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  # ETag of the S3 object
  etag = each.value.digests.md5
}

# S3 bucket CORS configuration resource
resource "aws_s3_bucket_cors_configuration" "s3_cors" {
  bucket = aws_s3_bucket.website_file.id 

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 0
  }

}


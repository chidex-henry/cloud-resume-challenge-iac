resource "aws_dynamodb_table" "resume-web-table" {
  name           = "resume-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "pk"
  range_key      = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "visit_count"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name               = "visit_count_index"
    hash_key           = "visit_count"
    range_key          = "sk"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["pk"]
  }

  tags = {
    Name        = "resume table"
    Environment = "production"
  }
}
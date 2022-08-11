resource "aws_s3_bucket" "log_bucket" {
  bucket = local.alb_log_bucket_name

  force_destroy = local.alb_log_bucket_force_destroy

  tags = local.alb_tags
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_sse_configuration" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket_lifecycle" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    id     = local.alb_log_bucket_lifecycle_id
    status = "Enabled"

    transition {
      # 標準クラスから標準IAクラスに移行
      storage_class = "STANDARD_IA"
      days = var.alb_log_transition_in_days
    }

    expiration {
      days = var.alb_log_expiration_in_days
    }
  }
}

data "aws_iam_policy_document" "log_bucket_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [
        # 東京リージョンの場合の設定
        # ほかリージョンを利用する場合は、https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/classic/enable-access-logs.html などを参照
        "arn:aws:iam::582318560864:root"
      ]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.log_bucket.arn,
      "${aws_s3_bucket.log_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.log_bucket_policy_document.json
}
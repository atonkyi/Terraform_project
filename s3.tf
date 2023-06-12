/*resource "aws_s3_bucket" "terra_backet" {
  bucket = "terrab"

  tags = {
    Name = "terra_s3"
  }

}


resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.terra_backet.id
  key    = "web.sh"
  source = "../terra_homework/web.sh"

}*/

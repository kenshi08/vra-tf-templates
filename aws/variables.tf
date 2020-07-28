variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "ap-southeast-1"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    ap-southeast-1 = "ami-6051eb03"
  }
}
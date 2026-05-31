terraform {
  backend "s3" {
    bucket = "hello-springboot-tfstate"
    key    = "aws/application"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

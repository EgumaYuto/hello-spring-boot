terraform {
  backend "s3" {
    bucket = "cabos-tfstate"
    key    = "hello-spring-boot"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region                   = "ap-northeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

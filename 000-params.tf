# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "jball_key_pair" {
  key_name   = "jball-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8c+L5Oey0TFf1mEwmDnO1aCV+iP3ge2pKUbFsmCz9O/+8+s8SdA62Fjteh0nSCb//w6WjNBbUgcbYqU9Lr9QTTBc8RDTg8xT3Hmls2UBups1qjWwTKhBB3RU3VC8kw0RcAXd2SXP5cbYMJYn3rfL+C8P9IJpsiydgScMYujC1Y/KdIXEO8ijNTgCCsfEa8dra2VHb22r7EyUtbEvPsi+kTsJVuvkC9eyPTIOskuKv3paTAL3S1IE+IETUP0R/m0YRviCjNp3kKBpVRPTujvCrC6DC76PIwev78G+UPAfBILQgE9p3B+CawatE+Tp6TE6jw8BaugpDS2EG7D5BGMopBhfa10zv94jbGpUvZm2PeUO8F+FgP5KAK9RM/VXLXofEOlP9voG3P/e7xBRmKOIj0bE27A/auJthrVkPsqb5INLnYj1AIlT+OsuK7JvRp1EPFinu9S7TnD9F5TD47paO2pUaol1YgiMgF0M1l516SKnSn6kgermPDqeHF6LkhFvPvx6/xhdrGHsOV8kP1+dvGBUaButxO+lgk9nUS8JiDRaTV34DGwE4/hHw+yYHFcUmNj8gJQkk1D+iFDdrensZQVpEkNGLkUTRevr7CrA7rKGQCXxQzPc+xim7mhUFWhCBUUe+zVv/3ERJ6BX6MsphGiogMaSENITDvCvL1eU/oQ== jonathanb@bbkf2"
}

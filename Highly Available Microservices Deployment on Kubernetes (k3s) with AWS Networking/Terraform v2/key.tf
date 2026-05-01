resource "aws_key_pair" "k3s_key" {
  key_name   = "k3s-ubuntu-key"
  public_key = file("C:/Users/Yousef/.ssh/id_ed25519.pub")
}

resource "aws_lb_target_group" "tg" {
  name     = "nlb-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.k3s_vpc.id

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }
}
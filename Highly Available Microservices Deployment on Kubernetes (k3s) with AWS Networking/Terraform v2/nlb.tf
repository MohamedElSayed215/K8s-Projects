# resource "aws_lb" "nlb" {
#   name               = "my-nlb"
#   load_balancer_type = "network"

#   subnets = [
#     aws_subnet.subnets[0].id,
#     aws_subnet.subnets[1].id,
#     aws_subnet.subnets[2].id
#   ]

#   enable_cross_zone_load_balancing = true
# }

resource "aws_lb" "nlb" {
  name               = "my-nlb"
  load_balancer_type = "network"

  subnets = [
    aws_subnet.public_subnets[0].id,
    aws_subnet.public_subnets[1].id,
    aws_subnet.public_subnets[2].id
  ]

  enable_cross_zone_load_balancing = true
}
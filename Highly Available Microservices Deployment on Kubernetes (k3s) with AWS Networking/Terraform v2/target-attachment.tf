resource "aws_lb_target_group_attachment" "t1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.workers[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "t2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.workers[1].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "t3" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.workers[2].id
  port             = 80
}
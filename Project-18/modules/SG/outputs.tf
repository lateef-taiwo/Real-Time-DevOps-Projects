output "ALB-sg" {
  value = aws_security_group.savvytek["ext-alb-sg"].id
}


output "IALB-sg" {
  value = aws_security_group.savvytek["int-alb-sg"].id
}


output "bastion-sg" {
  value = aws_security_group.savvytek["bastion-sg"].id
}


output "nginx-sg" {
  value = aws_security_group.savvytek["nginx-sg"].id
}


output "web-sg" {
  value = aws_security_group.savvytek["webserver-sg"].id
}


output "datalayer-sg" {
  value = aws_security_group.savvytek["datalayer-sg"].id
}
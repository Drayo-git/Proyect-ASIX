# Instància EC2 amb la instal·lació del wordpress
resource "aws_instance" "WordPress" {
  depends_on = [aws_internet_gateway.public_internet_gw]
  ami           = "ami-083602cee93914c0c"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.SG_public_subnet.id]
  tags = {
     Name = "WEB"
  }

  user_data = <<EOF
         #! /bin/bash
         #hacer script aqui para instalar mailserver
      EOF

 provisioner "local-exec" {
  command = "echo ${aws_instance.WordPress.public_ip} > publicIP.txt"
 }

}

# Llençant la base de dades RDS
resource "aws_db_instance" "DataBase" {
  allocated_storage    = 20
#  max_allocated_storage = 100
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.22"
  instance_class       = "db.t2.micro"
  name                 = "javieselmillor"
  username             = "javier"
  password             = "1q2w3e4R"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.SG_private_subnet_.id]
  skip_final_snapshot = true

provisioner "local-exec" {
  command = "echo ${aws_db_instance.DataBase.endpoint} > DB_host.txt"
    }

}

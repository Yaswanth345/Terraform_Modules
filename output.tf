output "subnet_name" {

    description = "Subnets Names"
    value = [aws_subnet.private_subnet.tags.Name, aws_subnet.private_subnet.id , aws_subnet.public_subnet.tags.Name, aws_subnet.public_subnet.id]
}
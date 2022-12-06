output "jenkins-master-ip" {
    value = aws_instance.jenkins-master.public_ip
}

output "jenkins-worker-ip" {
    value = {
        for instance in aws_instance.jenkins-worker :
        instance.id => instance.public_ip
    }
}
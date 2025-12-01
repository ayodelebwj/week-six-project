#============================================
#Provision Java and Python AMI Templates
#============================================

data "amazon-parameterstore" "java_ubuntu_2404" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}


source "amazon-ebs" "java-python-vm-template-root" {
  region          = "us-east-2"
  instance_type   = "t3.micro"
  ssh_username    = "ubuntu"
  source_ami    = data.amazon-parameterstore.java_ubuntu_2404.value
  ami_name        = "java-python-ami"
  #ami_description = "Amazon Linux 2 custom AMI with java and python"
}

build {
  name    = "java-python-template-build"
  sources = ["source.amazon-ebs.java-python-vm-template-root"]

  provisioner "file" {
    source      = "java.service"
    destination = "/tmp/java.service"
  }

  provisioner "file" {
    source      = "python.service"
    destination = "/tmp/python.service"
  }

  provisioner "shell" {
    inline_shebang = "/bin/bash -xe"
    inline = [
      "sudo cp /tmp/java.service /etc/systemd/system/java.service",
      "sudo cp /tmp/python.service /etc/systemd/system/python.service",
      "sudo apt update -y",
      "cd ~",
      "sudo rm -rf fruits-veg_market",
      "git clone https://github.com/techbleat/fruits-veg_market.git",
      "cd ~/fruits-veg_market/java",
      "sudo apt install openjdk-17-jdk -y",
      "sudo apt install maven -y",
      "sudo apt install python3 python3-pip -y",
      "cd ~/fruits-veg_market/python",
      "sudo apt install python3-venv -y",
      "python3 -m venv .venv",
      "source .venv/bin/activate",
      "python -m pip install -r requirements.txt",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable java.service",
      "sudo systemctl start java.service",
      "sudo systemctl enable python.service",
      "sudo systemctl start python.service",
      "exit 0"
    ]
  }
}

# 🚀 Highly Available Microservices Deployment on Kubernetes (k3s) with AWS Networking

<div align="center">

![Kubernetes](https://img.shields.io/badge/Kubernetes-k3s-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Infrastructure-Terraform-7B42BC?style=for-the-badge&logo=terraform)
![Ansible](https://img.shields.io/badge/Automation-Ansible-EE0000?style=for-the-badge&logo=ansible)
![Docker](https://img.shields.io/badge/Containers-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

<h1>Production-Grade Highly Available Kubernetes Infrastructure on AWS</h1>

<p>
A complete end-to-end DevOps project demonstrating Infrastructure as Code, Kubernetes orchestration, cloud networking, automation, and highly available microservices deployment using k3s on AWS.
</p>

</div>

---

# 📌 Project Overview

This project demonstrates how to build and deploy a **Highly Available Kubernetes Cluster** using **k3s** on **Amazon Web Services (AWS)** with complete automation.

The project focuses on real-world DevOps engineering practices including:

- Infrastructure provisioning using Terraform
- Server automation using Ansible
- Kubernetes cluster deployment using k3s
- Microservices deployment on Kubernetes
- AWS networking architecture
- Production-grade infrastructure design
- High availability and fault tolerance

This repository simulates how modern cloud-native applications are deployed in production environments.

---

# 🎯 Main Objectives

## ✅ Build Highly Available Kubernetes Infrastructure
Deploy a resilient k3s cluster capable of handling failures while maintaining service availability.

## ✅ Apply Infrastructure as Code (IaC)
Use Terraform to provision and manage cloud resources automatically.

## ✅ Automate System Configuration
Use Ansible to bootstrap and configure all nodes automatically.

## ✅ Deploy Microservices on Kubernetes
Containerize and orchestrate services using Kubernetes manifests.

## ✅ Design Production Networking
Build secure AWS networking architecture using VPCs, subnets, and security groups.

---

# 🏗️ High Level Architecture

```text
![](https://github.com/MohamedElSayed215/K8s-Projects/blob/main/Highly%20Available%20Cloud%20Microservices%20Platform/project_arch.jpg)



                            Development
                                 │
              ┌──────────────────┴──────────────────┐
              │                                     │
              ▼                                     ▼
     ┌────────────────┐                  ┌────────────────┐
     │   Terraform    │                  │    Ansible     │
     │ Infrastructure │                  │ Configuration  │
     └───────┬────────┘                  └───────┬────────┘
             │                                   │
             └────────────────┬──────────────────┘
                              ▼
                 ┌────────────────────────┐
                 │        AWS VPC         │
                 └──────────┬─────────────┘
                            │
      ┌─────────────────────┼─────────────────────┐
      │                     │                     │
      ▼                     ▼                     ▼
┌────────────┐      ┌────────────┐       ┌────────────┐
│ k3s Master │      │ k3s Master │       │ k3s Master │
│    Node    │      │    Node    │       │    Node    │
└─────┬──────┘      └─────┬──────┘       └─────┬──────┘
      │                   │                    │
      └───────────────────┼────────────────────┘
                          │
                          ▼
               ┌─────────────────────┐
               │    Worker Nodes     │
               └─────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │    Microservices     │
              │  Running on k3s      │
              └──────────────────────┘
```

---

# ☁️ AWS Infrastructure Architecture

The infrastructure is designed using AWS best practices.

## Components

### 🌐 Networking Layer

- Custom VPC
- Public Subnets
- Private Subnets
- Route Tables
- Internet Gateway
- NAT Gateway
- Elastic IPs
- Security Groups

### 🖥️ Compute Layer

- EC2 Instances
- Multiple Master Nodes
- Multiple Worker Nodes
- Ubuntu Linux Servers

### 🔐 Security Layer

- SSH Key Authentication
- Controlled Ingress Rules
- Internal Cluster Communication
- Secure API Access

### ⚙️ Automation Layer

- Terraform Modules
- Ansible Roles

---

# 📦 Tech Stack

| Category | Technology |
|---|---|
| Cloud Provider | AWS |
| Container Orchestration | Kubernetes (k3s) |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| Containers | Docker |
| Operating System | Ubuntu Linux |
| Networking | AWS VPC |
| Version Control | Git & GitHub |
| Automation | Bash Scripts |

---

# ⚡ Why k3s?

k3s is a lightweight Kubernetes distribution designed for:

- Edge Computing
- IoT
- Lightweight Clusters
- Development & Production Environments
- Resource-efficient Kubernetes deployments

## Benefits of k3s

✅ Lightweight

✅ Easy Installation

✅ Fast Cluster Bootstrap

✅ Lower Resource Consumption

✅ CNCF Certified Kubernetes

✅ Production Ready

---

# 🔥 Project Features

# ✅ Highly Available Cluster

- Multi-master architecture
- Worker node scaling
- Fault-tolerant design
- Distributed workloads

# ✅ Infrastructure as Code

- Fully automated AWS provisioning
- Modular Terraform structure
- Reusable infrastructure modules

# ✅ Automated Configuration Management

- Automated OS setup
- Automated k3s installation
- Automated cluster join process
- Inventory management

# ✅ Kubernetes Deployment

- Deployments
- Services
- ConfigMaps
- Secrets
- HPA

# ✅ Production Networking

- Segmented networking
- Secure traffic flow
- Public/private architecture
- Controlled communication

---

# 📂 Repository Structure

```bash

├── ansible
│   ├── ansible.cfg
│   ├── aws_ec2.yml
│   ├── dynamic-inventory.ini
│   ├── generate-dynamic-inventory.yml
│   ├── roles
│   │   └── k3s
│   │       ├── README.md
│   │       ├── defaults
│   │       │   └── main.yml
│   │       ├── files
│   │       ├── handlers
│   │       │   └── main.yml
│   │       ├── meta
│   │       │   └── main.yml
│   │       ├── tasks
│   │       │   ├── copy_project.yml
│   │       │   ├── hostname.yml
│   │       │   ├── init_master.yml
│   │       │   ├── join_master.yml
│   │       │   ├── join_worker.yml
│   │       │   ├── label_workers.yml
│   │       │   ├── main.yml
│   │       │   └── run_project.yml
│   │       ├── templates
│   │       ├── tests
│   │       │   ├── inventory
│   │       │   └── test.yml
│   │       └── vars
│   │           └── main.yml
│   └── site.yml
├── crm-app
│   └── k8s
│       ├── configmap-template.yaml
│       ├── configmap.yaml
│       ├── crm-schema-file.yaml
│       ├── deployment.yaml
│       ├── hpa.yaml
│       ├── init-db.yaml
│       ├── schema
│       │   └── schema.sql
│       ├── secret.yaml
│       └── service.yaml
├── terraform
│   ├── aws-setup
│   ├── inventory.ini
│   ├── main.tf
│   ├── modules
│   │   ├── ansible
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   ├── compute
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── nlb
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── rds
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── security_groups
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── terraform.tfstate
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf

```

---

# 🧠 Infrastructure Workflow

```text
1. Terraform provisions AWS infrastructure
                ↓
2. EC2 instances are created
                ↓
3. Ansible configures all servers
                ↓
4. k3s cluster is bootstrapped
                ↓
5. Worker nodes join cluster
                ↓
6. Kubernetes manifests are deployed
                ↓
7. Microservices become available
```

---

# 🌍 AWS Networking Design

## VPC Design

The project uses a custom AWS VPC architecture.

## Public Subnets

Used for:

- Bastion access
- Public-facing services
- Load balancers

## Private Subnets

Used for:

- Internal Kubernetes nodes
- Databases
- Backend services

## Security Groups

Configured to allow:

- SSH access
- Kubernetes API communication
- Internal cluster networking
- Service-to-service communication

---

# 🖥️ Kubernetes Cluster Design

## Master Nodes

Responsible for:

- Kubernetes API Server
- Scheduler
- Controller Manager
- Cluster State Management

## Worker Nodes

Responsible for:

- Running application workloads
- Hosting microservices containers
- Processing traffic

---

# 📌 Kubernetes Resources Used

| Resource | Purpose |
|---|---|
| Deployment | Manage pods |
| Service | Internal networking |
| Ingress | External access |
| ConfigMap | Configuration management |
| Secret | Sensitive data storage |
| Namespace | Resource isolation |
| Persistent Volume | Storage management |

---

text

Terraform Apply
   ↓
Ansible Execution
   ↓
kubectl Apply
   ↓
Deployment Completed
```

---

# 🛠️ Prerequisites

Before running this project, ensure you have:

## Required Tools

- AWS Account
- Terraform
- Ansible
- kubectl
- Docker
- Git
- SSH Key Pair

## Recommended Knowledge

- Linux basics
- Kubernetes basics
- AWS fundamentals
- Networking concepts
- DevOps workflows

---

# 🚀 Getting Started

# 1️⃣ Clone Repository

```bash
git clone https://github.com/MohamedElSayed215/K8s-Projects.git

cd "Highly Available Microservices Deployment on Kubernetes (k3s) with AWS Networking"
```

---

# 2️⃣ Configure AWS Credentials

```bash
aws configure
```

---

# 3️⃣ Initialize Terraform

```bash
cd terraform
terraform init
```

---

# 4️⃣ Review Terraform Plan

```bash
terraform plan
```

---

# 5️⃣ Apply Infrastructure

```bash
terraform apply -auto-approve
```

---

# 6️⃣ Configure Servers Using Ansible

```bash
cd ../ansible
ansible-playbook playbooks/site.yml
```

---

# 7️⃣ Verify Cluster

```bash
kubectl get nodes
```

---

# 8️⃣ Deploy Kubernetes Resources

```bash
kubectl apply -f k8s/
```

---

# 🔍 Verification Commands

## Check Nodes

```bash
kubectl get nodes -o wide
```

## Check Pods

```bash
kubectl get pods -A
```

## Check Services

```bash
kubectl get svc -A
```

## Check Ingress

```bash
kubectl get ingress -A
```

---

# 📊 Scalability

This architecture supports:

- Horizontal scaling
- Additional worker nodes
- Additional microservices
- Load balancing
- Future monitoring integrations

---

# 🔐 Security Considerations

## Security Practices Implemented

- SSH key authentication
- Security group restrictions
- Private subnet isolation
- Controlled API exposure
- Least privilege access

## Future Security Enhancements

- IAM Roles
- Secrets Manager
- Network Policies
- RBAC

---

# 📈 Monitoring & Observability (Future Enhancements)

Potential integrations:

- Prometheus
- Grafana
- Loki
- ELK Stack
- Jaeger
- AlertManager

---

# 🧩 Future Improvements

## Kubernetes Enhancements

- Helm Charts
- ArgoCD
- GitOps workflows
- Service Mesh
- Operators

## Infrastructure Enhancements

- Auto Scaling Groups
- Multi-region deployment
- Managed Kubernetes
- Infrastructure testing

## Security Enhancements

- WAF integration
- IAM hardening
- TLS everywhere
- Secret rotation

---

# 🧠 What I Learned

This project provided practical experience in:

- Kubernetes architecture
- High availability systems
- AWS cloud infrastructure
- Infrastructure as Code
- Configuration management
- Cloud networking
- Distributed systems
- DevOps engineering
- Production deployment workflows

---

# 💡 Real-World DevOps Concepts Demonstrated

✅ Infrastructure as Code (IaC)

✅ Kubernetes Orchestration

✅ Cloud Automation

✅ Highly Available Systems

✅ Microservices Deployment

✅ Distributed Infrastructure

✅ Cloud Networking

✅ Automation Engineering

---

# 📚 Learning Outcomes

Through this project, you can understand:

- How Kubernetes clusters work
- How cloud networking is designed
- How Terraform provisions infrastructure
- How Ansible automates configuration
- How CI/CD pipelines operate
- How microservices are deployed
- How production infrastructure is structured

---

# 🧪 Example Useful Commands

## Kubernetes

```bash
kubectl get all
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

## Terraform

```bash
terraform fmt
terraform validate
terraform destroy
```

## Ansible

```bash
ansible all -m ping
ansible-playbook site.yml
```

---

# 📸 Suggested Screenshots For README

You can add screenshots for:

- AWS Console
- EC2 Instances
- Terraform Apply Output
- Ansible Playbook Execution
- kubectl get nodes
- Kubernetes Dashboard

---

# 🤝 Contributing

Contributions are welcome.

If you'd like to improve this project:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to your branch
5. Open a Pull Request

---

# ⭐ Support

If you found this project useful:

⭐ Star the repository

🍴 Fork the project

🛠️ Contribute improvements

📢 Share with others

---

# 👨‍💻 Author

# Mohamed Elsayed

DevOps & Cloud Engineer passionate about:

- Kubernetes
- Cloud Infrastructure
- Automation
- Linux
- Distributed Systems
- Infrastructure Engineering

---

# 🔗 Repository Link

```text
https://github.com/MohamedElSayed215/K8s-Projects
```


---

<div align="center">

# 🚀 Thank You For Visiting This Project

### If you like this repository, don't forget to leave a ⭐

</div>



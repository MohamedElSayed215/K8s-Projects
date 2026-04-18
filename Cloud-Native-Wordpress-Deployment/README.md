# WordPress on Kubernetes with AWS Storage

Deploy a production-ready WordPress site backed by MySQL on a Kubernetes cluster, using **AWS EBS** for database persistence and **AWS EFS** for WordPress shared file storage. External traffic is routed through an **AWS LoadBalancer**.

---

## Architecture Overview

```
AWS LoadBalancer
       │
       ▼
┌──────────────────────────────────────────────────────┐
│                  Kubernetes Cluster                   │
│                                                       │
│  ┌────────────────────────────────────────────────┐  │
│  │                 Default Namespace               │  │
│  │                                                 │  │
│  │  mysql-secret ──► mysql-deploy ◄── mysql-svc   │  │
│  │                        │                        │  │
│  │                   sc ──► pvc                    │  │
│  │                        │                        │  │
│  │                 AWS EBS (auto PV)               │  │
│  │                                                 │  │
│  │  wp-svc ──► wp-deploy                           │  │
│  │                  │                              │  │
│  │             sc ──► pvc                          │  │
│  │                  │                              │  │
│  │           AWS EFS (auto PV)                     │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

> 📸 _Add architecture diagram screenshot here_

---

## Prerequisites

- AWS account with permissions for VPC, EKS, EBS, and EFS
- AWS CLI installed and configured (`aws configure`)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- `kubectl` installed
- AWS EBS CSI driver and EFS CSI driver installed on the cluster

---

## Project Structure

```
.
├── terraform/
│   ├── main.tf                    # Root module — calls VPC & EKS modules
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Cluster endpoint, kubeconfig, etc.
│   ├── terraform.tfvars           # Your environment values
│   ├── modules/
│   │   ├── vpc/
│   │   │   ├── main.tf            # VPC, subnets, IGW, route tables
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── eks/
│   │       ├── main.tf            # EKS cluster, node group, OIDC
│   │       ├── variables.tf
│   │       └── outputs.tf
│
├── mysql-secret.yaml              # DB credentials (base64 encoded)
├── mysql-deployment.yaml          # MySQL Deployment
├── mysql-service.yaml             # ClusterIP Service
├── mysql-storageclass.yaml        # StorageClass → AWS EBS (dynamic)
├── mysql-pvc.yaml                 # PVC — PV auto-provisioned by AWS
├── wordpress-deployment.yaml      # WordPress Deployment
├── wordpress-service.yaml         # LoadBalancer Service
├── wordpress-storageclass.yaml    # StorageClass → AWS EFS (dynamic)
├── wordpress-pvc.yaml             # PVC — PV auto-provisioned by AWS
└── README.md
```

---

## Infrastructure Provisioning (Terraform)

Before deploying any Kubernetes resources, the AWS infrastructure is provisioned using Terraform with two modules: **vpc** and **eks**.

### Terraform Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured (`aws configure`)
- IAM user/role with permissions to create VPC, EKS, EC2, and IAM resources

### Module: `vpc`

Provisions the network layer:

- VPC with custom CIDR
- Public & private subnets across multiple AZs
- Internet Gateway + NAT Gateway
- Route tables

### Module: `eks`

Provisions the Kubernetes cluster:

- EKS Control Plane
- Managed Node Group (EC2 worker nodes)
- OIDC provider (required for IAM Roles for Service Accounts)
- Security groups for node-to-node and node-to-control-plane communication

### Steps

```bash
cd terraform/

# 1. Initialize — download providers and modules
terraform init

# 2. Preview what will be created
terraform plan -var-file="terraform.tfvars"

# 3. Provision the infrastructure
terraform apply -var-file="terraform.tfvars"
```

> 📸 _Add screenshot of `terraform apply` output here_

### Connect kubectl to the cluster

Once `terraform apply` completes, configure `kubectl` to talk to the new cluster:

```bash
aws eks update-kubeconfig \
  --region <your-region> \
  --name <cluster-name>

# Verify connection
kubectl get nodes
```

> 📸 _Add screenshot of `kubectl get nodes` output here_

---

## Deployment

### 1. Deploy MySQL

```bash
# Create the secret first (contains DB credentials)
kubectl apply -f mysql-secret.yaml

# Create storage (PV will be auto-provisioned by AWS)
kubectl apply -f mysql-storageclass.yaml
kubectl apply -f mysql-pvc.yaml

# Deploy MySQL and expose it internally
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
```

### 2. Deploy WordPress

```bash
# Create storage (PV will be auto-provisioned by AWS)
kubectl apply -f wordpress-storageclass.yaml
kubectl apply -f wordpress-pvc.yaml

# Deploy WordPress and expose it via LoadBalancer
kubectl apply -f wordpress-deployment.yaml
kubectl apply -f wordpress-service.yaml
```

### 3. Verify Everything is Running

```bash
kubectl get pods
kubectl get svc
kubectl get pvc
kubectl get pv   # PVs are auto-created — no manual definition needed
```

Expected output:

```
NAME                         READY   STATUS    RESTARTS
mysql-xxxxxxx                1/1     Running   0
wordpress-xxxxxxx            1/1     Running   0
```

---

## Kubernetes Resources

### MySQL Secret

Stores base64-encoded database credentials consumed by the MySQL deployment.

> 📸 _Add screenshot of `kubectl describe secret mysql-secret` here_

### MySQL Deployment

Runs a single MySQL instance. Reads credentials from the secret and mounts the EBS-backed PVC at `/var/lib/mysql`.

> 📸 _Add screenshot of `kubectl describe deployment mysql` here_

### MySQL Service (`ClusterIP`)

Exposes MySQL **only within the cluster** — WordPress connects to it using the service DNS name (`mysql-service`).

### WordPress Deployment

Runs WordPress and connects to MySQL using the secret credentials. Mounts the EFS-backed PVC at `/var/www/html` so uploaded media persists across pod restarts and scales across replicas.

> 📸 _Add screenshot of `kubectl describe deployment wordpress` here_

### WordPress Service (`LoadBalancer`)

Provisions an **AWS LoadBalancer** and exposes WordPress publicly on port 80.

```bash
# Get the external LoadBalancer URL
kubectl get svc wordpress-service
```

> 📸 _Add screenshot of the running WordPress site in browser here_

---

## Storage

| Component | Storage Type | AWS Service | Mount Path          | Purpose                     | Provisioning |
|-----------|-------------|-------------|---------------------|-----------------------------|--------------|
| MySQL     | Block        | AWS EBS     | `/var/lib/mysql`    | Database files              | Dynamic ✅   |
| WordPress | File         | AWS EFS     | `/var/www/html`     | Themes, plugins, uploads    | Dynamic ✅   |

**Why EBS for MySQL?** Block storage gives MySQL the low-latency random I/O it needs.

**Why EFS for WordPress?** Shared file storage lets multiple WordPress pods read and write the same files simultaneously — needed for horizontal scaling.

**Dynamic Provisioning** means no manual `PersistentVolume` definitions. When a `PVC` is created, Kubernetes automatically calls the AWS CSI driver to provision the actual EBS volume or EFS access point and binds it — fully hands-off.

---

## Configuration Reference

### Secret values (`mysql-secret.yaml`)

| Key                 | Description              |
|---------------------|--------------------------|
| `MYSQL_ROOT_PASSWORD` | MySQL root password    |
| `MYSQL_DATABASE`    | Database name            |
| `MYSQL_USER`        | Application DB user      |
| `MYSQL_PASSWORD`    | Application DB password  |

> ⚠️ **Never commit plain-text secrets to Git.** Use `base64` encoding or a secrets manager like AWS Secrets Manager or Sealed Secrets.

```bash
# Encode a value for use in a secret
echo -n "your-password" | base64
```

---

## Cleanup

Remove all resources when done:

### Kubernetes resources

```bash
kubectl delete -f wordpress-deployment.yaml -f wordpress-service.yaml \
               -f wordpress-pvc.yaml -f wordpress-storageclass.yaml
kubectl delete -f mysql-deployment.yaml -f mysql-service.yaml \
               -f mysql-pvc.yaml -f mysql-storageclass.yaml -f mysql-secret.yaml
# Note: dynamically provisioned PVs are deleted automatically
# when their PVCs are deleted (reclaimPolicy: Delete)
```

### AWS Infrastructure

```bash
cd terraform/
terraform destroy -var-file="terraform.tfvars"
```

> ⚠️ `terraform destroy` will delete the EKS cluster and VPC. Make sure all Kubernetes resources are removed first to avoid orphaned AWS resources (load balancers, volumes).

---

## Troubleshooting

**Pod stuck in `Pending`**
```bash
kubectl describe pod <pod-name>
# Usually a PVC not bound — check your StorageClass and PV
```

**WordPress can't connect to MySQL**
```bash
kubectl logs <wordpress-pod-name>
# Verify the service name matches what WordPress is configured to use
```

**LoadBalancer has no external IP**
```bash
kubectl describe svc wordpress-service
# May take 1-2 minutes for AWS to provision the LB
```

---


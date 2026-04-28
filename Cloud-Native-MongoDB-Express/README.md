# MongoDB + Mongo Express on Kubernetes (AWS EBS)

A production-ready Kubernetes setup that deploys a MongoDB StatefulSet with persistent AWS EBS storage, paired with a Mongo Express web UI for database management.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Kubernetes Cluster                       │
│                                                                 │
│  ┌──────────────┐     ┌──────────────────────────────────────┐  │
│  │   StorageClass│────▶│  StatefulSet: mongodb (1 replica)   │  │
│  │   (EBS CSI)  │     │  ┌─────────────────────────────────┐ │  │
│  └──────────────┘     │  │  PVC ──▶ EBS Volume (8Gi RWO)   │ │  │
│                        │  └─────────────────────────────────┘ │  │
│  ┌──────────────┐     │  Env: MONGO_INITDB_ROOT_*            │  │
│  │mongodb-secret│────▶│        (from mongodb-secret)         │  │
│  └──────────────┘     └──────────────┬───────────────────────┘  │
│                                       │                          │
│                              ┌────────▼────────┐                │
│                              │  Service: mongodb-svc             │
│                              │  (Headless / ClusterIP: None)    │
│                              │  Port: 27017                     │
│                              └────────┬────────┘                │
│                                       │                          │
│  ┌──────────────┐     ┌──────────────▼───────────────────────┐  │
│  │mongodb-secret│────▶│  Deployment: mongoexpress (3 replicas)│  │
│  ├──────────────┤     │  Image: mongo-express                 │  │
│  │mongo-express-│────▶│  Port: 8081                           │  │
│  │   secrets    │     │  Env: ME_CONFIG_MONGODB_SERVER        │  │
│  ├──────────────┤     │        (from mongo-cm ConfigMap)      │  │
│  │  mongo-cm    │────▶│                                       │  │
│  │ (ConfigMap)  │     └──────────────┬────────────────────────┘  │
│  └──────────────┘                    │                           │
│                              ┌───────▼────────┐                 │
│                              │ Service: mongoexpress-svc        │
│                              │ Type: LoadBalancer               │
│                              │ Port: 8081 ──▶ NodePort: 30003  │
│                              └───────┬────────┘                 │
└──────────────────────────────────────┼─────────────────────────┘
                                       │
                                  🌐 Browser
                          http://<EXTERNAL-IP>:8081
```

---

## Project Structure

```
.
├── mongodb-sc.yaml             # StorageClass — AWS EBS CSI provisioner
├── mongodb-secret.yaml         # Secret — MongoDB root credentials
├── mongodb-sts.yaml            # StatefulSet — MongoDB database
├── mongodb-svc.yaml            # Service — Headless service for MongoDB
├── mongo-cm.yaml               # ConfigMap — MongoDB hostname for Mongo Express
├── mongo-express-secrets.yaml  # Secret — Mongo Express web UI credentials
├── mongoexpress-deploy.yaml    # Deployment — Mongo Express UI (3 replicas)
└── mongoexpress-svc.yaml       # Service — LoadBalancer for Mongo Express
```

---

## Prerequisites

- A running Kubernetes cluster on **AWS EKS** (or any cluster with the AWS EBS CSI driver installed)
- `kubectl` configured to point at your cluster
- The **AWS EBS CSI Driver** add-on enabled on your cluster

---

## Resource Breakdown

### 1. StorageClass (`mongodb-sc.yaml`)
Provisions AWS EBS volumes dynamically for MongoDB data persistence.

| Field | Value |
|---|---|
| Provisioner | `ebs.csi.aws.com` |
| Reclaim Policy | `Delete` |
| Volume Binding Mode | `WaitForFirstConsumer` |

> `WaitForFirstConsumer` ensures the EBS volume is created in the same Availability Zone as the scheduled pod, preventing cross-AZ mount failures.

---

### 2. MongoDB Secret (`mongodb-secret.yaml`)
Stores Base64-encoded credentials used by both MongoDB and Mongo Express.

| Key | Decoded Value |
|---|---|
| `DB_USERNAME` | `mohamed` |
| `DB_PASSWORD` | `123` |

> ⚠️ **Important:** Change these credentials before deploying to any non-development environment.

---

### 3. MongoDB StatefulSet (`mongodb-sts.yaml`)
Runs a single MongoDB replica with a persistent EBS-backed volume.

| Field | Value |
|---|---|
| Replicas | 1 |
| Image | `mongo` (latest) |
| Container Port | `27017` |
| Volume Mount | `/data/db` |
| Storage Request | `8Gi` |
| Access Mode | `ReadWriteOnce` |
| Storage Class | `local-path` *(see note below)* |

> 📝 **Note:** The `volumeClaimTemplates` currently reference `storageClassName: "local-path"`. To use the AWS EBS StorageClass defined in `mongodb-sc.yaml`, update this value to `"mongodb-sc"`.

---

### 4. MongoDB Service (`mongodb-svc.yaml`)
A **headless service** (`clusterIP: None`) that provides stable DNS for the StatefulSet pods.

| Field | Value |
|---|---|
| Port | `27017` |
| Type | Headless (`ClusterIP: None`) |
| DNS | `mongodb-svc.<namespace>.svc.cluster.local` |

---

### 5. ConfigMap (`mongo-cm.yaml`)
Passes the MongoDB service hostname to the Mongo Express deployment.

| Key | Value |
|---|---|
| `DB_HOST` | `mongodb-svc` |

---

### 6. Mongo Express Secret (`mongo-express-secrets.yaml`)
Credentials for the Mongo Express web UI basic authentication.

| Key | Decoded Value |
|---|---|
| `WEB-UI-USERNAME` | `mohamed_admin` |
| `WEB-UI-PASSWORD` | `123456789` |

> ⚠️ **Important:** Change these credentials before deploying to any non-development environment.

---

### 7. Mongo Express Deployment (`mongoexpress-deploy.yaml`)
Deploys 3 replicas of the Mongo Express web interface.

| Field | Value |
|---|---|
| Replicas | 3 |
| Image | `mongo-express` |
| Container Port | `8081` |
| MongoDB connection | Via `mongodb-svc` (from ConfigMap) |
| Admin auth | Via `mongodb-secret` |
| Web UI auth | Via `mongo-express-secrets` |

---

### 8. Mongo Express Service (`mongoexpress-svc.yaml`)
Exposes Mongo Express externally via an AWS LoadBalancer.

| Field | Value |
|---|---|
| Type | `LoadBalancer` |
| Port | `8081` |
| NodePort | `30003` |

---

## Deployment

Apply the manifests in the following order to respect dependencies:

```bash
# 1. Storage
kubectl apply -f mongodb-sc.yaml

# 2. Secrets & Config
kubectl apply -f mongodb-secret.yaml
kubectl apply -f mongo-express-secrets.yaml
kubectl apply -f mongo-cm.yaml

# 3. MongoDB
kubectl apply -f mongodb-svc.yaml
kubectl apply -f mongodb-sts.yaml

# 4. Mongo Express
kubectl apply -f mongoexpress-deploy.yaml
kubectl apply -f mongoexpress-svc.yaml
```

---

## Verify the Deployment

```bash
# Check all resources are running
kubectl get all

# Watch the MongoDB StatefulSet come up
kubectl rollout status statefulset/mongodb

# Watch the Mongo Express Deployment
kubectl rollout status deployment/mongoexpress-deploy

# Get the external LoadBalancer IP/hostname
kubectl get svc mongoexpress-svc
```

Once the `EXTERNAL-IP` is assigned, access Mongo Express at:

```
http://<EXTERNAL-IP>:8081
```

Log in with the credentials stored in `mongo-express-secrets`.

---

## Teardown

```bash
kubectl delete -f mongoexpress-svc.yaml
kubectl delete -f mongoexpress-deploy.yaml
kubectl delete -f mongodb-sts.yaml
kubectl delete -f mongodb-svc.yaml
kubectl delete -f mongo-cm.yaml
kubectl delete -f mongo-express-secrets.yaml
kubectl delete -f mongodb-secret.yaml
kubectl delete -f mongodb-sc.yaml

# PVCs created by the StatefulSet must be deleted manually
kubectl delete pvc -l db=mongodb
```

---

## Security Notes

- All sensitive values are stored in Kubernetes `Secret` objects and never hardcoded in the Deployment/StatefulSet specs.
- Mongo Express uses HTTP basic authentication controlled by `ME_CONFIG_BASICAUTH_*` environment variables.
- For production, consider enabling **TLS** on the LoadBalancer and replacing basic auth with a more robust authentication mechanism (e.g., OAuth2 proxy).
- Rotate all default credentials before exposing any service publicly.


## Kyverno is a security policy engine designed for Kubernetes
 
![1_HX5dAuLA6bk6cd-zaY2zfQ](https://github.com/user-attachments/assets/644b8cce-d200-44a8-9d06-3123d378412a)

### Terraform Module - Kyverno | ⭐⭐⭐ Yevgeni ⭐⭐⭐
The Kyverno project provides a comprehensive set of tools to manage the complete Policy-as-Code (PaC) lifecycle for Kubernetes and other cloud native environments

✅ Requirements

Hardware Specification : Will be soon 

🎯 Installation

How to launch a Kyverno setup : Please talk with me directly 

🚀 

Disallow NodePort : 
A Kubernetes Service of type NodePort uses a host port to receive traffic from any source. A NetworkPolicy cannot be used to control traffic to host ports. Although NodePort Services can be useful, their use must be limited to Services with additional upstream security checks. This policy validates that any new Services do not use the `NodePort` type.
## 
```
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: restrict-nodeport
  annotations:
    policies.kyverno.io/title: Disallow NodePort
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/minversion: 1.6.0
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Service
    policies.kyverno.io/description: >-
      A Kubernetes Service of type NodePort uses a host port to receive traffic from
      any source. A NetworkPolicy cannot be used to control traffic to host ports.
      Although NodePort Services can be useful, their use must be limited to Services
      with additional upstream security checks. This policy validates that any new Services
      do not use the `NodePort` type.      
spec:
  validationFailureAction: audit
  background: true
  rules:
  - name: validate-nodeport
    match:
      any:
      - resources:
          kinds:
          - Service
    validate:
      message: "Services of type NodePort are not allowed."
      pattern:
        spec:
          =(type): "!NodePort"
```

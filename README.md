
## Kyverno is a security policy engine designed for Kubernetes
 
![1_HX5dAuLA6bk6cd-zaY2zfQ](https://github.com/user-attachments/assets/644b8cce-d200-44a8-9d06-3123d378412a)

### Terraform Module - Kyverno | ⭐⭐⭐ Yevgeni ⭐⭐⭐
The Kyverno project provides a comprehensive set of tools to manage the complete Policy-as-Code (PaC) lifecycle for Kubernetes and other cloud native environments

✅ Requirements

Hardware Specification : Will be soon 

🎯 Installation

How to launch a Kyverno setup : Please talk with me directly 

## 

⚙️ Disallow NodePort : 
A Kubernetes Service of type NodePort uses a host port to receive traffic from any source. A NetworkPolicy cannot be used to control traffic to host ports. Although NodePort Services can be useful, their use must be limited to Services with additional upstream security checks. This policy validates that any new Services do not use the `NodePort` type.

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

⚙️ Drop All Capabilities :
Capabilities permit privileged actions without giving full root access. All capabilities should be dropped from a Pod, with only those required added back. This policy ensures that all containers explicitly specify the `drop: ["ALL"]` ability. Note that this policy also illustrates how to cover drop entries in any case although this may not strictly conform to the Pod Security Standards

```
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: drop-all-capabilities
  annotations:
    policies.kyverno.io/title: Drop All Capabilities
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/severity: medium
    policies.kyverno.io/minversion: 1.6.0
    policies.kyverno.io/subject: Pod
    policies.kyverno.io/description: >-
      Capabilities permit privileged actions without giving full root access. All
      capabilities should be dropped from a Pod, with only those required added back.
      This policy ensures that all containers explicitly specify the `drop: ["ALL"]`
      ability. Note that this policy also illustrates how to cover drop entries in any
      case although this may not strictly conform to the Pod Security Standards.      
spec:
  validationFailureAction: audit
  background: true
  rules:
    - name: require-drop-all
      match:
        any:
        - resources:
            kinds:
              - Pod
      preconditions:
        all:
        - key: "{{ request.operation || 'BACKGROUND' }}"
          operator: NotEquals
          value: DELETE
      validate:
        message: >-
          Containers must drop `ALL` capabilities.          
        foreach:
          - list: request.object.spec.[ephemeralContainers, initContainers, containers][]
            deny:
              conditions:
                all:
                - key: ALL
                  operator: AnyNotIn
                  value: "{{ element.securityContext.capabilities.drop[].to_upper(@) || `[]` }}"
```

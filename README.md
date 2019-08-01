# Prometheus + Grafana Demo

A simple Prometheus + Grafana demo running on minikube k8s cluster.  

## Requirements
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [minikube](https://github.com/kubernetes/minikube)
* [hyperkit](https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#hyperkit-driver)

## Run 
Start minikube:
```bash
make start-minikube
```
  
Apply all k8s manifests to create monitoring namespace with Prometheus and Grafana:
```bash
make start
```
  
Delete all previously created resources:
```bash
make stop
```

## Configure Grafana
Add Prometheus data source and set the HTTP URL `http://prometheus:9090`.  
Test by running the following query via Explore:
```
avg(irate(container_cpu_usage_seconds_total{namespace=~"monitoring"}[5m]) * 100) by (pod_name)
```

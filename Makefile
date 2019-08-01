NO_COLOR=\x1b[0m
INFO_COLOR=\x1b[32;01m

PHONY: start-minikube
start-minikube:
	@minikube start --vm-driver hyperkit

PHONY: start
start:
	$(call pp,"Creating 'monitoring' namespace...")
	@kubectl create namespace monitoring --context=minikube > /dev/null
	$(call pp,"Starting Prometheus...")
	@kubectl create configmap prometheus-config --from-file=prometheus-config.yaml -nmonitoring --context=minikube > /dev/null
	@kubectl apply -f prometheus.yaml -nmonitoring --context=minikube > /dev/null
	@kubectl create -f prometheus-node-exporter.yaml -nmonitoring --context=minikube > /dev/null
	$(call pp,"Prometheus URL:")
	@minikube service --url --namespace=monitoring prometheus
	$(call pp,"Starting Alertmanager...")
	@kubectl create configmap alertmanager-config --from-file=alertmanager-config.yaml -nmonitoring --context=minikube > /dev/null
	@kubectl create -f alertmanager.yaml -nmonitoring --context=minikube > /dev/null
	$(call pp,"Alertmanager URL:")
	@minikube service --url --namespace=monitoring alertmanager
	$(call pp,"Starting Grafana...")
	@kubectl create -f grafana.yaml -nmonitoring --context=minikube > /dev/null
	$(call pp,"Grafana URL \(default credentials admin/admin\):")
	@minikube service --url --namespace=monitoring grafana # Add Prometheus as a datasource http://prometheus:9090 (defaults to admin/admin)
	$(call pp,"Done...")

PHONY: stop
stop:
	$(call pp,"Deleting 'monitoring' namespace...")
	@kubectl delete namespace monitoring --context=minikube > /dev/null
	@kubectl delete clusterrolebinding prometheus --context=minikube > /dev/null
	@kubectl delete clusterrole prometheus --context=minikube > /dev/null
	$(call pp,"Done...")

define pp
    @echo "$(INFO_COLOR)$(1)$(NO_COLOR)"
endef

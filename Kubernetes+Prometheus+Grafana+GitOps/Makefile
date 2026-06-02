.PHONY: default obs

default:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

	helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
		--namespace monitoring \
		--create-namespace \
		--set grafana.enabled=false

	helm upgrade --install grafana-operator grafana/grafana-operator \
		--namespace monitoring

obs:
	kubectl apply -f 01-grafana-instance.yaml
	kubectl apply -f 02-datasource.yaml
	kubectl apply -f 03-dashboard.yaml
	kubectl apply -f 04-folder.yaml
	kubectl apply -f 05-contact-point.yaml
	kubectl apply -f 06-notification-policy.yaml
	kubectl apply -f 07-alert-rule.yaml

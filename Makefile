.PHONY: help build-images tf-init tf-plan tf-apply tf-destroy tf-state get-outputs clean all deploy infra apps

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

build-images: ## Build Docker images
	@echo "Building Docker images..."
	./build

tf-init: ## Initialize Terraform
	@echo "Initializing Terraform..."
	cd terraform && terraform init

tf-plan: ## Plan Terraform deployment
	@echo "Planning Terraform deployment..."
	cd terraform && terraform plan

tf-apply: tf-init ## Apply Terraform deployment
	@echo "Applying Terraform deployment..."
	cd terraform && terraform apply -auto-approve

tf-destroy: ## Destroy Terraform deployment
	@echo "Destroying Terraform deployment..."
	cd terraform && terraform destroy -auto-approve

tf-state: ## Show Terraform state
	@echo "Terraform state resources:"
	@cd terraform && terraform state list

get-outputs: ## Get deployment outputs
	@echo "Getting deployment outputs..."
	@cd terraform && \
	CLIENT_PORT=$$(terraform output -raw client_node_port) && \
	MINIKUBE_IP=$$(minikube ip) && \
	echo "Client URL: http://$$MINIKUBE_IP:$$CLIENT_PORT/quote" && \
	echo "Istio Gateway HTTP: http://$$MINIKUBE_IP:$$(terraform output -raw istio_gateway_http_port)" && \
	echo "Istio Gateway HTTPS: https://$$MINIKUBE_IP:$$(terraform output -raw istio_gateway_https_port)"

clean: tf-destroy ## Clean up everything
	@echo "Cleaning up Docker images..."
	docker system prune -f

infra: tf-apply ## Deploy infrastructure only

apps: build-images tf-apply ## Build images and deploy applications

deploy: build-images tf-apply get-outputs ## Full deployment

all: deploy ## Same as deploy

dev-rebuild: build-images ## Rebuild images for development
	@echo "Images rebuilt. Run 'make tf-apply' to redeploy."

dev-logs-server: ## Show server logs
	kubectl logs -l app=server -f

dev-logs-client: ## Show client logs
	kubectl logs -l app=client -f

dev-logs-postgres: ## Show postgres logs
	kubectl logs -l app.kubernetes.io/name=postgresql -f

dev-restart-server: ## Restart server deployment
	kubectl rollout restart deployment/server

dev-restart-client: ## Restart client deployment
	kubectl rollout restart deployment/client

dev-status: ## Show deployment status
	@echo "Deployments:"
	@kubectl get deployments
	@echo ""
	@echo "Services:"
	@kubectl get services
	@echo ""
	@echo "Pods:"
	@kubectl get pods

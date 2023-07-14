CURRENT_DIR := $(shell pwd)

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: start
start: ## Deploy ceos lab
	sudo containerlab deploy --debug --topo $(CURRENT_DIR)/clab/topology.clab.yml --max-workers 2 --timeout 5m --reconfigure

.PHONY: stop
stop: ## Destroy ceos lab
	sudo containerlab destroy --debug --topo $(CURRENT_DIR)/clab/topology.clab.yml --cleanup

.PHONY: avd_build
avd_build: ## Generate AVD configs
	cd $(CURRENT_DIR)/avd_inventory; ansible-playbook playbooks/atd-fabric-build.yml

.PHONY: avd_provision_eapi
avd_provision_eapi: ## Deploy AVD configs using eAPI
	cd $(CURRENT_DIR)/avd_inventory; ansible-playbook playbooks/atd-fabric-provision-eapi.yml

.PHONY: avd_diff
avd_diff: ## Show the diff between running config and designed config
	cd $(CURRENT_DIR)/avd_inventory; ansible-playbook --diff --check playbooks/atd-fabric-provision-eapi.yml

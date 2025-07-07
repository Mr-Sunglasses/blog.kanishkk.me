
.PHONY: default init build serve prepare-init


default:
	@echo "Call a specific subcommand:"
	@echo
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null\
	| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}'\
	| sort\
	| grep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo
	@exit 1

# Check that the init script is executable
.check-init-script-permissions:
	@echo "Checking init script permissions..."
	@if [ ! -x scripts/init.sh ]; then \
		echo "Error: init.sh is not executable. Please run 'make prepare-init' first."; \
		exit 1; \
	fi
	@echo "Init script is executable."

# Make init script executable
prepare-init:
	@echo "Preparing init script..."
	chmod +x scripts/init.sh

# Run the init script
init: .check-init-script-permissions
	@echo "Running the init script..."
	./scripts/init.sh

# Build the site
build: hugo.toml
	hugo

# Serve the site locally
serve: build
	hugo server -t terminal

sync-blog:
	# If os in Linux. then only run this target
	@echo "Checking if the operating system is Linux..."
	@if [ "$(shell uname)" != "Linux" ]; then \
		echo "This target is only for Linux systems."; \
		exit 0; \
	fi
	# Ensure the init script is executable before syncing
	@$(MAKE) .check-init-script-permissions
	@echo "Preparing to sync blog files..."
	@echo "Syncing files..."
	@echo "Running syncblog and syncimage scripts..."
	@rsync -av --delete "/home/anton/kanishkvault/blog/" "/home/anton/Projects/blog.kanishkk.me/content/posts/"
	@python3 "/home/anton/Projects/blog.kanishkk.me/scripts/images.py"
	@echo "Sync completed."
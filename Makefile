build: hugo.toml
	hugo

serve: build
		hugo server -t terminal

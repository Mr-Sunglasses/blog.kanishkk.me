build:
	hugo

serve: build
		hugo server -t terminal

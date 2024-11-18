build:
	@echo "Building the project..."
	hugo


clean:
	@echo "Cleaning the project..."
	rm -rf ./public
	@echo "Done"

.PHONY: build clean
FROM gitpod/workspace-full
RUN sudo add-apt-repository ppa:cncf-buildpacks/pack-cli && \
	sudo apt-get update && \
	sudo apt-get install pack-cli

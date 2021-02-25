# Based on scratch since lifecycle will export Windows-formatted images that cannot run on Linux but can be inspected and rebased.
FROM scratch

# Set required CNB information
ARG stack_id
LABEL io.buildpacks.stack.id="${stack_id}"

# Add any file to create a minimal top layer, required for pack
COPY Dockerfile /top-layer-placeholder

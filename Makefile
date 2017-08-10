REPO      = opsani
IMAGE_TAG = latest
PROBE     = redis

.PHONY: all \
        push

all:
	docker build -f Dockerfile -t ${REPO}/probe-${PROBE}:${IMAGE_TAG} .

push:
	docker push ${REPO}/probe-${PROBE}:${IMAGE_TAG}

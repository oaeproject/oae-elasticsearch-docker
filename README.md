# Elasticsearch docker image

Regular alpine linux image for elasticsearch 1.7.5

## Usage

### Run from dockerhub

```
docker run -it --name=elasticsearch --net=host oaeproject/oae-elasticsearch-docker
```

### Build the image locally

```
# Step 1: Build the image
docker build -f Dockerfile -t oae-elasticsearch:latest .
# Step 2: Run image
docker run -it --name=elasticsearch --net=host oae-elasticsearch:latest
```
# Build Images
The 76 EDDGE build images are created using the dockerfiles in this repository. They are pieced together into Kubernetes Pods and used to build separate components of different projects.

## Building
All building is handled by the build.sh script. The images are only pushed to dockerhub when a release is created.

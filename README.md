# Kasm-Ubunut
## Steps for updating the dockerhub repo:
### **Build the New Image**:
```
docker build -t etheirys/kasm-ubuntu:latest .

```
### **Login to Docker Hub (if necessary)**:
```
docker login

```
### **Tag the New Image (if necessary)**:
```
docker tag etheirys/kasm-ubuntu:latest etheirys/kasm-ubuntu:<new-tag>

```
### **Push the Image to the Repository**:
```
docker push etheirys/kasm-ubuntu:latest

```

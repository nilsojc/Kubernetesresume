<p align="center">
  <img src="https://i.imgur.com/MDJUGvO.png" 
</p>
  
##  Hosting a Resume from Kubernetes with docker using Amazon Elastic Kubernetes Services 

In this project, I created a resume from a sample .HTML and .CSS file. In this instance, we host it running a container from Kubernetes using Docker and Amazon Elastic Kubernetes Services. I will run a Kubernetes cluster in Amazon's Elastic Kubernetes Service in which our worker node will be an EC2 instance with said container inside a pod. Resume will be hosted in the container  and I will employ an Application Load Balancer which will give us an URL accesible to everyone. It is possible to use Docker with Apache Webserver Image and replace it with our own .HTML file. However, if our pod in the container goes down or ports scale up, we will need to log in into each container and set it up manually, which is not sustainable.
##  So what is the solution?

We need to implement a custom image from the Apache Web Server so that the pods can receive our container and files from the resume automatically, allowing us to scale and be able to host our resume on the website. We will be creating our container in Docker and save it to our DockerHub repository. Next, we will be using Elastic Kubernetes Services to deploy the container from Dockerhub. 


<h2>Environments and Technologies Used</h2>

  - Amazon Web Services (AWS)
  - AWS CLI
  - kubectl
  - eksctl
  - EKS (Elastic Kubernetes Services) 
  - Kubernetes
  - Docker
  - HTML
  - CSS
  - JSON
    
  

<h2>Operating Systems Used</h2>

- **Windows 11**
- Linux (EC2)

<h2>How to Build</h2>

1. **Create EKS Cluster**
   
  NOTE: In order for us to start creating a cluster in Elastic Kubernetes Services, we first need to set up __AWS CLI__ credentials so that it can communicate with **eksctl**. With this guide: https://docs.aws.amazon.com/eks/latest/userguide/install-awscli.html you can set up AWS CLI in any OS.

  <p align="center">
  <img src="https://i.imgur.com/720Htdt.png" 
</p>

Then, proceed to install both `kubectl` and `eksctl`. In this instance, we will use Windows to install both CLI interfaces. 

For `kubectl` we will open a Powershell terminal and copy-paste this code: `curl.exe -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.2/2024-11-15/bin/windows/amd64/kubectl.exe`
  <p align="center">
  <img src="https://i.imgur.com/6UyorUW.png" 
</p>

 for `eksctl` I utilized chocolatey on `Windows 11` but there are many other ways to install it. Run Powershell as admin and copy paste this command `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`

 Chocolatey will install and commands will start with `choco`. on the same window, copy-paste `choco install eksctl`.
 <p align="left">
  <img src="https://i.imgur.com/nTe2Ece.png" 
</p>

Next, we will run the command `eksctl create cluster` in the CLI. Note that if we input the command as it is, it will create two M5 Large EC2 instances, which are **NOT** covered in the Free Tier. Therefore, we have to specify the type of instancce we will be deploying. Command will be sent as `eksctl create cluster --node-type t2.micro --nodes 2`. Process will take around 10 to 15 minutes as it will be deploying multiple services like `VPC` and Route tables.

<p align="center">
  <img src="https://i.imgur.com/v72uPKW.png" 
</p>

If you want to see details of the cluster, you can run the command `eksctl get cluster`
 
 <p align="left">
  <img src="https://i.imgur.com/kvT29S2.png" 
</p>

To check if the EC2 worker nodes are running you can use the command `kubectl get nodes` or by searching `Elastic Kubernetes Service` in the AWS Console.
 <p align="left">
  <img src="https://i.imgur.com/9DS3QKD.png" 
</p>
 <p align="left">
  <img src="https://i.imgur.com/gHv86lN.png" 
</p>
  <p align="left">
  <img src="https://i.imgur.com/lJW3NRA.png" 
</p>

 
   
2. **Install Docker Desktop and build a docker image in order to be pushed in our Docker Hub repository.**

In this step, we will install Docker desktop along with the creation of a dockerfile to build a docker image to be deployed to Docker hub.
 <p align="center">
  <img src="https://i.imgur.com/K4LxElf.png" 
</p>

   Next, we will input the command `docker build -t custom-httpd .` to start building a docker image. 
<p align="center">
  <img src="https://i.imgur.com/knJDFRT.png" 
</p>
<p align="left">
  <img src="https://i.imgur.com/LFp9H4X.png" 
</p>

 The docker image will show after inputting the command `docker images`:
 <p align="left">
  <img src="https://i.imgur.com/KctWiUf.png" 
</p>

Next up, we will input the command `docker run -d -p 8080:80 custom-httpd` so that we run our container image. 
<p align="left">
  <img src="https://i.imgur.com/Ykf05Bt.png" 
</p>
  
You can find out if our container image is running locally by sending the command `docker ps`
<p align="left">
  <img src="https://i.imgur.com/uWLJDq4.png" 
</p>

The docker image will now run in `localhost:8080`, and we can test it by typing it in the address bar:

<p align="center">
  <img src="https://i.imgur.com/aBgpjOj.png" 
</p>

After this step, we will need to push this image to dockerhub. A repository was created in `hub.docker.com` with the name `custom-httpd` as shown below:
<p align="left">
  <img src="https://i.imgur.com/WvLdyQD.png" 
</p>
  
However, in order for us to do that we will need to stop the repository with the command `docker stop 5fae504c790d`.
<p align="left">
  <img src="https://i.imgur.com/XrcF3Lq.png" 
</p>
  
Input command `docker login --username=yourusername` so that we can sign our Dockerhub account and push our repository with command `docker push username/custom-httpd`

Then, we use command `docker tag 99e4d0a28193 nilsojc/custom-httpd ` to tag this container image with the docker hub repository
<p align="left">
  <img src="https://i.imgur.com/OeuZMLz.png" 
</p>

  Then we proceed to push the image to our repository `nilsojc/custom-httpd`
<p align="left">
  <img src="https://i.imgur.com/Pnn7zUA.png" 
</p>

3. **Deploy Resume Container from DockerHub to Amazon EKS**
NOTE:We will grab our `manifest file` which is the sample `.yaml Load Balancer file` in my repository. You can create an external load balancer for kubernetes with kubectl with an example command like `kubectl expose deployment example --port=8765 --target-port=9376 \
        --name=example-service --type=LoadBalancer`. This command creates a new Service using the same selectors as the referenced resource (in the case of the example above, a Deployment named example). For more information on this part, you can visit the website https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/

<p align="left">
  <img src="https://i.imgur.com/TqRFOVN.png" 
</p>
  
<p align="left">
  <img src="" 
</p>
<p align="left">
  <img src="https://i.imgur.com/XrcF3Lq.png" 
</p>
<p align="left">
  <img src="https://i.imgur.com/XrcF3Lq.png" 
</p>
<p align="left">
  <img src="https://i.imgur.com/XrcF3Lq.png" 
</p>
<p align="left">
  <img src="https://i.imgur.com/XrcF3Lq.png" 
</p>




 


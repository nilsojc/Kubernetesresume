<p align="center">
  <img src="https://i.imgur.com/udMqbcU.png" 
</p>
  
##  Hosting a Resume from Kubernetes with docker using Amazon Elastic Kubernetes Services 

In this project, I created a resume from a sample .HTML and .CSS file. In this instance, we host it running a container from Kubernetes using Docker and Amazon Elastic Kubernetes Services. I will run a Kubernetes cluster in Amazon's Elastic Kubernetes Service in which our worker node will be an EC2 instance with said container inside a pod. Resume will be hosted in the container  and I will employ an Application Load Balancer which will give us an URL accesible to everyone. It is possible to use Docker with Apache Webserver Image and replace it with our own .HTML file. However, if our pod in the container goes down or ports scale up, we will need to log in into each container and set it up manually, which is not sustainable.
##  So what is the solution?

We need to implement a custom image from the Apache Web Server so that the pods can receive our container and files from the resume automatically, allowing us to scale and be able to host our resume on the website. We will be creating our cotainer in Docker and save it to our DockerHub repository. Next, we will be using Elastic Kubernetes Services to deploy the container from Dockerhub. 


<h2>Environments and Technologies Used</h2>

  - Amazon Web Services (AWS)
  - AWS CLI
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

1. **Create a S3 Bucket**  

 When we create a S3 bucket, we want to make sure we allow public access so that the bucket is accessible publicly. However, we need to determine which object or resource is going to be allowed for public access, which is why we implement a S3 Bucket Policy in a json file. (file has been provided at the repository. Make sure the value of "Resource" is renamed to the S3 bucket you are using. It will display above the bucket policy box or by browsing the S3 bucket, as show in this video:

 

https://github.com/user-attachments/assets/02270fec-0ff5-4fbf-911f-aec2a65cb469

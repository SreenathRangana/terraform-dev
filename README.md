# terraform-dev

# terraform-dev

Deploying a Simple Web Application to AWS ECS with GitHub Actions and Terraform

set up GitHub Actions CI/CD with the help of AWS and Terraform. The CI/CD platform will be GitHub, the infrastructure will be created on AWS, and Terraform will be used to manage the infrastructure.

Problem : Create a simple website with automated deployment using AWS services.
Solution : We built a complete CI/CD pipeline where:
Developer writes code and pushes to GitHub
GitHub automatically builds and deploys the website
Website runs on AWS cloud infrastructure

# Key Components :
Source Code: Simple “Hello World” website
Container: Website packaged in Docker
Cloud Storage: AWS ECR holds our Docker image
Cloud Hosting: AWS ECS runs our website
Automation: GitHub Actions handles deployment

# End Result :
Push code → Website automatically goes live
No manual deployment steps needed
Everything runs in AWS cloud
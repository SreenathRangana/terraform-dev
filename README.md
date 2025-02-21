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




# Created Manually ACM in Console
# Route53 Hostedzone created in console and NS changed in Hostinger

# ACM and R53 Zone id call in tf files.



since your original domain is in Hostinger, but you created an Amazon Route 53 hosted zone via Terraform, you will need to manually update the NS (Name Server) records in Hostinger.

Steps to Configure Route 53 with Hostinger
Get the NS (Name Server) Records from Route 53

After running terraform apply, go to the AWS Console → Route 53
Find your hosted zone
Copy the NS (Name Server) records from Route 53
Update NS Records in Hostinger

Login to Hostinger
Go to Domains → DNS Settings
Replace the current NS (Name Server) records with the ones from Route 53
Wait for DNS Propagation

It may take a few hours (usually 30 minutes to 48 hours) for the changes to propagate worldwide.
You can check propagation with https://dnschecker.org/
Can Terraform Auto-Update Hostinger DNS?No, Terraform cannot automatically update external registrars (like Hostinger).
You must manually update the NS records in Hostinger.

Final Steps
Apply Terraform → Get NS records from Route 53
Update NS records manually in Hostinger
Wait for DNS propagation
Once done, Route 53 will control your domain’s DNS! Let me know if you need help! 🚀
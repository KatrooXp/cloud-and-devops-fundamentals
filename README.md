## Final project on Cloud&amp;DevOps fundamentals course

Deploying website on AWS cloud with CI/CD pipeline, using version control, automatic infrastracture creation, containirezation and containers orchestration 

## Techonolgy stack

- Jenkins
- Git
- Terraform
- AWS
- Docker

## Project architecture

Jenkins CI/CD pipeline works in next steps:

1. Pull updates: Whenever GitHub project is updated, Git plugin pulls updated resources using credentials via ssh connection (GitHub Webhook is used)
2. Build infrastructure: Terraform configures VPC and all dependencies: Security Group, ECR repository, ECS service with Load balancer
3. Build image: Docker builds image from Dockerfile with docker build command
4. Push image: Jenkins gets temporary credentials from AWS, tags docker image as needed for AWS ECR and pushes docker image to ECR repository
5. Update service: Jenkins gets existing task definition from ECS, configures and registers new task definition, gets task revision number, updates ECS service

![Alt text](<pics_for_readme/Final_project.drawio (3).png>)

## Pipeline configuration in Jenkins

General

![Alt text](<pics_for_readme/Screenshot from 2023-08-31 13-32-53.png>)

GitHub trigger

![Alt text](<pics_for_readme/Screenshot from 2023-08-31 13-28-12.png>)

Buid steps

![Alt text](<pics_for_readme/Screenshot from 2023-08-31 13-29-21.png>)

![Alt text](<pics_for_readme/Screenshot from 2023-08-31 13-29-43.png>)

![Alt text](<pics_for_readme/Screenshot from 2023-08-31 13-30-04.png>)


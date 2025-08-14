# 2048 Game with AWS CI/CD Pipeline

A fully automated deployment of the classic 2048 game using AWS services with Infrastructure as Code (Terraform) and a complete CI/CD pipeline.

## 🎮 **Live Demo**

The 2048 game is automatically deployed and accessible via AWS ECS Fargate. Each code push triggers an automated build and deployment process.

## 🏗️ **Architecture Overview**

This project implements a complete AWS CI/CD pipeline with the following components:

```
GitHub → CodePipeline → CodeBuild → ECR → ECS Fargate
```

### **AWS Services Used:**
- **Amazon ECR**: Container registry for Docker images
- **AWS CodePipeline**: CI/CD orchestration
- **AWS CodeBuild**: Docker image building and pushing
- **Amazon ECS Fargate**: Serverless container hosting
- **Amazon S3**: Artifact storage
- **AWS IAM**: Security and permissions
- **Amazon CloudWatch**: Logging and monitoring

## 📁 **Project Structure**

```
├── frontend/                 # 2048 game application
│   ├── index.html           # Main game page
│   ├── js/                  # Game logic
│   ├── style/               # CSS styling
│   ├── meta/                # Icons and images
│   └── Dockerfile           # Container configuration
├── modules/                 # Terraform modules
│   ├── iam/                 # IAM roles and policies
│   ├── ecr/                 # Container registry
│   ├── s3/                  # Artifact storage
│   ├── ecs/                 # Container orchestration
│   ├── codebuild/           # Build service
│   └── codepipeline/        # CI/CD pipeline
├── main.tf                  # Main Terraform configuration
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── terraform.tf             # Provider configuration
├── buildspec.yml            # CodeBuild instructions
└── terraform.tfvars.example # Example configuration
```

## 🚀 **Quick Start**

### **Prerequisites**
- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed
- GitHub personal access token

### **1. Clone Repository**
```bash
git clone https://github.com/kurokood/2048_game_with_aws_codepipeline_ecs_ecr.git
cd 2048_game_with_aws_codepipeline_ecs_ecr
```

### **2. Configure Variables**
```bash
# Copy example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values:
# - aws_account_id: Your AWS account ID
# - github_token: Your GitHub personal access token
# - Other optional customizations
```

### **3. Deploy Infrastructure**
```bash
# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Deploy infrastructure
terraform apply
```

### **4. Access Your Game**
After deployment, get the public IP of your ECS task:
```bash
# Get task public IP
aws ecs describe-tasks --cluster 2048-game-cluster --tasks $(aws ecs list-tasks --cluster 2048-game-cluster --service-name 2048-service --query 'taskArns[0]' --output text) --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text | xargs -I {} aws ec2 describe-network-interfaces --network-interface-ids {} --query 'NetworkInterfaces[0].Association.PublicIp' --output text
```

Visit `http://[PUBLIC_IP]:80` to play your 2048 game!

## 🔄 **CI/CD Pipeline**

### **Automated Workflow:**
1. **Source**: Push code to GitHub `master` branch
2. **Build**: CodeBuild creates Docker image and pushes to ECR
3. **Deploy**: CodePipeline updates ECS service with new image

### **Pipeline Stages:**

#### **Source Stage**
- Monitors GitHub repository for changes
- Downloads source code when changes detected
- Stores source artifacts in S3

#### **Build Stage**
- Builds Docker image from `frontend/` directory
- Tags image with latest version
- Pushes image to Amazon ECR
- Creates deployment artifact (`imagedefinitions.json`)

#### **Deploy Stage**
- Updates ECS service with new task definition
- Performs rolling deployment with zero downtime
- Automatically rolls back on deployment failures

## 🛠️ **Configuration**

### **Required Variables**
```hcl
aws_account_id = "123456789012"  # Your AWS account ID
github_token   = "ghp_xxxx"      # GitHub personal access token
```

### **Optional Customizations**
```hcl
# Project settings
project_name = "2048-game"
environment  = "prod"
aws_region   = "us-east-1"

# Resource names
ecr_repository_name      = "2048-game-repo"
s3_artifact_bucket_name  = "your-unique-bucket-name"
ecs_cluster_name         = "2048-game-cluster"

# ECS configuration
desired_task_count = 1
container_port     = 80
cpu                = 256
memory             = 512
```

## 🔧 **Infrastructure Components**

### **Container Registry (ECR)**
- Stores Docker images securely
- Automatic vulnerability scanning
- Lifecycle policies for image cleanup

### **Container Orchestration (ECS)**
- Fargate serverless containers
- Auto-scaling capabilities
- Health checks and circuit breakers
- CloudWatch logging integration

### **CI/CD Pipeline (CodePipeline + CodeBuild)**
- GitHub integration with webhooks
- Automated Docker builds
- Zero-downtime deployments
- Artifact management

### **Security (IAM)**
- Least-privilege access policies
- Separate roles for each service
- Secure credential management

## 📊 **Monitoring & Logging**

### **CloudWatch Log Groups**
- `/ecs/2048-game`: Container application logs
- `/aws/codebuild/2048-game-build`: Build process logs

### **Monitoring**
- ECS service metrics
- CodePipeline execution history
- CodeBuild build logs
- Container health status

## 🔒 **Security Features**

- **IAM Roles**: Least-privilege access for all services
- **VPC Security Groups**: Network-level access control
- **S3 Encryption**: Server-side encryption for artifacts
- **ECR Scanning**: Automatic vulnerability scanning
- **Private Networking**: Secure communication between services

## 🧹 **Cleanup**

To destroy all resources:
```bash
terraform destroy
```

The S3 bucket is configured with `force_destroy = true` to automatically handle artifact cleanup.

## 🎯 **Key Features**

- ✅ **Fully Automated**: Push to GitHub triggers complete deployment
- ✅ **Zero Downtime**: Rolling deployments with health checks
- ✅ **Scalable**: Easy to modify resource allocation
- ✅ **Secure**: Comprehensive IAM policies and network security
- ✅ **Cost Effective**: Uses Fargate serverless containers
- ✅ **Maintainable**: Modular Terraform code structure
- ✅ **Production Ready**: Circuit breakers and error handling

## 🔧 **Troubleshooting**

### **Common Issues**

#### **Docker Hub Rate Limits**
The project uses `public.ecr.aws/nginx/nginx:latest` to avoid Docker Hub rate limiting issues.

#### **IAM Permission Errors**
All required IAM roles and policies are automatically created with proper trust relationships.

#### **Deployment Timeouts**
ECS service includes circuit breakers to automatically handle failed deployments.

### **Useful Commands**

```bash
# Check ECS service status
aws ecs describe-services --cluster 2048-game-cluster --services 2048-service

# View container logs
aws logs describe-log-streams --log-group-name /ecs/2048-game

# Check pipeline status
aws codepipeline get-pipeline-state --name 2048-game-pipeline

# Force new deployment
aws ecs update-service --cluster 2048-game-cluster --service 2048-service --force-new-deployment
```

## 📝 **Development**

### **Local Development**
```bash
# Run locally with Docker
cd frontend
docker build -t 2048-game .
docker run -p 8080:80 2048-game
# Visit http://localhost:8080
```

### **Making Changes**
1. Modify files in `frontend/` directory
2. Commit and push to GitHub
3. Pipeline automatically builds and deploys changes
4. Access updated game at ECS public IP

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally
5. Submit a pull request

## 📄 **License**

This project is open source and available under the MIT License.

## 🚀 **Advanced Configuration**

### **Multi-Environment Setup**
```hcl
# terraform.tfvars for staging
environment = "staging"
desired_task_count = 1
cpu = 256
memory = 512

# terraform.tfvars for production
environment = "prod"
desired_task_count = 2
cpu = 512
memory = 1024
```

### **Custom Domain Setup**
To use a custom domain with Route 53 and ALB:
```hcl
# Add to terraform.tfvars
enable_custom_domain = true
domain_name = "2048.yourdomain.com"
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxx"
```

### **Auto Scaling Configuration**
```hcl
# Enable auto scaling
enable_auto_scaling = true
min_capacity = 1
max_capacity = 10
target_cpu_utilization = 70
```

## 📈 **Performance Optimization**

### **Container Optimization**
- Uses multi-stage Docker builds for smaller images
- Nginx serves static files efficiently
- Gzip compression enabled
- Browser caching headers configured

### **AWS Cost Optimization**
- **Fargate Spot**: Consider using Fargate Spot for non-production
- **ECR Lifecycle**: Automatically removes old images after 30 days
- **CloudWatch Logs**: 7-day retention for build logs
- **S3 Lifecycle**: Artifacts cleaned up after 30 days

### **Monitoring Best Practices**
```bash
# Set up CloudWatch alarms
aws cloudwatch put-metric-alarm \
  --alarm-name "2048-game-high-cpu" \
  --alarm-description "High CPU utilization" \
  --metric-name CPUUtilization \
  --namespace AWS/ECS \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold
```

## 🔄 **CI/CD Best Practices**

### **Branch Protection**
Recommended GitHub branch protection rules:
- Require pull request reviews
- Require status checks to pass
- Require branches to be up to date
- Include administrators in restrictions

### **Pipeline Optimization**
- **Parallel Builds**: Build and test stages run in parallel
- **Caching**: Docker layer caching in CodeBuild
- **Artifact Management**: Automatic cleanup of old artifacts
- **Rollback Strategy**: Automatic rollback on deployment failure

### **Testing Integration**
Add testing stages to your pipeline:
```yaml
# In buildspec.yml
phases:
  pre_build:
    commands:
      - echo Running unit tests
      - npm test
      - echo Running security scans
      - npm audit
```

## 🛡️ **Security Best Practices**

### **Network Security**
- ECS tasks run in private subnets
- NAT Gateway for outbound internet access
- Security groups with minimal required ports
- VPC Flow Logs enabled

### **Container Security**
- Non-root user in Docker container
- Minimal base image (nginx:alpine)
- Regular security updates
- ECR vulnerability scanning

### **Secrets Management**
For sensitive configuration:
```hcl
# Use AWS Systems Manager Parameter Store
resource "aws_ssm_parameter" "github_token" {
  name  = "/2048-game/github-token"
  type  = "SecureString"
  value = var.github_token
}
```

## 📊 **Monitoring Dashboard**

### **CloudWatch Dashboard**
Create a custom dashboard to monitor your application:
```bash
# Create CloudWatch dashboard
aws cloudwatch put-dashboard \
  --dashboard-name "2048-Game-Dashboard" \
  --dashboard-body file://dashboard.json
```

### **Key Metrics to Monitor**
- ECS Service CPU/Memory utilization
- Task count and health status
- Pipeline success/failure rates
- Application response times
- Error rates and logs

## 🔧 **Troubleshooting Guide**

### **Pipeline Issues**

#### **Build Fails with "No space left on device"**
```bash
# Increase CodeBuild compute type
compute_type = "BUILD_GENERAL1_MEDIUM"  # Instead of SMALL
```

#### **GitHub Webhook Not Triggering**
1. Check GitHub webhook configuration
2. Verify GitHub token permissions
3. Check CodePipeline source configuration

#### **ECR Push Permission Denied**
```bash
# Verify CodeBuild role has ECR permissions
aws iam get-role-policy --role-name codebuild-2048-game-build-service-role --policy-name CodeBuildServiceRolePolicy
```

### **ECS Deployment Issues**

#### **Tasks Failing Health Checks**
```bash
# Check task logs
aws logs get-log-events \
  --log-group-name /ecs/2048-game \
  --log-stream-name ecs/2048-game-task/[TASK-ID]
```

#### **Service Not Reaching Steady State**
- Check security group allows port 80
- Verify task definition is valid
- Check subnet has internet access via NAT Gateway

### **Performance Issues**

#### **High Memory Usage**
```bash
# Increase memory allocation
memory = 1024  # Instead of 512
```

#### **Slow Container Startup**
- Optimize Docker image size
- Use multi-stage builds
- Consider using smaller base images

## 🎓 **Learning Resources**

### **AWS Documentation**
- [Amazon ECS Developer Guide](https://docs.aws.amazon.com/ecs/)
- [AWS CodePipeline User Guide](https://docs.aws.amazon.com/codepipeline/)
- [Amazon ECR User Guide](https://docs.aws.amazon.com/ecr/)

### **Terraform Resources**
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

### **Docker & Containers**
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Container Security](https://docs.docker.com/engine/security/)

## 🔗 **Related Projects**

- [AWS ECS Terraform Examples](https://github.com/terraform-aws-modules/terraform-aws-ecs)
- [AWS CodePipeline Examples](https://github.com/aws-samples/aws-codepipeline-samples)
- [2048 Game Variants](https://github.com/gabrielecirulli/2048)

## 📞 **Support**

### **Getting Help**
- Create an issue in this repository
- Check AWS documentation
- Review CloudWatch logs for errors
- Use AWS Support (if you have a support plan)

### **Common Questions**

**Q: Can I use a different AWS region?**
A: Yes, update the `aws_region` variable in terraform.tfvars

**Q: How do I add HTTPS support?**
A: Add an Application Load Balancer with SSL certificate

**Q: Can I deploy multiple environments?**
A: Yes, use different Terraform workspaces or separate tfvars files

**Q: How do I reduce costs?**
A: Use Fargate Spot, reduce task count, or use smaller instance sizes

## 🙏 **Acknowledgments**

- Original 2048 game by Gabriele Cirulli
- AWS documentation and best practices
- Terraform AWS provider community
- Open source contributors and maintainers

---

###  Author: Mon Villarin
 📌 LinkedIn: [Ramon Villarin](https://www.linkedin.com/in/ramon-villarin/)  
 📌 Portfolio Site: [MonVillarin.com](https://monvillarin.com)  
 📌 Blog Post: [Serverless Approach with AWS CI/CD: Transforming Operations and Reducing Costs](https://blog.monvillarin.com/serverless-approach-with-aws-cicd-transforming-operations-and-reducing-costs)

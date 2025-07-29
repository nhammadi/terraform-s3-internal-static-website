# Internal HTTPS Static Website with Terraform (ALB + S3 + VPC Endpoint + Route 53 + ACM)

This Terraform project provisions a secure, internal-only HTTPS static website using **Amazon S3**, **Application Load Balancer (ALB)**, **VPC Interface Endpoint for S3**, **ACM (public or private)**, and **Route 53** for DNS management.

## Notes

- This project uses a **self-signed certificate** for TLS/SSL encryption. This is suitable for testing environments.
- For production use, consider replacing the self-signed certificate with:
  - An **ACM public certificate** (for publicly accessible domains)
  - An **ACM Private Certificate** issued from **AWS Certificate Manager Private CA** (for internal, trusted environments)
- ACM **public certificates** require domain validation via DNS or email.
- ACM **private certificates** require a configured **Private CA** in AWS ACM PCA.
- If using a **private hosted zone**, Route 53 will not resolve from public internet.


## Architecture Overview

![Internal Static Website Architecture](assets/s3-internal-static-website.svg)

- **Amazon S3**: Stores static website content (HTML, CSS, JS).
- **Application Load Balancer (ALB)**: Serves HTTPS traffic, performs SSL termination.
- **S3 Interface VPC Endpoint**: Enables private access to S3 from ALB without using the internet.
- **AWS Certificate Manager (ACM)**: Issues an SSL/TLS certificate (public or private).
- **Route 53**: Manages domain name resolution using either a **private** or **public hosted zone**.

## Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI configured
- A registered domain (if using Route 53 public hosted zone)
- (Optional) AWS Private CA for internal certificates

### 1. Clone the repository

```bash
git clone https://github.com/nhammadi/terraform-s3-internal-static-website.git
cd terraform-s3-internal-static-website
```

### Cleanup

To remove all infrastructure:

```bash
terraform destroy
```

### Possible Enhancements
 - Add AWS WAF to the ALB
 - Enable S3 bucket logging
 - Enable ALB access logs
 - Enable Route53 query logging in case you provision a public zone

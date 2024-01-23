# Website S3 & CloudFront with Terraform

This Terraform project deploys a static website on AWS using S3 for storage and CloudFront for content delivery. Follow the steps below to set up and manage your website infrastructure.

## Requirements

Before you begin, make sure you have the following requirements in place:

1. AWS Account: You need an AWS account with sufficient permissions to create resources like S3 buckets, CloudFront distributions, IAM users, and IAM policies.

2. Terraform Installed: Make sure you have Terraform installed on your local machine or use Docker. You can download it [here](https://www.terraform.io/downloads.html).

## Instructions

Follow these steps to deploy and manage your website infrastructure:

1. **Create an IAM User**:

   - Create an IAM user in your AWS account. You can name it `tf_s3_cloudfront`.
   - Attach the `terraform-static-web-site-s3-cloudfront` policy to this user. You can find the policy JSON content in this repository.

2. **Generate AWS Access Keys**:

   - Create an AWS access key and secret access key for the `tf_s3_cloudfront` IAM user.
   - Keep these credentials secure, as they provide access to your AWS account.

3. **Configure AWS Credentials**:

   - You can configure AWS credentials using one of the following methods:
     - **Option 1: Environment Variables**: Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables with the values of the access key and secret access key.
     - **Option 2: Modify `variables.tf`**: Replace the default values of `aws_access_key_id` and `aws_secret_access_key` in the `variables.tf` file with your access key and secret access key. **Note**: Be cautious not to expose these credentials publicly.

4. **Initialize Terraform**:

   - Run `terraform init` to initialize the Terraform environment.

5. **Plan the Deployment**:

   - Run `terraform plan` to preview the changes that Terraform will apply.

6. **Apply the Configuration**:

   - Run `terraform apply` to create the website infrastructure. To skip the "yes/no" prompt, use `terraform apply -auto-approve`.

7. **Destroy Resources (Optional)**:

   - If you want to destroy the resources and clean up your AWS environment, you can run `terraform destroy`. To skip the "yes/no" prompt, use `terraform destroy -auto-approve`.

## Additional Notes

- The static website files, including the `index.html`, should be placed in the `static/html/` directory before running Terraform.

- After deployment, you will receive outputs that include the CloudFront distribution domain and S3 bucket details.

- Remember that AWS credentials should be handled securely to protect your AWS resources. Use IAM roles and policies to follow security best practices.

- To learn more about the infrastructure and the website setup, refer to the [accompanying article](https://www.alter-solutions.com/articles/website-amazon-s3-terraform) for detailed explanations.

Happy website deployment with Terraform!

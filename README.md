Azure Policy Guardrails with Terraform
This project automates security governance by deploying Azure Policies using Terraform to block public IP exposure at the resource-group level. 
It enforces least-privilege and secure-by-default cloud compliance — ideal for standardized client onboarding and Zero-Trust environments.
In bullet points:
  Deploy Azure Policy + Scoped Assignment via IaC
  Prevent Public IP creation (Zero Trust enforcement)
  Supports standardized client onboarding
  Eliminates manual misconfiguration risk

Full Note

Azure Policy Enforcement with Terraform 

Deny Public IPs in Azure Resource Groups


Overview

This project demonstrates how to enforce security governance in Azure using Terraform by assigning a built-in Azure Policy that prevents resources with Public IP addresses from being created in a specified Resource Group.
This aligns with security-by-design cloud standards and ensures compliance by preventing misconfigurations before they occur.


What This Project Achieves

Enforces least-exposure networking posture
Prevents accidental creation of publicly exposed workloads
Demonstrates Azure governance using Policy Assignments
Shows how Terraform automates compliance configuration


Architecture Components
Resource	Purpose
Azure Resource Group	Scope for the policy assignment
Built-in Azure Policy	Restricts public IP creation
Policy Assignment	Enforcement mechanism applied to RG
Tools & Technologies

Terraform (v1.14+)
AzureRM provider
Azure Subscription with permission to assign policies


Steps to Deploy
terraform init
terraform plan
terraform apply

How to Test the Policy Works
Try deploying any resource with a Public IP into the protected Resource Group — example:
An Azure VM with a Public IP
A Public Load Balancer
A Public IP resource directly


Expected behavior:
Deployment fails due to policy violation
This confirms security compliance is functioning correctly.


Business Value

“By proactively blocking insecure configurations such as public IP exposure, this improves cloud security posture, reduces breach risk, and enforces standardized compliance across environments — fully automated via Terraform.”


Lessons Learned

Terraform can define not only infrastructure but governance and security controls
Azure Policies sometimes require parameters to be passed correctly
Service principals must have proper RBAC permissions to assign policies


Future Enhancements
Add automated diagnostic logging
Apply policy at subscription or management group scope
Include additional policies (e.g., require tags, enforce encryption)

Author

Paul A.O — Cloud/DevOps Specialist

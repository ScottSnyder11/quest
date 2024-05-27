# Infrastructure Terraform Files

This repository contains a collection of Terraform files for building infrastructure to host a web server.

## Prerequisites

Before you can use these Terraform files, make sure you have the following prerequisites installed:

- Terraform (version ~3.0)
- [Docker]

## Getting Started

To get started, follow these steps:

1. Clone this repository to your local machine.
3. Open a terminal and navigate to the root directory of this repository.
4. Run `terraform init` to initialize the Terraform environment.
5. Run `terraform plan` to see the infrastructure that will be created.
6. Run `terraform apply` to build the infrastructure.  

Note: HTTPS(TLS) for the website is within AWS RT53 and currently is being handled manually.




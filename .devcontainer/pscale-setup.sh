#!/bin/bash

# Login to planetscale
pscale auth login

# Create database
pscale db create next-auth-example --region "us-east"

# Create branch dev
pscale branch create next-auth-example dev

# Connect to planet scale locally with a proxy
pscale connect next-auth-example dev --port 3309

# Generate credentials
# pscale password create <DATABASE_NAME> <BRANCH_NAME> <PASSWORD_NAME>

# Username:	8ltnvfyqn66vkg8mmbeq
# Password:	pscale_pw_gsEDFaIn19MAxxfh85VGLAQFOLSnYHXh8yR4P7PVYH5

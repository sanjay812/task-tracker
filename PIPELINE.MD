# CI/CD Pipeline Documentation

This repository uses **GitHub Actions** to build, test, package, and deploy the application.

## Overview

The pipeline performs the following stages:

1. **Build & Test** – Install dependencies, start Postgres, run tests.
2. **Build & Push Docker Image** – Build the image and push it to Docker Hub.
3. **Deploy to EC2** – Run a deployment script to update the application on an EC2 instance.

---

## Workflow Triggers

* **Push to `main`** → Automatic pipeline execution.
* **Manual trigger** → Can be started via *workflow_dispatch* in GitHub Actions UI.
* *(Optional)* Pull request trigger to `main` (currently commented out).

---

## Jobs

### 1. Build & Test

* Runs on **Ubuntu latest**.
* Steps:

  1. Checkout repository.
  2. Install Python 3.11.
  3. Cache Python dependencies for faster builds.
  4. Install dependencies from `requirements.txt`.
  5. Start **Postgres** (via Docker) with:

     * `POSTGRES_USER=postgres`
     * `POSTGRES_PASSWORD=password`
     * `POSTGRES_DB=postgres`
  6. Run tests with `pytest`.

If tests fail, the pipeline stops.

---

### 2. Build & Push Docker Image

* Runs after **Build & Test** succeeds.
* Steps:

  1. Checkout repository.
  2. Authenticate to Docker Hub using GitHub Secrets.
  3. Build Docker image: `81200/task-tracker:latest`.
  4. Push image to Docker Hub.

---

### 3. Deploy to EC2

* Runs deployment script `deploy.sh`.
* Secrets injected:

  * `EC2_PUBLIC_IP` → EC2 server IP.
  * `S3_BUCKET_NAME` → S3 bucket for storage.
  * `DOCKERHUB_USERNAME` / `DOCKERHUB_PASSWORD` → For pulling the image.
  * `IAM_ACCESS_KEY_ID` / `IAM_SECRET_ACCESS_KEY` → AWS access keys.

The script:

* Connects to EC2.
* Deploys the new Docker image.
* Configures S3 access.

---

## Secrets Used

All secrets are stored in GitHub → Repository → Settings → Secrets and variables.

* `DOCKERHUB_USERNAME`
* `DOCKERHUB_PASSWORD`
* `EC2_PUBLIC_IP`
* `S3_BUCKET_NAME`
* `IAM_ACCESS_KEY_ID`
* `IAM_SECRET_ACCESS_KEY`

---

## Deployment Flow

1. Developer pushes code → GitHub triggers workflow.
2. Tests run in CI.
3. If tests pass → Docker image is built & pushed.
4. Deployment script runs → New version deployed to EC2.

---

## Notes

* Ensure `deploy.sh` has execution permissions (`chmod +x`).
* Database credentials are hardcoded for testing; consider using secrets.
* For production, use stronger passwords and secure IAM roles.

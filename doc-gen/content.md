# What's New

v4 of this workflow consolidates the usage so a repo only needs to create one workflow file that will work
any branch.  The name of the branch is used to determine what kind of tag will be applied to an image. 
There is also only one role required for this new workflow.  The new AWS role names are generated in the form
`ghr-<repo-name>-push` for workflows on branches that can push images and `ghr-<repo-name>-pull` for other
branches that are used for pull requests.

This workflow also supports passing a centrally configured value that is the interation value 
(i.e: the major.minor version numbers) for that project.  Since GitHub only support secrets for such a
centrally configured value, the input for this workflow must also be a secret.  This is a breaking change
from the previous version of this workflow.

# Usage

<!-- start usage -->
```yaml
name: Publish Container Image
on:
  workflow_dispatch:
  push:
    # Trigger the workflow on a push to any of the protected branches.  This is expected to 
    # be from an approved Pull Request
    branches:
      - dev
      - release
      - main
      - main-review
jobs:
  publish-image:
    name: Publish Container Image
    uses: acceleratelearning/workflow-container-image-publish/.github/workflows/shared-workflow.yaml@v4
    with:
      registry: 669462986110.dkr.ecr.us-east-2.amazonaws.com
      repository-name: sandbox/service/backend
      role-to-assume: arn:aws:iam::669462986110:role/ghr-container-sandbox-service-backend-push
      title: Demoapp backend image
      description: Sample container for testing
      authors: cloud-engineering-leads
      documentation-url: https://github.com/acceleratelearning/container-sandbox-service-backend
      helm-github-repo: https://github.com/acceleratelearning/kubernetes-stemscopes-v4-dev-app.git
      helm-values-path: demoapp-backend
      helm-values-expression: .backend.tag
    secrets:
      major-minor-version: ${{ secrets.LONESTAR_VERSION }}
      docker-github-app-id: ${{ secrets.COMPOSER_APP_ID }}
      docker-github-app-key: ${{ secrets.COMPOSER_APP_KEY }}
      helm-github-app-id: ${{ secrets.ALI_GITHUB_REPO_UPDATER_APP_ID }}
      helm-github-app-key: ${{ secrets.ALI_GITHUB_REPO_UPDATER_APP_KEY }}
```
<!-- end usage -->
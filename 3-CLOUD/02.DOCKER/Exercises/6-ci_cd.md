Here's an exercise for your students that guides them through integrating a CI/CD pipeline into their Django project using GitHub Actions.

---

## **Exercise: Adding CI/CD to Your Django Project**

### **Objective**
Set up a GitHub Actions workflow for Continuous Integration (CI) in your Django project. The workflow will:
- Run on every push to the `main` branch.
- Set up a PostgreSQL database.
- Install dependencies.
- Apply migrations.
- Run Django tests.

---

### **Instructions**
1. **Navigate to Your Project Directory**  
   Ensure you are inside your Django project's root directory.

2. **Create a `.github/workflows` Directory**  
   If it doesn’t exist, create the required directory structure:
   ```bash
   mkdir -p .github/workflows
   ```

3. **Create a CI Workflow File**  
   Inside the `.github/workflows` directory, create a new YAML file named `django-ci.yml`:
   ```bash
   touch .github/workflows/django-ci.yml
   ```

4. **Edit the Workflow File**  
   Open the file in a text editor and copy the following contents into it:

   ```yaml
   name: Django CI

   on:
     push:
       branches: [ "main" ]
     workflow_dispatch:

   jobs:
     build:
       runs-on: ubuntu-latest
       services:
         postgres:
           image: postgres:14
           env:
             POSTGRES_USER: myprojectuser2
             POSTGRES_PASSWORD: password
             POSTGRES_DB: myproject
           ports:
             - 5432:5432


       steps:
         # Step 1: Checkout Code
         - name: Checkout Code
           uses: actions/checkout@v4

         # Step 2: Set up Python
         - name: Set up Python
           uses: actions/setup-python@v3
           with:
             python-version: '3.10'

         # Step 3: Install Dependencies
         - name: Install Dependencies
           run: |
             python -m pip install --upgrade pip
             pip install -r requirements.txt

         # Step 4: Set Environment Variables
         - name: Set Environment Variables
           run: echo "DATABASE_HOST=postgres" >> $GITHUB_ENV

         # Step 5: Run Migrations
         - name: Run Migrations
           run: python manage.py migrate

         # Step 6: Run Tests
         - name: Run Tests
           run: python manage.py test
   ```

5. **Commit and Push Changes**  
   Add the workflow file to Git and push it to GitHub:
   ```bash
   git add .github/workflows/django-ci.yml
   git commit -m "Added GitHub Actions workflow for CI"
   git push origin main
   ```

6. **Check Your GitHub Actions**  
   - Go to your GitHub repository.
   - Click on the **Actions** tab.
   - You should see the workflow running whenever you push to `main`.

7. **Display a build status badge in the README.**


Once the workflow is pushed and runs successfully, you can add a status badge to your repository's README.

- Find Your Badge URL

- Go to your GitHub repository.
- Click on the Actions tab.
- Select the Django CI workflow.
- Click the "..." (three dots) button next to Run workflow and select Create status badge.
- Copy the Markdown code provided.
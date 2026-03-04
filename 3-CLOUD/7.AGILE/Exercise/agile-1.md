

## Final Project: Setting Up a Group Repository & Agile Board with GitHub

###  **Goal**
Students will **create a shared GitHub repository**, invite their team members, and set up an **Agile workflow** with GitHub Projects. They will define **Epics, User Stories, and Tasks** for their final Django project.

---


###  **1. Create a Group Repository**
1. One team member should create a **new repository** on GitHub (`<your-project-name>`).
2. Set the repository as **private** (optional).
3. Navigate to **Settings → Collaborators** and invite all team members.
4. Set up a **.gitignore** file for Django:
   ```bash
   echo "venv/" >> .gitignore
   echo "__pycache__/" >> .gitignore
   echo "db.sqlite3" >> .gitignore
   echo ".env" >> .gitignore
   git add .gitignore
   git commit -m "Added Django .gitignore"
   git push origin main
   ```

---

###  **2. Initialize GitHub Projects (Agile Board)**
1. Go to the **GitHub repository** and click on the **"Projects"** tab.
2. Create a **new project** (e.g., `Django Final Project`).
3. Select **"Board"** as the layout.

---

###  **3. Define Agile Workflow**
- Create **3 columns** in your Agile board:
  - **To Do** → For tasks not started yet
  - **In Progress** → Tasks currently being worked on
  - **Done** → Completed tasks

---

###  **4. Define Epics & User Stories**
1. Click **"+ Add Item"** to create Epics (high-level features).
2. Use the **prefix "[Epic]"** for Epics:
   - **Example Epics:**
     - `[Epic] User Authentication`
     - `[Epic] Blog Post Management`
     - `[Epic] API Development`
   
3. Under each Epic, create **User Stories** in the format:
   - **As a** `<user role>`, **I want to** `<feature>` **so that** `<benefit>`.
   - **Example User Stories:**
     - `As a user, I want to register and log in so that I can access my account.`
     - `As an admin, I want to delete user comments so that I can moderate discussions.`

---

###  **5. Create Issues & Link to Agile Board**
1. Open the **Issues** tab.
2. Click **New Issue** and create an issue for each user story.
3. Add the **correct label** (`bug`, `feature`, `enhancement`, etc.).
4. Assign the **correct team member**.
5. Link each issue to a **corresponding item** on the Agile Board.

---

###  **6. Set Up Git Branching Workflow**
1. Main branches:
   - `main` → Stable production-ready branch
   - `develop` → For ongoing development
2. Feature branches:
   - Each new feature should have a separate branch:
     ```bash
     git checkout -b feature/authentication
     ```
   - After coding, push and create a pull request (PR) to merge:
     ```bash
     git add .
     git commit -m "Added authentication system"
     git push origin feature/authentication
     ```


###  **Example**
**GitHub Repository Structure:**
```
Django-Final-Project/
│── .github/workflows/ 
│── my_project/ (Django app)
│── requirements.txt
│── README.md
│── .gitignore
│── manage.py

```


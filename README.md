# 🎓 Campus Recruitment Portal

[![Live Demo](https://img.shields.io/badge/Live-Demo-brightgreen.svg)](https://campusrecuriment-production.up.railway.app/)
[![Android App](https://img.shields.io/badge/Download-APK-blue.svg)](#mobile-application)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Thymeleaf](https://img.shields.io/badge/Thymeleaf-HTML5-green.svg)](https://www.thymeleaf.org/)

A comprehensive, web-based and mobile-friendly Campus Recruitment Portal designed to bridge the gap between college students and visiting companies. This platform enables students to register, create detailed academic profiles, upload resumes, and seamlessly apply for job opportunities posted by employers.

## 🌟 Key Features

### For Students (Job Seekers)
* **Profile Management:** Register, login, and maintain a detailed academic profile.
* **Resume Handling:** Securely upload and manage resumes (supports local and cloud storage).
* **Smart Search:** Search and filter available jobs by category, location, and experience.
* **Application Tracking:** Apply for jobs and track application status through a dedicated dashboard.
* **Real-time Notifications:** Receive email and dashboard notifications when shortlisted by employers.
* **Mobile Access:** Native Android application (.apk) available for on-the-go access.

### For Employers & Admins
* **Job Management:** Post, edit, and delete job listings (including title, description, skills, and salary).
* **Applicant Tracking:** View and manage applicants for posted jobs.
* **Streamlined Recruitment:** Shortlist or reject applications efficiently.
* **Interview Scheduling:** Organize and schedule interviews with shortlisted candidates.
* **Analytics Dashboard:** View key metrics (total applications, shortlisted candidates).

## 🛠️ Technical Stack

### Backend
* **Framework:** Spring Boot + Spring MVC
* **API Design:** REST APIs for CRUD operations (`@RestController`, `@Controller`)
* **Validation:** Hibernate Validator (`@NotNull`, `@Size`)
* **Error Handling:** Global Exception Handling via `@ControllerAdvice`
* **Security:** Spring Security for role-based access control (Student, Employer, Admin) with secure password hashing.
* **Email Service:** Integration with external email APIs for notifications.

### Database
* **ORM:** Spring Data JPA
* **Database Management:** MySQL / H2 Database
* **Entity Relationships:** One-to-Many (Employer → Jobs), Many-to-One (Application → Job/User)

### Frontend
* **Templating:** Thymeleaf
* **Styling:** HTML5, CSS3, Responsive Web Design (Mobile/Tablet/Desktop)
* **Interactivity:** Vanilla JavaScript / ES6 for dynamic table filtering.

## 🚀 Live Demo & Mobile Application

* **Web Portal:** [Access the Live Portal Here](https://campusrecuriment-production.up.railway.app/auth/login?logout=true) (Hosted on Railway)
* **Mobile Application:** An Android `.apk` file is provided in the `android-apk` folder for a native mobile experience. It utilizes WebViews to deliver a seamless interface on Android devices.

## 💻 Getting Started (Local Setup)

To run this project locally, follow these steps:

### Prerequisites
* Java Development Kit (JDK) 17 or higher
* Maven
* MySQL Server (or use H2 in-memory DB)
* IDE of your choice (VS Code, IntelliJ IDEA, Eclipse)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/campus-recruitment-portal.git
   cd campus-recruitment-portal
   ```

2. **Configure Database:**
   Update the `src/main/resources/application.properties` file with your database credentials.

3. **Run the application:**
   You can run the application directly from your IDE or using the provided batch script:
   ```bash
   ./START_BACKEND.bat
   ```
   Or via Maven:
   ```bash
   mvn spring-boot:run
   ```

4. **Access the portal:**
   Open your browser and navigate to `http://localhost:8080`.

## 🤝 How to Contribute (Open Source Best Practices)

We welcome and encourage contributions from the community! To become a great open-source contributor, follow these guidelines:

### Contribution Workflow
1. **Fork the Repository:** Click the 'Fork' button at the top right of this page.
2. **Clone your Fork:** `git clone https://github.com/your-username/campus-recruitment-portal.git`
3. **Create a Branch:** `git checkout -b feature/your-feature-name` (e.g., `feature/add-dark-mode` or `bugfix/login-issue`)
4. **Make Changes:** Implement your feature or bug fix. Keep your commits atomic and descriptive.
5. **Commit:** `git commit -m "Add descriptive message about your changes"`
6. **Push:** `git push origin feature/your-feature-name`
7. **Create a Pull Request (PR):** Go to the original repository and click "Compare & pull request". Provide a detailed description of your changes.

### Best Practices for Contributors
* **Read the Codebase:** Familiarize yourself with the architecture and coding style before making large changes.
* **Open an Issue First:** If you're planning a major feature, open an issue to discuss it with the maintainers before writing code.
* **Write Clean Code:** Ensure your code is well-commented and follows standard Java/Spring Boot conventions.
* **Test Your Changes:** Verify that your changes do not break existing functionality. Run the app locally.
* **Be Respectful:** Open source is a collaborative effort. Be polite and constructive in discussions and PR reviews.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

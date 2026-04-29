-- ============================================================
--  CAMPUS RECRUITMENT PORTAL - MySQL DATABASE SCRIPT
--  For Railway.app MySQL deployment
--  Run in MySQL Workbench or Railway MySQL shell
-- ============================================================

CREATE DATABASE IF NOT EXISTS CampusRecruitment
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE CampusRecruitment;

-- ============================================================
-- 1. USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100)   NOT NULL,
    email         VARCHAR(255)   NOT NULL UNIQUE,
    password      VARCHAR(255)   NOT NULL,
    role          ENUM('STUDENT','EMPLOYER','ADMIN') NOT NULL,
    enabled       BOOLEAN        NOT NULL DEFAULT FALSE,
    approved      BOOLEAN        NOT NULL DEFAULT TRUE,
    phone         VARCHAR(20),
    otp           VARCHAR(10),
    otp_expiry    DATETIME,
    created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 2. LOGIN AUDIT LOG
-- ============================================================
CREATE TABLE IF NOT EXISTS login_audit_log (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT         NOT NULL,
    email         VARCHAR(255)   NOT NULL,
    role          VARCHAR(20),
    login_time    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    logout_time   DATETIME,
    ip_address    VARCHAR(50),
    login_status  ENUM('SUCCESS','FAILED','LOCKED') NOT NULL DEFAULT 'SUCCESS',
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 3. OTP VERIFICATION LOG
-- ============================================================
CREATE TABLE IF NOT EXISTS otp_verification_log (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT         NOT NULL,
    email           VARCHAR(255)   NOT NULL,
    otp_code        VARCHAR(10)    NOT NULL,
    otp_generated   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    otp_expiry      DATETIME       NOT NULL,
    verified_at     DATETIME,
    is_verified     BOOLEAN        NOT NULL DEFAULT FALSE,
    purpose         ENUM('EMAIL_VERIFY','PASSWORD_RESET','LOGIN_2FA') DEFAULT 'EMAIL_VERIFY',
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 4. STUDENT PROFILES
-- ============================================================
CREATE TABLE IF NOT EXISTS student_profiles (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT         NOT NULL UNIQUE,
    department          VARCHAR(100),
    degree              VARCHAR(100),
    year                VARCHAR(20),
    roll_number         VARCHAR(50),
    cgpa                DOUBLE,
    skills              TEXT,
    technical_skills    TEXT,
    projects            TEXT,
    experience          TEXT,
    certifications      TEXT,
    summary             TEXT,
    resume_path         VARCHAR(500),
    linkedin_url        VARCHAR(500),
    github_url          VARCHAR(500),
    ai_recommendations  TEXT,
    profile_updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 5. EMPLOYER PROFILES
-- ============================================================
CREATE TABLE IF NOT EXISTS employer_profiles (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id           BIGINT         NOT NULL UNIQUE,
    company_name      VARCHAR(200),
    company_website   VARCHAR(500),
    industry          VARCHAR(100),
    company_size      VARCHAR(50),
    hq_location       VARCHAR(200),
    about_company     TEXT,
    contact_person    VARCHAR(100),
    contact_phone     VARCHAR(20),
    logo_path         VARCHAR(500),
    approved_by_admin BOOLEAN DEFAULT FALSE,
    approved_at       DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 6. JOBS
-- ============================================================
CREATE TABLE IF NOT EXISTS jobs (
    id                   BIGINT AUTO_INCREMENT PRIMARY KEY,
    employer_id          BIGINT         NOT NULL,
    title                VARCHAR(200)   NOT NULL,
    description          TEXT           NOT NULL,
    skills_required      TEXT,
    location             VARCHAR(200),
    category             VARCHAR(100),
    experience_level     VARCHAR(50),
    salary_range         VARCHAR(100),
    package_offered      VARCHAR(100),
    openings             INT,
    min_cgpa             DOUBLE,
    eligible_departments TEXT,
    status               ENUM('ACTIVE','CLOSED','DRAFT') NOT NULL DEFAULT 'ACTIVE',
    youtube_video_url    TEXT,
    posted_at            DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deadline             DATETIME,
    FOREIGN KEY (employer_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 7. APPLICATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS applications (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id        BIGINT         NOT NULL,
    job_id            BIGINT         NOT NULL,
    status            ENUM('PENDING','UNDER_REVIEW','SHORTLISTED','INTERVIEW_SCHEDULED','SELECTED','REJECTED')
                                     NOT NULL DEFAULT 'PENDING',
    cover_letter      TEXT,
    ai_match_score    DOUBLE,
    assessment_score  INT,
    employer_notes    TEXT,
    applied_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_updated      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY UQ_student_job (student_id, job_id),
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (job_id)     REFERENCES jobs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 8. INTERVIEWS
-- ============================================================
CREATE TABLE IF NOT EXISTS interviews (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id   BIGINT         NOT NULL UNIQUE,
    interview_date   DATE,
    interview_time   TIME,
    slot             VARCHAR(100),
    venue            VARCHAR(300),
    meet_link        VARCHAR(500),
    interviewer_name VARCHAR(100),
    status           ENUM('SCHEDULED','COMPLETED','CANCELLED','RESCHEDULED') NOT NULL DEFAULT 'SCHEDULED',
    notes            TEXT,
    reminder_sent    BOOLEAN        NOT NULL DEFAULT FALSE,
    FOREIGN KEY (application_id) REFERENCES applications(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 9. ASSESSMENT QUESTIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS assessment_questions (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_id          BIGINT         NOT NULL,
    question_text   TEXT           NOT NULL,
    option_a        VARCHAR(500)   NOT NULL,
    option_b        VARCHAR(500)   NOT NULL,
    option_c        VARCHAR(500)   NOT NULL,
    option_d        VARCHAR(500)   NOT NULL,
    correct_option  CHAR(1)        NOT NULL,
    FOREIGN KEY (job_id) REFERENCES jobs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 10. NOTIFICATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT         NOT NULL,
    title       VARCHAR(300),
    message     TEXT,
    link        VARCHAR(500),
    is_read     BOOLEAN        NOT NULL DEFAULT FALSE,
    created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- 1 ADMIN (password: admin123 - BCrypt encoded)
INSERT IGNORE INTO users (full_name, email, password, role, enabled, approved, phone, created_at)
VALUES ('Campus Admin', 'admin@campus.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'ADMIN', TRUE, TRUE, '9000000000', NOW());

-- 2 EMPLOYERS
INSERT IGNORE INTO users (full_name, email, password, role, enabled, approved, phone, created_at)
VALUES
('HR TechCorp', 'hr@techcorp.com',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'EMPLOYER', TRUE, TRUE, '9111111111', NOW()),
('HR InnoSoft', 'hr@innosoft.com',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'EMPLOYER', TRUE, TRUE, '9222222222', NOW());

-- 3 STUDENTS
INSERT IGNORE INTO users (full_name, email, password, role, enabled, approved, phone, created_at)
VALUES
('Arun Kumar',   'student1@veltech.edu.in', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'STUDENT', TRUE, TRUE, '9333333333', NOW()),
('Priya Sharma', 'student2@veltech.edu.in', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'STUDENT', TRUE, TRUE, '9444444444', NOW()),
('Raj Patel',    'student3@veltech.edu.in', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'STUDENT', TRUE, TRUE, '9555555555', NOW());

-- NOTE: All sample users have password = "admin123"
-- ============================================================
-- VIEW ALL TABLES
-- ============================================================
SELECT * FROM users ORDER BY role, id;
SELECT * FROM student_profiles ORDER BY id;
SELECT * FROM employer_profiles ORDER BY id;
SELECT * FROM jobs ORDER BY posted_at DESC;
SELECT * FROM applications ORDER BY applied_at DESC;
SELECT * FROM interviews ORDER BY interview_date;
SELECT * FROM assessment_questions ORDER BY job_id, id;
SELECT * FROM notifications ORDER BY created_at DESC;

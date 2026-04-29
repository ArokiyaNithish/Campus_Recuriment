-- ============================================================
--  CAMPUS RECRUITMENT PORTAL - COMPLETE DATABASE SCRIPT
--  Database : CampusRecruitment  (already existing in SSMS)
--  Run this file in SSMS : File > Open > D:\tttt\CampusRecruitment_SSMS.sql
-- ============================================================

USE CampusRecruitment;
GO

-- ============================================================
-- 1. USERS TABLE (Admin / Student / Employer)
-- ============================================================
IF OBJECT_ID('users','U') IS NULL
BEGIN
    CREATE TABLE users (
        id            BIGINT IDENTITY(1,1) PRIMARY KEY,
        full_name     NVARCHAR(100)  NOT NULL,
        email         NVARCHAR(255)  NOT NULL UNIQUE,
        password      NVARCHAR(255)  NOT NULL,
        role          NVARCHAR(20)   NOT NULL CHECK(role IN ('STUDENT','EMPLOYER','ADMIN')),
        enabled       BIT            NOT NULL DEFAULT 0,
        approved      BIT            NOT NULL DEFAULT 1,
        phone         NVARCHAR(20),
        otp           NVARCHAR(10),
        otp_expiry    DATETIME2,
        created_at    DATETIME2      NOT NULL DEFAULT GETDATE()
    );
    PRINT 'Table [users] created.';
END
ELSE
    PRINT 'Table [users] already exists - skipped.';
GO

-- ============================================================
-- 2. LOGIN AUDIT LOG (login time, logout time, IP, status)
-- ============================================================
IF OBJECT_ID('login_audit_log','U') IS NULL
BEGIN
    CREATE TABLE login_audit_log (
        id            BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id       BIGINT         NOT NULL REFERENCES users(id),
        email         NVARCHAR(255)  NOT NULL,
        role          NVARCHAR(20),
        login_time    DATETIME2      NOT NULL DEFAULT GETDATE(),
        logout_time   DATETIME2,
        ip_address    NVARCHAR(50),
        login_status  NVARCHAR(20)   NOT NULL DEFAULT 'SUCCESS'
                                     CHECK(login_status IN ('SUCCESS','FAILED','LOCKED'))
    );
    PRINT 'Table [login_audit_log] created.';
END
ELSE
    PRINT 'Table [login_audit_log] already exists - skipped.';
GO

-- ============================================================
-- 3. OTP VERIFICATION LOG
-- ============================================================
IF OBJECT_ID('otp_verification_log','U') IS NULL
BEGIN
    CREATE TABLE otp_verification_log (
        id              BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id         BIGINT         NOT NULL REFERENCES users(id),
        email           NVARCHAR(255)  NOT NULL,
        otp_code        NVARCHAR(10)   NOT NULL,
        otp_generated   DATETIME2      NOT NULL DEFAULT GETDATE(),
        otp_expiry      DATETIME2      NOT NULL,
        verified_at     DATETIME2,
        is_verified     BIT            NOT NULL DEFAULT 0,
        purpose         NVARCHAR(50)   DEFAULT 'EMAIL_VERIFY'
                                       CHECK(purpose IN ('EMAIL_VERIFY','PASSWORD_RESET','LOGIN_2FA'))
    );
    PRINT 'Table [otp_verification_log] created.';
END
ELSE
    PRINT 'Table [otp_verification_log] already exists - skipped.';
GO

-- ============================================================
-- 4. STUDENT PROFILES
-- ============================================================
IF OBJECT_ID('student_profiles','U') IS NULL
BEGIN
    CREATE TABLE student_profiles (
        id                  BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id             BIGINT         NOT NULL UNIQUE REFERENCES users(id),
        department          NVARCHAR(100),
        degree              NVARCHAR(100),
        year                NVARCHAR(20),
        roll_number         NVARCHAR(50),
        cgpa                FLOAT,
        skills              NVARCHAR(MAX),
        technical_skills    NVARCHAR(MAX),
        projects            NVARCHAR(MAX),
        experience          NVARCHAR(MAX),
        certifications      NVARCHAR(MAX),
        summary             NVARCHAR(MAX),
        resume_path         NVARCHAR(500),
        linkedin_url        NVARCHAR(500),
        github_url          NVARCHAR(500),
        ai_recommendations  NVARCHAR(MAX),
        profile_updated_at  DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table [student_profiles] created.';
END
ELSE
    PRINT 'Table [student_profiles] already exists - skipped.';
GO

-- ============================================================
-- 5. EMPLOYER PROFILES
-- ============================================================
IF OBJECT_ID('employer_profiles','U') IS NULL
BEGIN
    CREATE TABLE employer_profiles (
        id               BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id          BIGINT         NOT NULL UNIQUE REFERENCES users(id),
        company_name     NVARCHAR(200),
        company_website  NVARCHAR(500),
        industry         NVARCHAR(100),
        company_size     NVARCHAR(50),
        hq_location      NVARCHAR(200),
        about_company    NVARCHAR(MAX),
        contact_person   NVARCHAR(100),
        contact_phone    NVARCHAR(20),
        logo_path        NVARCHAR(500),
        approved_by_admin BIT DEFAULT 0,
        approved_at      DATETIME2
    );
    PRINT 'Table [employer_profiles] created.';
END
ELSE
    PRINT 'Table [employer_profiles] already exists - skipped.';
GO

-- ============================================================
-- 6. JOBS (posted by Employers)
-- ============================================================
IF OBJECT_ID('jobs','U') IS NULL
BEGIN
    CREATE TABLE jobs (
        id                   BIGINT IDENTITY(1,1) PRIMARY KEY,
        employer_id          BIGINT         NOT NULL REFERENCES users(id),
        title                NVARCHAR(200)  NOT NULL,
        description          NVARCHAR(MAX)  NOT NULL,
        skills_required      NVARCHAR(MAX),
        location             NVARCHAR(200),
        category             NVARCHAR(100),
        experience_level     NVARCHAR(50),
        salary_range         NVARCHAR(100),
        package_offered      NVARCHAR(100),
        openings             INT,
        min_cgpa             FLOAT,
        eligible_departments NVARCHAR(MAX),
        status               NVARCHAR(20)   NOT NULL DEFAULT 'ACTIVE'
                                            CHECK(status IN ('ACTIVE','CLOSED','DRAFT')),
        youtube_video_url    NVARCHAR(500),
        posted_at            DATETIME2      NOT NULL DEFAULT GETDATE(),
        deadline             DATETIME2
    );
    PRINT 'Table [jobs] created.';
END
ELSE
    PRINT 'Table [jobs] already exists - skipped.';
GO

-- ============================================================
-- 7. APPLICATIONS (Student applies to Job)
-- ============================================================
IF OBJECT_ID('applications','U') IS NULL
BEGIN
    CREATE TABLE applications (
        id                BIGINT IDENTITY(1,1) PRIMARY KEY,
        student_id        BIGINT         NOT NULL REFERENCES users(id),
        job_id            BIGINT         NOT NULL REFERENCES jobs(id),
        status            NVARCHAR(30)   NOT NULL DEFAULT 'PENDING'
                                         CHECK(status IN ('PENDING','UNDER_REVIEW','SHORTLISTED',
                                                          'INTERVIEW_SCHEDULED','SELECTED','REJECTED')),
        cover_letter      NVARCHAR(MAX),
        ai_match_score    FLOAT,
        assessment_score  INT,
        employer_notes    NVARCHAR(MAX),
        applied_at        DATETIME2      NOT NULL DEFAULT GETDATE(),
        last_updated      DATETIME2      NOT NULL DEFAULT GETDATE(),
        CONSTRAINT UQ_student_job UNIQUE(student_id, job_id)
    );
    PRINT 'Table [applications] created.';
END
ELSE
    PRINT 'Table [applications] already exists - skipped.';
GO

-- ============================================================
-- 8. INTERVIEWS
-- ============================================================
IF OBJECT_ID('interviews','U') IS NULL
BEGIN
    CREATE TABLE interviews (
        id               BIGINT IDENTITY(1,1) PRIMARY KEY,
        application_id   BIGINT         NOT NULL UNIQUE REFERENCES applications(id),
        interview_date   DATE,
        interview_time   TIME,
        slot             NVARCHAR(100),
        venue            NVARCHAR(300),
        meet_link        NVARCHAR(500),
        interviewer_name NVARCHAR(100),
        status           NVARCHAR(20)   NOT NULL DEFAULT 'SCHEDULED'
                                        CHECK(status IN ('SCHEDULED','COMPLETED','CANCELLED','RESCHEDULED')),
        notes            NVARCHAR(MAX),
        reminder_sent    BIT            NOT NULL DEFAULT 0
    );
    PRINT 'Table [interviews] created.';
END
ELSE
    PRINT 'Table [interviews] already exists - skipped.';
GO

-- ============================================================
-- 9. ASSESSMENT QUESTIONS
-- ============================================================
IF OBJECT_ID('assessment_questions','U') IS NULL
BEGIN
    CREATE TABLE assessment_questions (
        id              BIGINT IDENTITY(1,1) PRIMARY KEY,
        job_id          BIGINT         NOT NULL REFERENCES jobs(id),
        question_text   NVARCHAR(MAX)  NOT NULL,
        option_a        NVARCHAR(500)  NOT NULL,
        option_b        NVARCHAR(500)  NOT NULL,
        option_c        NVARCHAR(500)  NOT NULL,
        option_d        NVARCHAR(500)  NOT NULL,
        correct_option  NVARCHAR(1)    NOT NULL CHECK(correct_option IN ('A','B','C','D'))
    );
    PRINT 'Table [assessment_questions] created.';
END
ELSE
    PRINT 'Table [assessment_questions] already exists - skipped.';
GO

-- ============================================================
-- 10. NOTIFICATIONS
-- ============================================================
IF OBJECT_ID('notifications','U') IS NULL
BEGIN
    CREATE TABLE notifications (
        id          BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id     BIGINT         NOT NULL REFERENCES users(id),
        title       NVARCHAR(300),
        message     NVARCHAR(MAX),
        link        NVARCHAR(500),
        is_read     BIT            NOT NULL DEFAULT 0,
        created_at  DATETIME2      NOT NULL DEFAULT GETDATE()
    );
    PRINT 'Table [notifications] created.';
END
ELSE
    PRINT 'Table [notifications] already exists - skipped.';
GO

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- 1 ADMIN
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@campus.com')
BEGIN
    INSERT INTO users (full_name, email, password, role, enabled, approved, phone, created_at)
    VALUES ('Campus Admin', 'admin@campus.com',
            '$2a$10$AdminHashedPasswordHere', 'ADMIN', 1, 1, '9000000000', GETDATE());
    PRINT 'Admin user inserted.';
END
GO

-- 2 EMPLOYERS
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'hr@techcorp.com')
BEGIN
    INSERT INTO users (full_name, email, password, role, enabled, approved, phone, created_at)
    VALUES
    ('HR TechCorp',   'hr@techcorp.com',   '$2a$10$EmpHash1', 'EMPLOYER', 1, 1, '9111111111', GETDATE()),
    ('HR InnoSoft',   'hr@innosoft.com',   '$2a$10$EmpHash2', 'EMPLOYER', 1, 1, '9222222222', GETDATE());
    PRINT 'Employer users inserted.';
END
GO

-- Employer Profiles
IF NOT EXISTS (SELECT 1 FROM employer_profiles WHERE company_name = 'TechCorp Solutions')
BEGIN
    INSERT INTO employer_profiles
        (user_id, company_name, company_website, industry, company_size, hq_location, about_company,
         contact_person, contact_phone, approved_by_admin, approved_at)
    VALUES
    (2, 'TechCorp Solutions', 'https://techcorp.com', 'IT Services',   '1000-5000',
        'Chennai, TN', 'Leading IT services company.', 'Priya R', '9111111111', 1, GETDATE()),
    (3, 'InnoSoft Pvt Ltd',   'https://innosoft.com', 'Software Dev',  '500-1000',
        'Bengaluru, KA','Innovative software company.','Karan M', '9222222222', 1, GETDATE());
    PRINT 'Employer profiles inserted.';
END
GO

-- 3 STUDENTS
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'student1@veltech.edu.in')
BEGIN
    INSERT INTO users (full_name, email, password, role, enabled, approved, phone, created_at)
    VALUES
    ('Arun Kumar',    'student1@veltech.edu.in', '$2a$10$StuHash1', 'STUDENT', 1, 1, '9333333333', GETDATE()),
    ('Priya Sharma',  'student2@veltech.edu.in', '$2a$10$StuHash2', 'STUDENT', 1, 1, '9444444444', GETDATE()),
    ('Raj Patel',     'student3@veltech.edu.in', '$2a$10$StuHash3', 'STUDENT', 1, 1, '9555555555', GETDATE());
    PRINT 'Student users inserted.';
END
GO

-- Student Profiles
IF NOT EXISTS (SELECT 1 FROM student_profiles WHERE roll_number = 'VTU21001')
BEGIN
    INSERT INTO student_profiles
        (user_id, department, degree, year, roll_number, cgpa, skills, technical_skills,
         projects, experience, certifications, linkedin_url, github_url)
    VALUES
    (4, 'Computer Science', 'B.Tech', 'Final Year', 'VTU21001', 8.7,
        'Java, Python, SQL', 'Spring Boot, React, MySQL',
        'Campus Portal, Inventory System', '2 months internship at StartupX',
        'AWS Cloud Practitioner, Oracle Java SE',
        'linkedin.com/in/arunkumar', 'github.com/arunkumar'),
    (5, 'Information Technology', 'B.Tech', 'Final Year', 'VTU21002', 9.1,
        'Python, ML, Data Analysis', 'TensorFlow, Pandas, Power BI',
        'Sales Prediction ML Model, Chatbot',  'Internship at DataSoft',
        'Google Data Analytics, Python PCEP',
        'linkedin.com/in/priyasharma', 'github.com/priyasharma'),
    (6, 'Electronics', 'B.Tech', 'Final Year', 'VTU21003', 7.8,
        'C, Embedded, IoT', 'Arduino, Raspberry Pi, MATLAB',
        'Smart Home Automation, Weather Station', 'Lab Assistant 6 months',
        'NPTEL IoT, Embedded C',
        'linkedin.com/in/rajpatel', 'github.com/rajpatel');
    PRINT 'Student profiles inserted.';
END
GO

-- 2 JOBS
IF NOT EXISTS (SELECT 1 FROM jobs WHERE title = 'Software Engineer - Java')
BEGIN
    INSERT INTO jobs
        (employer_id, title, description, skills_required, location, category,
         experience_level, salary_range, package_offered, openings, min_cgpa,
         eligible_departments, status, posted_at, deadline)
    VALUES
    (2, 'Software Engineer - Java',
        'Develop and maintain Java-based enterprise applications.',
        'Java, Spring Boot, SQL, REST APIs',
        'Chennai', 'Software Development', 'Entry',
        '4 LPA - 6 LPA', '5 LPA', 10, 7.5,
        'Computer Science, Information Technology',
        'ACTIVE', GETDATE(), DATEADD(DAY, 30, GETDATE())),

    (3, 'Data Analyst',
        'Analyze datasets and build dashboards for business insights.',
        'Python, SQL, Power BI, Excel',
        'Bengaluru', 'Data & Analytics', 'Entry',
        '3 LPA - 5 LPA', '4 LPA', 5, 7.0,
        'Computer Science, Information Technology, Electronics',
        'ACTIVE', GETDATE(), DATEADD(DAY, 20, GETDATE()));
    PRINT 'Jobs inserted.';
END
GO

-- APPLICATIONS
IF NOT EXISTS (SELECT 1 FROM applications WHERE student_id = 4 AND job_id = 1)
BEGIN
    INSERT INTO applications
        (student_id, job_id, status, cover_letter, ai_match_score, assessment_score, applied_at, last_updated)
    VALUES
    (4, 1, 'SHORTLISTED',        'I am passionate about Java development...', 88.5, 4, GETDATE(), GETDATE()),
    (5, 1, 'UNDER_REVIEW',       'I have strong backend skills....',           75.0, 3, GETDATE(), GETDATE()),
    (5, 2, 'INTERVIEW_SCHEDULED','My Python and ML skills match perfectly...', 91.0, 5, GETDATE(), GETDATE()),
    (6, 2, 'PENDING',            'I want to start my data career here...',     65.0, 2, GETDATE(), GETDATE());
    PRINT 'Applications inserted.';
END
GO

-- INTERVIEW
IF NOT EXISTS (SELECT 1 FROM interviews WHERE application_id = 3)
BEGIN
    INSERT INTO interviews
        (application_id, interview_date, interview_time, slot, venue, meet_link,
         interviewer_name, status, notes, reminder_sent)
    VALUES
    (3, '2026-05-10', '10:00', '10:00 AM - 10:30 AM',
     'Google Meet', 'https://meet.google.com/abc-defg-hij',
     'Karan Mehta', 'SCHEDULED',
     'Please be ready 5 min before the slot.', 0);
    PRINT 'Interview inserted.';
END
GO

-- ASSESSMENT QUESTIONS
IF NOT EXISTS (SELECT 1 FROM assessment_questions WHERE job_id = 1)
BEGIN
    INSERT INTO assessment_questions (job_id, question_text, option_a, option_b, option_c, option_d, correct_option)
    VALUES
    (1, 'Which keyword is used to inherit a class in Java?',
        'implement', 'extends', 'inherits', 'super', 'B'),
    (1, 'What is the default value of a boolean in Java?',
        'true', 'null', 'false', '0', 'C'),
    (2, 'Which Python library is used for data manipulation?',
        'NumPy', 'Pandas', 'Matplotlib', 'Seaborn', 'B');
    PRINT 'Assessment questions inserted.';
END
GO

-- OTP VERIFICATION LOG (sample)
IF NOT EXISTS (SELECT 1 FROM otp_verification_log WHERE user_id = 4)
BEGIN
    INSERT INTO otp_verification_log
        (user_id, email, otp_code, otp_generated, otp_expiry, verified_at, is_verified, purpose)
    VALUES
    (4, 'student1@veltech.edu.in', '483921', DATEADD(MINUTE,-5,GETDATE()),
        DATEADD(MINUTE,5,GETDATE()), GETDATE(), 1, 'EMAIL_VERIFY'),
    (5, 'student2@veltech.edu.in', '719302', DATEADD(MINUTE,-2,GETDATE()),
        DATEADD(MINUTE,8,GETDATE()), GETDATE(), 1, 'EMAIL_VERIFY'),
    (2, 'hr@techcorp.com',        '552018', DATEADD(MINUTE,-1,GETDATE()),
        DATEADD(MINUTE,9,GETDATE()), GETDATE(), 1, 'EMAIL_VERIFY');
    PRINT 'OTP verification log inserted.';
END
GO

-- LOGIN AUDIT LOG (sample)
IF NOT EXISTS (SELECT 1 FROM login_audit_log WHERE user_id = 1)
BEGIN
    INSERT INTO login_audit_log (user_id, email, role, login_time, logout_time, ip_address, login_status)
    VALUES
    (1, 'admin@campus.com',          'ADMIN',    DATEADD(HOUR,-3,GETDATE()), DATEADD(HOUR,-1,GETDATE()), '192.168.1.1',  'SUCCESS'),
    (2, 'hr@techcorp.com',           'EMPLOYER', DATEADD(HOUR,-2,GETDATE()), DATEADD(MINUTE,-30,GETDATE()),'192.168.1.2','SUCCESS'),
    (4, 'student1@veltech.edu.in',   'STUDENT',  DATEADD(HOUR,-1,GETDATE()), NULL,                         '192.168.1.3','SUCCESS'),
    (5, 'student2@veltech.edu.in',   'STUDENT',  DATEADD(MINUTE,-45,GETDATE()),NULL,                       '192.168.1.4','SUCCESS'),
    (6, 'student3@veltech.edu.in',   'STUDENT',  DATEADD(MINUTE,-10,GETDATE()),NULL,                       '192.168.1.5','SUCCESS'),
    (4, 'student1@veltech.edu.in',   'STUDENT',  DATEADD(DAY,-1,GETDATE()),  DATEADD(DAY,-1,DATEADD(HOUR,2,GETDATE())),'192.168.1.3','SUCCESS');
    PRINT 'Login audit log inserted.';
END
GO

-- NOTIFICATIONS
IF NOT EXISTS (SELECT 1 FROM notifications WHERE user_id = 4)
BEGIN
    INSERT INTO notifications (user_id, title, message, link, is_read, created_at)
    VALUES
    (4, 'Application Shortlisted!',
        'Congratulations! You have been shortlisted for Software Engineer - Java at TechCorp Solutions.',
        '/student/applications', 0, GETDATE()),
    (5, 'New Job Posted!',
        'A new job "Data Analyst" has been posted by InnoSoft Pvt Ltd. Apply now!',
        '/student/jobs', 0, GETDATE()),
    (5, 'Interview Scheduled!',
        'Your interview for Data Analyst is scheduled on 10-May-2026 at 10:00 AM.',
        '/student/interviews', 0, GETDATE()),
    (2, 'New Application Received',
        'A student has applied for Software Engineer - Java.',
        '/employer/applications', 0, GETDATE()),
    (1, 'New Employer Registered',
        'InnoSoft Pvt Ltd has registered and is pending approval.',
        '/admin/users', 0, GETDATE());
    PRINT 'Notifications inserted.';
END
GO

-- ============================================================
-- VIEW ALL TABLES  (SELECT * FROM each table)
-- ============================================================
PRINT '============================================================';
PRINT '  SELECT * FROM ALL TABLES';
PRINT '============================================================';

-- 1. All Users  (Admin + Employer + Student)
PRINT '-- TABLE: users --';
SELECT * FROM users ORDER BY role, id;

-- 2. Login Audit Log
PRINT '-- TABLE: login_audit_log --';
SELECT * FROM login_audit_log ORDER BY login_time DESC;

-- 3. OTP Verification Log
PRINT '-- TABLE: otp_verification_log --';
SELECT * FROM otp_verification_log ORDER BY otp_generated DESC;

-- 4. Student Profiles
PRINT '-- TABLE: student_profiles --';
SELECT * FROM student_profiles ORDER BY id;

-- 5. Employer Profiles
PRINT '-- TABLE: employer_profiles --';
SELECT * FROM employer_profiles ORDER BY id;

-- 6. Jobs
PRINT '-- TABLE: jobs --';
SELECT * FROM jobs ORDER BY posted_at DESC;

-- 7. Applications
PRINT '-- TABLE: applications --';
SELECT * FROM applications ORDER BY applied_at DESC;

-- 8. Interviews
PRINT '-- TABLE: interviews --';
SELECT * FROM interviews ORDER BY interview_date, interview_time;

-- 9. Assessment Questions
PRINT '-- TABLE: assessment_questions --';
SELECT * FROM assessment_questions ORDER BY job_id, id;

-- 10. Notifications
PRINT '-- TABLE: notifications --';
SELECT * FROM notifications ORDER BY created_at DESC;

PRINT '============================================================';
PRINT '  ALL DONE - Check Results tabs in SSMS for all 10 tables';
PRINT '============================================================';

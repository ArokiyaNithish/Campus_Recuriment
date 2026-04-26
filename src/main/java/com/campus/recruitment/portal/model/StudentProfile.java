package com.campus.recruitment.portal.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "student_profiles")
@Data
@NoArgsConstructor
public class StudentProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    private String department;
    private String degree;
    private String year;
    private String rollNumber;
    private Double cgpa;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String skills;           // AI-extracted: comma separated

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String technicalSkills;  // AI-extracted

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String projects;         // AI-extracted

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String experience;       // AI-extracted

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String certifications;   // AI-extracted

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String summary;          // AI-generated profile summary

    private String resumePath;       // Path to uploaded resume file

    private String linkedinUrl;
    private String githubUrl;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String aiRecommendations; // AI job recommendations
}

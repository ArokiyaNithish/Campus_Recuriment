package com.campus.recruitment.portal.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "jobs")
@Data
@NoArgsConstructor
public class Job {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Size(min = 3, max = 200)
    private String title;

    @NotNull
    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String description;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String skillsRequired;

    private String location;
    private String category;
    private String experienceLevel; // Entry, Mid, Senior
    private String salaryRange;
    private String packageOffered;

    private Integer openings;
    private Double minCgpa;
    private String eligibleDepartments; // comma-separated

    @Enumerated(EnumType.STRING)
    private JobStatus status = JobStatus.ACTIVE;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String youtubeVideoUrl; // AI-suggested related YouTube video

    @ManyToOne
    @JoinColumn(name = "employer_id", nullable = false)
    private User employer;

    @OneToMany(mappedBy = "job", cascade = CascadeType.ALL)
    private List<Application> applications = new ArrayList<>();

    @Column(updatable = false)
    private LocalDateTime postedAt = LocalDateTime.now();
    private LocalDateTime deadline;

    public enum JobStatus {
        ACTIVE, CLOSED, DRAFT
    }
}

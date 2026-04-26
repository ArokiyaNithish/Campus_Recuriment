package com.campus.recruitment.portal.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "interviews")
@Data
@NoArgsConstructor
public class Interview {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "application_id", nullable = false, unique = true)
    private Application application;

    private LocalDate interviewDate;
    private LocalTime interviewTime;
    private String slot;         // e.g., "10:00 AM - 10:30 AM"
    private String venue;        // e.g., "Room 301 / Google Meet"
    private String meetLink;
    private String interviewerName;

    @Enumerated(EnumType.STRING)
    private InterviewStatus status = InterviewStatus.SCHEDULED;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String notes;

    public enum InterviewStatus {
        SCHEDULED, COMPLETED, CANCELLED, RESCHEDULED
    }
}

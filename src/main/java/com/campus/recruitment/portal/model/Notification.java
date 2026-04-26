package com.campus.recruitment.portal.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
@Data
@NoArgsConstructor
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String title;
    
    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String message;

    private String link; // Optional link to click from notification

    private boolean isRead = false;

    @Column(updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}

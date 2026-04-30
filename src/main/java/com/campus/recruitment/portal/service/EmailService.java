package com.campus.recruitment.portal.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Map;
import java.util.List;

@Service
public class EmailService {

    @Value("${app.mail.from}")
    private String fromEmail;

    @Value("${spring.mail.password}")
    private String apiKey;

    @Async
    public void sendEmail(String to, String subject, String htmlBody) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.set("api-key", apiKey);
            headers.set("Content-Type", "application/json");
            headers.set("accept", "application/json");

            Map<String, Object> body = Map.of(
                "sender", Map.of("name", "Campus Recruitment Portal", "email", fromEmail),
                "to", List.of(Map.of("email", to)),
                "subject", subject,
                "htmlContent", htmlBody
            );

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.exchange(
                "https://api.brevo.com/v3/smtp/email",
                HttpMethod.POST,
                request,
                String.class
            );
            System.out.println("Email sent successfully via Brevo HTTP API! Status: " + response.getStatusCode());
        } catch (Exception e) {
            System.err.println("Failed to send email via Brevo HTTP API to " + to + ": " + e.getMessage());
        }
    }

    @Async
    public void sendApplicationStatusEmail(String to, String studentName, String jobTitle,
                                           String companyName, String status) {
        String subject = "Application Update: " + jobTitle + " at " + companyName;
        String body = """
                <html><body style="font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;">
                <div style="max-width:600px; margin:auto; background:#fff; border-radius:12px; padding:30px;">
                    <h2 style="color:#6c63ff;">Campus Recruitment Portal</h2>
                    <p>Dear <strong>%s</strong>,</p>
                    <p>Your application for <strong>%s</strong> at <strong>%s</strong> has been updated.</p>
                    <div style="background:#6c63ff; color:#fff; padding:12px 20px; border-radius:8px; display:inline-block; font-size:18px; font-weight:bold;">
                        Status: %s
                    </div>
                    <p style="margin-top:20px;">Log in to your dashboard for more details.</p>
                    <p>Best regards,<br><strong>Campus Recruitment Team</strong></p>
                </div>
                </body></html>
                """.formatted(studentName, jobTitle, companyName, status);
        sendEmail(to, subject, body);
    }

    @Async
    public void sendInterviewInviteEmail(String to, String studentName, String jobTitle,
                                         String companyName, String date, String time, String venue) {
        String subject = "Interview Scheduled: " + jobTitle + " at " + companyName;
        String body = """
                <html><body style="font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;">
                <div style="max-width:600px; margin:auto; background:#fff; border-radius:12px; padding:30px;">
                    <h2 style="color:#6c63ff;">Interview Invitation</h2>
                    <p>Dear <strong>%s</strong>,</p>
                    <p>You have been scheduled for an interview for <strong>%s</strong> at <strong>%s</strong>.</p>
                    <table style="border-collapse:collapse; width:100%%; margin:20px 0;">
                        <tr><td style="padding:8px; background:#f0f0f0;"><strong>Date:</strong></td><td style="padding:8px;">%s</td></tr>
                        <tr><td style="padding:8px; background:#f0f0f0;"><strong>Time:</strong></td><td style="padding:8px;">%s</td></tr>
                        <tr><td style="padding:8px; background:#f0f0f0;"><strong>Venue:</strong></td><td style="padding:8px;">%s</td></tr>
                    </table>
                    <p>Best of luck!<br><strong>Campus Recruitment Team</strong></p>
                </div>
                </body></html>
                """.formatted(studentName, jobTitle, companyName, date, time, venue);
        sendEmail(to, subject, body);
    }

    @Async
    public void sendInterviewReminderEmail(String to, String studentName, String jobTitle,
                                           String companyName, String time, String venue, String interviewer) {
        String subject = "REMINDER: Interview in 1 Hour - " + jobTitle + " at " + companyName;
        String body = """
                <html><body style="font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;">
                <div style="max-width:600px; margin:auto; background:#fff; border-radius:12px; border-left:6px solid #f59e0b; padding:30px;">
                    <h2 style="color:#f59e0b;">Interview Reminder</h2>
                    <p>Dear <strong>%s</strong>,</p>
                    <p>This is a reminder that your interview for <strong>%s</strong> at <strong>%s</strong> is starting in approximately <strong>1 hour</strong>.</p>
                    <table style="border-collapse:collapse; width:100%%; margin:20px 0;">
                        <tr><td style="padding:8px; background:#f0f0f0;"><strong>Time:</strong></td><td style="padding:8px;">%s</td></tr>
                        <tr><td style="padding:8px; background:#f0f0f0;"><strong>Venue/Link:</strong></td><td style="padding:8px;">%s</td></tr>
                        <tr><td style="padding:8px; background:#f0f0f0;"><strong>Interviewer:</strong></td><td style="padding:8px;">%s</td></tr>
                    </table>
                    <p>Please be ready 5 minutes early. Best of luck!</p>
                </div>
                </body></html>
                """.formatted(studentName, jobTitle, companyName, time, venue, interviewer);
        sendEmail(to, subject, body);
    }

    @Async
    public void sendNewJobAlertEmail(String to, String studentName, String jobTitle,
                                     String companyName, String location, String deadline) {
        String subject = "New Job Alert: " + companyName + " is hiring for " + jobTitle;
        String body = """
                <html><body style="font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;">
                <div style="max-width:600px; margin:auto; background:#fff; border-radius:12px; border-left:6px solid #10b981; padding:30px;">
                    <h2 style="color:#10b981;">New Job Opportunity</h2>
                    <p>Hi <strong>%s</strong>,</p>
                    <p>A new job has been posted on the portal that you might be interested in!</p>
                    <div style="background:#f8faff; padding:15px; border-radius:8px; margin:20px 0;">
                        <h3 style="margin-top:0; color:#2563eb;">%s</h3>
                        <p style="margin:5px 0;"><strong>Company:</strong> %s</p>
                        <p style="margin:5px 0;"><strong>Location:</strong> %s</p>
                        <p style="margin:5px 0;"><strong>Deadline:</strong> %s</p>
                    </div>
                    <p>Log in to your Campus Recruitment Portal to view details and apply.</p>
                </div>
                </body></html>
                """.formatted(studentName, jobTitle, companyName, location, deadline);
        sendEmail(to, subject, body);
    }
}

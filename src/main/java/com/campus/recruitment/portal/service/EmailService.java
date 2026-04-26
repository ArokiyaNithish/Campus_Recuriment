package com.campus.recruitment.portal.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Async
    public void sendEmail(String to, String subject, String htmlBody) {
        if (mailSender == null) return;
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(message);
        } catch (Exception e) {
            // Log but don't crash the app if email fails
            System.err.println("Failed to send email to " + to + ": " + e.getMessage());
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
}

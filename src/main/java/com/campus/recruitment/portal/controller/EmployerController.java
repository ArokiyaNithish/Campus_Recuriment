package com.campus.recruitment.portal.controller;

import com.campus.recruitment.portal.model.*;
import com.campus.recruitment.portal.repository.*;
import com.campus.recruitment.portal.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/employer")
public class EmployerController {

    @Autowired private UserService userService;
    @Autowired private JobRepository jobRepository;
    @Autowired private ApplicationRepository applicationRepository;
    @Autowired private InterviewRepository interviewRepository;
    @Autowired private NotificationService notificationService;
    @Autowired private EmailService emailService;

    private User getCurrentUser(Authentication auth) {
        return userService.findByEmail(auth.getName()).orElseThrow();
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User employer = getCurrentUser(auth);
        List<Job> jobs = jobRepository.findByEmployer(employer);
        List<Application> allApps = applicationRepository.findByEmployer(employer);
        List<Interview> upcoming = interviewRepository.findUpcomingByEmployer(employer, LocalDate.now());

        model.addAttribute("employer", employer);
        model.addAttribute("jobs", jobs);
        model.addAttribute("allApplications", allApps);
        model.addAttribute("upcomingInterviews", upcoming);
        model.addAttribute("activeJobs", jobs.stream().filter(j -> j.getStatus() == Job.JobStatus.ACTIVE).count());
        model.addAttribute("pendingCount", allApps.stream().filter(a -> a.getStatus() == Application.ApplicationStatus.PENDING).count());
        model.addAttribute("shortlistedCount", allApps.stream().filter(a -> a.getStatus() == Application.ApplicationStatus.SHORTLISTED).count());
        model.addAttribute("selectedCount", allApps.stream().filter(a -> a.getStatus() == Application.ApplicationStatus.SELECTED).count());
        model.addAttribute("unreadCount", notificationService.getUnreadCount(employer));
        return "employer/dashboard";
    }

    @GetMapping("/jobs")
    public String myJobs(Authentication auth, Model model) {
        User employer = getCurrentUser(auth);
        model.addAttribute("employer", employer);
        model.addAttribute("jobs", jobRepository.findByEmployer(employer));
        model.addAttribute("unreadCount", notificationService.getUnreadCount(employer));
        return "employer/jobs";
    }

    @GetMapping("/jobs/new")
    public String newJobForm(Authentication auth, Model model) {
        User employer = getCurrentUser(auth);
        model.addAttribute("employer", employer);
        model.addAttribute("job", new Job());
        model.addAttribute("categories", List.of("Engineering", "Management", "Design", "Marketing", "Finance", "Data Science", "Operations", "HR"));
        model.addAttribute("experienceLevels", List.of("Entry Level", "Mid Level", "Senior Level", "Internship"));
        model.addAttribute("unreadCount", notificationService.getUnreadCount(employer));
        return "employer/job-form";
    }

    @PostMapping("/jobs/save")
    public String saveJob(Authentication auth,
                          @RequestParam(required = false) Long jobId,
                          @RequestParam String title,
                          @RequestParam String description,
                          @RequestParam(required = false) String skillsRequired,
                          @RequestParam(required = false) String location,
                          @RequestParam(required = false) String category,
                          @RequestParam(required = false) String experienceLevel,
                          @RequestParam(required = false) String salaryRange,
                          @RequestParam(required = false) Integer openings,
                          @RequestParam(required = false) Double minCgpa,
                          @RequestParam(required = false) String eligibleDepartments,
                          @RequestParam(required = false) String deadline,
                          @RequestParam(defaultValue = "ACTIVE") String status,
                          RedirectAttributes ra) {
        User employer = getCurrentUser(auth);
        Job job = (jobId != null) ? jobRepository.findById(jobId).orElse(new Job()) : new Job();
        job.setTitle(title); job.setDescription(description); job.setSkillsRequired(skillsRequired);
        job.setLocation(location); job.setCategory(category); job.setExperienceLevel(experienceLevel);
        job.setSalaryRange(salaryRange); job.setOpenings(openings); job.setMinCgpa(minCgpa);
        job.setEligibleDepartments(eligibleDepartments); job.setStatus(Job.JobStatus.valueOf(status));
        job.setEmployer(employer);
        if (deadline != null && !deadline.isBlank()) job.setDeadline(LocalDate.parse(deadline).atStartOfDay());
        jobRepository.save(job);
        ra.addFlashAttribute("success", "Job saved!");
        return "redirect:/employer/jobs";
    }

    @GetMapping("/jobs/{id}/edit")
    public String editJobForm(Authentication auth, @PathVariable Long id, Model model) {
        User employer = getCurrentUser(auth);
        model.addAttribute("employer", employer);
        model.addAttribute("job", jobRepository.findById(id).orElseThrow());
        model.addAttribute("categories", List.of("Engineering", "Management", "Design", "Marketing", "Finance", "Data Science", "Operations", "HR"));
        model.addAttribute("experienceLevels", List.of("Entry Level", "Mid Level", "Senior Level", "Internship"));
        model.addAttribute("unreadCount", notificationService.getUnreadCount(employer));
        return "employer/job-form";
    }

    @PostMapping("/jobs/{id}/close")
    public String closeJob(@PathVariable Long id, RedirectAttributes ra) {
        Job job = jobRepository.findById(id).orElseThrow();
        job.setStatus(Job.JobStatus.CLOSED);
        jobRepository.save(job);
        ra.addFlashAttribute("success", "Job closed.");
        return "redirect:/employer/jobs";
    }

    @GetMapping("/jobs/{id}/applicants")
    public String jobApplicants(Authentication auth, @PathVariable Long id, Model model) {
        User employer = getCurrentUser(auth);
        Job job = jobRepository.findById(id).orElseThrow();
        model.addAttribute("employer", employer);
        model.addAttribute("job", job);
        model.addAttribute("applications", applicationRepository.findByEmployerAndJobId(employer, id));
        model.addAttribute("unreadCount", notificationService.getUnreadCount(employer));
        return "employer/applicants";
    }

    @PostMapping("/jobs/{id}/applicants")
    public String debugPostApplicants(@PathVariable Long id, jakarta.servlet.http.HttpServletRequest request) {
        System.out.println("DEBUG POST RECEIVED AT /jobs/" + id + "/applicants");
        request.getParameterMap().forEach((k, v) -> System.out.println(k + ": " + String.join(",", v)));
        return "redirect:/employer/jobs/" + id + "/applicants";
    }

    @PostMapping("/applications/update-status")
    public String updateStatus(@RequestParam(name="applicationId") String appIdStr, @RequestParam String status,
                               @RequestParam(required = false) String notes, RedirectAttributes ra,
                               jakarta.servlet.http.HttpServletRequest request) {
        System.out.println("DEBUG: updateStatus received appIdStr='" + appIdStr + "'");
        
        if (appIdStr == null || appIdStr.trim().isEmpty() || appIdStr.equals("null") || appIdStr.equals("undefined")) {
            System.err.println("CRITICAL: Received invalid applicationId string: " + appIdStr);
            ra.addFlashAttribute("error", "Invalid application selection.");
            return "redirect:/employer/dashboard";
        }
        
        Long applicationId = Long.parseLong(appIdStr.trim());
        Application app = applicationRepository.findById(applicationId).orElseThrow();
        Application.ApplicationStatus newStatus = Application.ApplicationStatus.valueOf(status);
        app.setStatus(newStatus);
        if (notes != null && !notes.isBlank()) app.setEmployerNotes(notes);
        app.setLastUpdated(java.time.LocalDateTime.now());
        applicationRepository.save(app);
        
        try {
            notificationService.sendNotification(app.getStudent(), "Application Update",
                    "Your application for " + app.getJob().getTitle() + " is now: " + newStatus.name().replace("_", " "),
                    "/student/applications");
            emailService.sendApplicationStatusEmail(app.getStudent().getEmail(), app.getStudent().getFullName(),
                    app.getJob().getTitle(), app.getJob().getEmployer().getFullName(), newStatus.name().replace("_", " "));
        } catch (Exception e) {
            System.err.println("Failed to send notification/email: " + e.getMessage());
        }
        
        ra.addFlashAttribute("success", "Status updated!");
        return "redirect:/employer/jobs/" + app.getJob().getId() + "/applicants";
    }

    @GetMapping("/schedule")
    public String schedule(Authentication auth, Model model) {
        User employer = getCurrentUser(auth);
        model.addAttribute("employer", employer);
        model.addAttribute("interviews", interviewRepository.findByEmployer(employer));
        model.addAttribute("unreadCount", notificationService.getUnreadCount(employer));
        return "employer/schedule";
    }

    @PostMapping("/applications/schedule-interview")
    public String scheduleInterview(@RequestParam Long applicationId,
                                    @RequestParam String interviewDate, @RequestParam String interviewTime,
                                    @RequestParam(required = false) String venue, @RequestParam(required = false) String meetLink,
                                    @RequestParam(required = false) String interviewerName, @RequestParam(required = false) String notes,
                                    RedirectAttributes ra) {
        Application app = applicationRepository.findById(applicationId).orElseThrow();
        Interview interview = interviewRepository.findByApplicationId(applicationId).orElse(new Interview());
        interview.setApplication(app); interview.setInterviewDate(LocalDate.parse(interviewDate));
        interview.setInterviewTime(LocalTime.parse(interviewTime)); interview.setSlot(interviewTime);
        interview.setVenue(venue); interview.setMeetLink(meetLink);
        interview.setInterviewerName(interviewerName); interview.setNotes(notes);
        interview.setStatus(Interview.InterviewStatus.SCHEDULED);
        interviewRepository.save(interview);
        app.setStatus(Application.ApplicationStatus.INTERVIEW_SCHEDULED);
        applicationRepository.save(app);
        
        try {
            notificationService.sendNotification(app.getStudent(), "Interview Scheduled!",
                    "Interview for " + app.getJob().getTitle() + " on " + interviewDate + " at " + interviewTime, "/student/applications");
            emailService.sendInterviewInviteEmail(app.getStudent().getEmail(), app.getStudent().getFullName(),
                    app.getJob().getTitle(), app.getJob().getEmployer().getFullName(),
                    interviewDate, interviewTime, venue != null ? venue : meetLink);
        } catch (Exception e) {
            System.err.println("Failed to send interview notification/email: " + e.getMessage());
        }
        
        ra.addFlashAttribute("success", "Interview scheduled!");
        return "redirect:/employer/jobs/" + app.getJob().getId() + "/applicants";
    }
}

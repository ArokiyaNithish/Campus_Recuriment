package com.campus.recruitment.portal.controller;

import com.campus.recruitment.portal.service.UserService;
import jakarta.validation.constraints.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error,
                            @RequestParam(required = false) String logout,
                            Model model) {
        if (error != null) model.addAttribute("error", "Invalid email or password.");
        if (logout != null) model.addAttribute("message", "Logged out successfully.");
        return "auth/login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("roles", new String[]{"STUDENT", "EMPLOYER"});
        return "auth/register";
    }

    @PostMapping("/register")
    public String doRegister(@RequestParam String fullName,
                             @RequestParam String email,
                             @RequestParam String password,
                             @RequestParam String phone,
                             @RequestParam String role,
                             RedirectAttributes redirectAttributes) {
        try {
            if ("STUDENT".equals(role)) {
                userService.registerStudent(fullName, email, password, phone);
                redirectAttributes.addFlashAttribute("success",
                        "Account created! Please log in.");
            } else if ("EMPLOYER".equals(role)) {
                userService.registerEmployer(fullName, email, password, phone);
                redirectAttributes.addFlashAttribute("success",
                        "Registration submitted! Await admin approval.");
            }
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/auth/register";
        }
        return "redirect:/auth/login";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "auth/access-denied";
    }
}

package com.campus.recruitment.portal.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpSession;

@RestController
public class TestSessionController {

    @GetMapping("/test-session")
    public String testSession(HttpSession session) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) ? auth.getName() : "UNAUTHENTICATED";
        return "Session ID: " + session.getId() + "<br>User: " + username;
    }
}

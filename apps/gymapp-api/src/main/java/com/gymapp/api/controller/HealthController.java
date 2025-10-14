package com.gymapp.api.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

    @GetMapping("/health")
    public String health() {
        return "GymApp API is running";
    }

    @GetMapping("/api/students/test")
    public String testStudents() {
        return "Students endpoint working!";
    }
}

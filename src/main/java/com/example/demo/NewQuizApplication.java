package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 🚀 Quiz Application - Main Entry Point
 * 
 * This is the heart of our Full Stack Quiz Application! 
 * It bootstraps the entire Spring Boot ecosystem including:
 * - Web server (Tomcat) 
 * - Database connections (PostgreSQL)
 * - Security layer (JWT authentication)
 * - REST API endpoints
 * 
 * Think of this as the "ignition key" that starts our quiz engine!
 * 
 * @author KUNAL M
 * @version 1.0
 * @since 2025
 */
@SpringBootApplication
public class NewQuizApplication {

	/**
	 * 🎯 The main method - where it all begins!
	 * 
	 * This method kicks off our entire quiz application.
	 * When you run this, Spring Boot will:
	 * 1. Scan for components (@Controller, @Service, @Repository)
	 * 2. Set up the database connection
	 * 3. Configure security settings
	 * 4. Start the web server on port 8080
	 * 5. Make our quiz API available to the world!
	 * 
	 * @param args Command line arguments (we don't use any, but Spring might!)
	 */
	public static void main(String[] args) {
		SpringApplication.run(NewQuizApplication.class, args);
	}
}

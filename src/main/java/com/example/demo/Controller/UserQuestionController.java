package com.example.demo.Controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.Model.Question;
import com.example.demo.Service.QuestionService;

/**
 * 👤 UserQuestionController - Question Browser for Regular Users!
 * 
 * This controller provides READ-ONLY access to questions for regular users.
 * Unlike the admin QuestionController, users can only VIEW questions, not modify them.
 * 
 * Perfect for scenarios where users want to:
 * - Browse available questions before taking a quiz 🔍
 * - Study question patterns and formats 📚
 * - See what categories are available 📋
 * - Preview individual questions 👁️
 * 
 * Note: This shows questions WITH their correct answers, so it's more suitable
 * for study purposes rather than actual quiz-taking. For quiz-taking, use
 * the QuizController which hides the answers!
 * 
 * Security consideration: In a real application, you might want to hide
 * the correct answers even from these endpoints to prevent cheating.
 * 
 * @author KUNAL M
 * @version 1.0
 */
@RestController 
@RequestMapping("user/question")
public class UserQuestionController {
	
	/** 🔧 Our connection to the question business logic */
	@Autowired 
	QuestionService service;
	
	/**
	 * 📚 GET /user/question/allQuestions
	 * 
	 * Browse the entire question library! 
	 * Shows all questions available in the system.
	 * 
	 * Great for users who want to see what kind of questions they might encounter.
	 * Could be used for a "Question Bank" or "Study Material" page.
	 */
	@GetMapping("/allQuestions")
	public ResponseEntity<List<Question>> getAllQuestions(){
		return service.getAllQuestions();
	}
	
	/**
	 * 🔍 GET /user/question/category/{category}
	 * 
	 * Filter questions by category (Java, Python, JavaScript, etc.)
	 * 
	 * Example: GET /user/question/category/Java
	 * Returns all Java-related questions for users to study or preview.
	 */
	@GetMapping("/category/{category}")
	public List<Question> getByCategory(@PathVariable String category){
		return service.getByCategory(category);
	}
	
	/**
	 * 🎯 GET /user/question/id/{id}
	 * 
	 * View a specific question by its ID.
	 * Useful when users want to examine a particular question in detail.
	 * 
	 * Returns Optional<Question> - might be empty if question doesn't exist.
	 */
	@GetMapping("/id/{id}")
	public Optional<Question> getById(@PathVariable int id){
		return service.getById(id);
	}
}

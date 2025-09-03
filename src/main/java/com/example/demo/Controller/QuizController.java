package com.example.demo.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.Model.QuestionWrapper;
import com.example.demo.Model.Quiz;
import com.example.demo.Model.Response;
import com.example.demo.Service.QuizService;

/**
 * 🎯 QuizController - The Quiz Experience Center!
 * 
 * This controller handles the complete quiz lifecycle with separate endpoints for:
 * 
 * 👤 USER ENDPOINTS (for quiz takers):
 * - Browse available quizzes
 * - Take a quiz (get questions without answers)
 * - Submit answers and get scores
 * 
 * 👨‍💼 ADMIN ENDPOINTS (for quiz managers):
 * - Create new quizzes from question categories
 * - Delete specific quizzes or all quizzes
 * 
 * The URL patterns clearly separate user and admin functionality:
 * - /user/quiz/* - Regular users taking quizzes
 * - /admin/quiz/* - Administrators managing quizzes
 * 
 * @author KUNAL M
 * @version 1.0
 */
@RestController
public class QuizController {
	
	/** 🔧 Our connection to the quiz business logic */
	@Autowired
	QuizService quizService;

	/**
	 * 📝 GET /user/quiz/get/{id}
	 * 
	 * Start taking a quiz! Returns all questions with their options
	 * but cleverly hides the correct answers (no cheating! 😉)
	 * 
	 * Perfect for displaying the quiz interface to users.
	 * They see questions and multiple choice options, but not the answers.
	 */
	@GetMapping("user/quiz/get/{id}")
	public ResponseEntity<List<QuestionWrapper>> getQuizQuestions (@PathVariable int id){
		return quizService.getQuizQuestions(id);
	}
	
	/**
	 * 🎪 POST /admin/quiz/create
	 * 
	 * Create a brand new quiz! Admins specify:
	 * - category: Which subject (Java, Python, etc.)
	 * - numQ: How many questions to include
	 * - title: A catchy name for the quiz
	 * 
	 * Example: Create "Java Expert Challenge" with 10 random Java questions
	 * 
	 * The system automatically picks random questions from the specified category.
	 */
	@PostMapping("admin/quiz/create")
	public ResponseEntity<String> createQuiz(@RequestParam String category, @RequestParam int numQ, @RequestParam String title ){
		return quizService.createQuize(category, numQ, title);
	}
	
	/**
	 * 📊 POST /user/quiz/submit/{id}
	 * 
	 * The moment of truth! Users submit their answers and get their score.
	 * 
	 * Request body contains a list of Response objects with:
	 * - Question ID and the user's chosen answer
	 * 
	 * Returns the number of correct answers (score).
	 * Example: If user got 7 out of 10 questions right, returns 7.
	 */
	@PostMapping ("user/quiz/submit/{id}") 
	public ResponseEntity <Integer> submitQuiz(@PathVariable int id, @RequestBody List<Response> responses)  {
		return quizService.calculateResult(id, responses);
	}

	/**
	 * 🗑️ DELETE /admin/quiz/delete/{id}
	 * 
	 * Remove a specific quiz from the system.
	 * Useful when a quiz becomes outdated or has issues.
	 * Only admins should have access to this destructive operation!
	 */
	@DeleteMapping("admin/quiz/delete/{id}")
	public ResponseEntity<String> deleteQuiz(@PathVariable int id) {
		return quizService.deleteQuiz(id);
	}
	
	/**
	 * 🧹 DELETE /admin/quiz/delete/all
	 * 
	 * Nuclear option! Deletes ALL quizzes from the system.
	 * Use with extreme caution - perfect for testing or complete reset.
	 * This action cannot be undone!
	 */
	@DeleteMapping("admin/quiz/delete/all")
	public ResponseEntity<String> deleteAllQuizzes() {
		return quizService.deleteAllQuizzes();
	}
	
	/**
	 * 📋 GET /user/quiz/all
	 * 
	 * Browse the quiz catalog! Shows all available quizzes that users can take.
	 * Perfect for a "Choose Your Quiz" page where users can see:
	 * - Quiz titles
	 * - Number of questions in each quiz
	 * - Quiz categories
	 */
	@GetMapping("user/quiz/all")
	public ResponseEntity<List<Quiz>> getAllQuizzes() {
		return quizService.getAllQuizzes();
	}
}

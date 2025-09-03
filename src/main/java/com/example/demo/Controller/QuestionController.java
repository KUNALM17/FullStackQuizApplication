package com.example.demo.Controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.Model.Question;
import com.example.demo.Service.QuestionService;

/**
 * 🎯 QuestionController - The Admin's Question Management Dashboard!
 * 
 * This REST controller is like the admin panel for managing quiz questions.
 * Only admins should have access to these endpoints (notice the "/admin" prefix).
 * 
 * Think of it as the "Question Control Center" where admins can:
 * - View all questions in the database 📊
 * - Add new questions to expand the quiz bank ➕
 * - Update existing questions to fix typos or improve them ✏️
 * - Delete outdated or incorrect questions 🗑️
 * - Browse questions by category 📚
 * - Get all available categories 📋
 * 
 * All endpoints return proper HTTP status codes and meaningful responses!
 * 
 * @author KUNAL M
 * @version 1.0
 */
@RestController 
@RequestMapping("admin/question")
public class QuestionController {
	
	/** 🔧 Our connection to the question business logic */
	@Autowired 
	QuestionService service;
	
	@Autowired
	com.example.demo.Dao.QuestionDao questionDao;

	/**
	 * 📊 GET /admin/question/allQuestions
	 * 
	 * Returns every single question in our database.
	 * Perfect for admins who want to see the complete question inventory!
	 */
	@GetMapping("/allQuestions")
	public ResponseEntity<List<Question>> getAllQuestions(){
		return service.getAllQuestions();
	}

	/**
	 * 📋 GET /admin/question/categories
	 * 
	 * Shows all unique question categories (Java, Python, JavaScript, etc.)
	 * Helps admins understand what subjects we have questions for.
	 */
	@GetMapping("/categories")
	public List<String> getCategories() {
		return service.getAllCategories();
	}
	
	/**
	 * 🔍 GET /admin/question/category/{category}
	 * 
	 * Filter questions by a specific category.
	 * Example: GET /admin/question/category/Java returns all Java questions.
	 */
	@GetMapping("/category/{category}")
	public List<Question> getByCategory(@PathVariable String category){
		return service.getByCategory(category);
	}

	/**
	 * 🎯 GET /admin/question/id/{id}
	 * 
	 * Find a specific question by its unique ID.
	 * Great for when admins want to examine or edit a particular question.
	 */
	@GetMapping("/id/{id}")
	public Optional<Question> getById(@PathVariable int id){
		return service.getById(id);
	}

	/**
	 * ➕ POST /admin/question/addQuestions
	 * 
	 * Add a brand new question to our question bank.
	 * Send the question data in the request body as JSON.
	 * 
	 * Example request body:
	 * {
	 *   "question_title": "What is the main method in Java?",
	 *   "option1": "public static void main(String[] args)",
	 *   "option2": "public void main(String[] args)",
	 *   "option3": "static void main(String[] args)",
	 *   "option4": "void main(String[] args)",
	 *   "right_answer": "public static void main(String[] args)",
	 *   "category": "Java",
	 *   "difficultylevel": "Easy"
	 * }
	 */
	@PostMapping("/addQuestions")
	public ResponseEntity<String> addQuestion (@RequestBody Question question){
		return service.addQuestion(question);
	}

	/**
	 * 🗑️ DELETE /admin/question/delete/{id}
	 * 
	 * Remove a question from the database forever.
	 * Use carefully - this action cannot be undone!
	 * Perfect for removing outdated or incorrect questions.
	 */
	@DeleteMapping("/delete/{id}")
	public ResponseEntity<String> deleteQuestion(@PathVariable int id) {
		return service.deleteQuestion(id);
	}

	/**
	 * ✏️ PUT /admin/question/update/{id}
	 * 
	 * Update an existing question with new information.
	 * Send the complete updated question data in the request body.
	 * The ID in the URL specifies which question to update.
	 * 
	 * Great for fixing typos, updating options, or changing difficulty levels!
	 */
	@PutMapping("/update/{id}")
	public ResponseEntity<String> updateQuestion(@PathVariable int id, @RequestBody Question question) {
		return service.updateQuestion(id, question);
	}
}

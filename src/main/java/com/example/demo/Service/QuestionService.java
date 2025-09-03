package com.example.demo.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.example.demo.Dao.QuestionDao;
import com.example.demo.Model.Question;

/**
 * 🧠 QuestionService - The Brain Behind Question Management!
 * 
 * This service is like a librarian who manages all the quiz questions.
 * They can:
 * - Add new questions to the collection 📚
 * - Find questions by category (Java, Python, etc.) 🔍
 * - Update existing questions ✏️
 * - Delete questions that are no longer needed 🗑️
 * - Get all available question categories 📋
 * 
 * Think of it as the "Question Manager" that handles all the business logic
 * while keeping the controllers clean and focused on handling HTTP requests.
 * 
 * @author KUNAL M
 * @version 1.0
 */
@Service
public class QuestionService {
	
	/** 🔌 Our connection to the question database operations */
	@Autowired
	com.example.demo.Dao.QuestionDao questionDao;
	
	@Autowired
	QuestionDao repo;

	/**
	 * 📋 Get All Question Categories
	 * 
	 * Like asking "What subjects do we have questions for?"
	 * Returns a list of unique categories (Java, Python, JavaScript, etc.)
	 */
	public List<String> getAllCategories() {
		return questionDao.findDistinctCategories();
	}

	/**
	 * 📚 Get All Questions in the Database
	 * 
	 * This is like asking for the entire question bank.
	 * Returns all questions with proper error handling.
	 * If something goes wrong, we return an empty list instead of crashing!
	 */
	public ResponseEntity<List<Question>> getAllQuestions() {
		try {
			return new ResponseEntity<>(repo.findAll(), HttpStatus.OK);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<>(new ArrayList<>(), HttpStatus.NOT_FOUND);
	}

	/**
	 * 🔍 Find Questions by Category
	 * 
	 * Like asking "Show me all Java questions" or "Give me Python questions"
	 * Perfect for creating category-specific quizzes!
	 */
	public List<Question> getByCategory(String category) {
		return repo.findByCategory(category);
	}

	/**
	 * ➕ Add a New Question to Our Collection
	 * 
	 * This is how we grow our question database!
	 * Takes a new question and saves it safely with error handling.
	 */
	public ResponseEntity<String> addQuestion(Question question) {
		try {
			repo.save(question);
			return new ResponseEntity<>("Question Added Successfully", HttpStatus.CREATED);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<>("Can't be CREATED", HttpStatus.FORBIDDEN);
	}

	/**
	 * 🎯 Find a Specific Question by its ID
	 * 
	 * Like looking up a specific book by its ISBN number.
	 * Returns Optional in case the question doesn't exist.
	 */
	public Optional<Question> getById(int id) {
		return repo.findById(id);
	}

	/**
	 * 🗑️ Delete a Question (New Feature!)
	 * 
	 * Sometimes we need to remove outdated or incorrect questions.
	 * This method safely deletes a question after checking it exists.
	 * Better to check first than to delete something that's not there! 🤷‍♂️
	 */
	public ResponseEntity<String> deleteQuestion(int id) {
		try {
			if (repo.existsById(id)) {
				repo.deleteById(id);
				return new ResponseEntity<>("Question deleted successfully", HttpStatus.OK);
			} else {
				return new ResponseEntity<>("Question not found", HttpStatus.NOT_FOUND);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("Error deleting question", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * ✏️ Update an Existing Question (New Feature!)
	 * 
	 * Sometimes we need to fix typos, update options, or change difficulty levels.
	 * This method lets us update any question while ensuring it actually exists first.
	 * We make sure to preserve the ID to avoid creating duplicate questions!
	 */
	public ResponseEntity<String> updateQuestion(int id, Question question) {
		try {
			if (repo.existsById(id)) {
				// Make sure we're updating the right question by setting the ID
				question.setId(id);
				repo.save(question);
				return new ResponseEntity<>("Question updated successfully", HttpStatus.OK);
			} else {
				return new ResponseEntity<>("Question not found", HttpStatus.NOT_FOUND);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("Error updating question", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}

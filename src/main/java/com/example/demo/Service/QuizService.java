package com.example.demo.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.example.demo.Dao.QuestionDao;
import com.example.demo.Dao.QuizDao;
import com.example.demo.Model.Question;
import com.example.demo.Model.QuestionWrapper;
import com.example.demo.Model.Quiz;
import com.example.demo.Model.Response;

/**
 * 🎯 QuizService - The Quiz Master That Orchestrates Everything!
 * 
 * This service is like a quiz show host who:
 * - Creates exciting quizzes from random questions 🎲
 * - Presents questions to users (without showing answers!) 🤫
 * - Calculates scores when users submit their responses 📊
 * - Manages the entire quiz lifecycle (create, get, delete) 🔄
 * 
 * Think of it as the "Quiz Engine" that powers the entire quiz experience.
 * It coordinates between questions and user responses to create an engaging experience!
 * 
 * @author KUNAL M
 * @version 1.0
 */
@Service
public class QuizService {
	
	/** 🎲 Our connection to quiz database operations */
	@Autowired
	QuizDao quizDao;
	
	/** 📚 Our connection to question database operations */
	@Autowired 
	QuestionDao repo;

	/**
	 * 🎪 Create a Brand New Quiz!
	 * 
	 * This is like a quiz generator that:
	 * 1. Picks random questions from a specific category
	 * 2. Creates a new quiz with those questions
	 * 3. Gives it a catchy title
	 * 
	 * For example: "Java Expert Challenge" with 10 random Java questions
	 */
	public ResponseEntity<String> createQuize(String category, int numQ, String title) {
		try {
			// Get random questions from the specified category
			List<Question> questions = repo.findRandomQuestionsByCategory(category, numQ);

			if (questions == null || questions.isEmpty()) {
				return new ResponseEntity<>("❌ No questions found for category: " + category, HttpStatus.BAD_REQUEST);
			}

			// Create and save the new quiz
			Quiz quiz = new Quiz();
			quiz.setTitle(title);
			quiz.setQuestions(questions);

			quizDao.save(quiz);

			return new ResponseEntity<>("✅ Quiz created successfully", HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();  // Print actual error details for debugging
			return new ResponseEntity<>("❌ Server error: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * 📊 Calculate Quiz Score - The Moment of Truth!
	 * 
	 * This is where the magic happens! We:
	 * 1. Get the user's responses
	 * 2. Compare them with correct answers
	 * 3. Count how many they got right
	 * 4. Return their score
	 * 
	 * It's like an automatic grading system! 🤖
	 */
	public ResponseEntity<Integer> calculateResult(int id, List<Response> responses) {
		Quiz quiz = quizDao.findById(id).get();		
		List<Question> questions = quiz.getQuestions();
		int right = 0;
		int i = 0;
		
		// Check each response against the correct answer
		for(Response response: responses) {
			if(response.getResponse().equals(questions.get(i).getRight_answer()))
				right++;
			i++;
		}
		return new ResponseEntity<>(right, HttpStatus.OK);
	}

	/**
	 * 🎭 Get Quiz Questions (Without Spoiling the Answers!)
	 * 
	 * This method is clever - it shows users the questions and options
	 * but NEVER reveals the correct answers. It's like giving someone
	 * a test paper without the answer sheet!
	 * 
	 * We use QuestionWrapper to hide the right_answer field.
	 */
	public ResponseEntity<List<QuestionWrapper>> getQuizQuestions(int id) {
		Optional<Quiz> quiz = quizDao.findById(id);
		List<Question> questionFromDb = quiz.get().getQuestions();
		List<QuestionWrapper> questionForUser = new ArrayList<>();
		
		// Convert each Question to QuestionWrapper (hiding the correct answer)
		for(Question q: questionFromDb) {
			QuestionWrapper qw = new QuestionWrapper(q.getId(), q.getQuestion_title(), 
				q.getOption1(), q.getOption2(), q.getOption3(), q.getOption4());
			questionForUser.add(qw);
		}
		return new ResponseEntity<>(questionForUser, HttpStatus.OK);
	}

	/**
	 * 🗑️ Delete a Specific Quiz
	 * 
	 * Sometimes quizzes become outdated or we want to clean up.
	 * This method safely removes a quiz after checking it exists.
	 */
	public ResponseEntity<String> deleteQuiz(int id) {
		try {
			Optional<Quiz> quiz = quizDao.findById(id);
			if (quiz.isPresent()) {
				quizDao.deleteById(id);
				return new ResponseEntity<>("✅ Quiz deleted successfully", HttpStatus.OK);
			} else {
				return new ResponseEntity<>("❌ Quiz not found with id: " + id, HttpStatus.NOT_FOUND);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("❌ Error deleting quiz: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * 🧹 Delete ALL Quizzes (Nuclear Option!)
	 * 
	 * Use with caution! This wipes out all quizzes in the database.
	 * Perfect for testing or when you want a fresh start.
	 */
	public ResponseEntity<String> deleteAllQuizzes() {
		try {
			long count = quizDao.count();
			if (count > 0) {
				quizDao.deleteAll();
				return new ResponseEntity<>("✅ All " + count + " quizzes deleted successfully", HttpStatus.OK);
			} else {
				return new ResponseEntity<>("ℹ️ No quizzes found to delete", HttpStatus.OK);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("❌ Error deleting all quizzes: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * 📋 Get All Available Quizzes
	 * 
	 * Like browsing a quiz catalog! Shows all quizzes that users can take.
	 * Perfect for displaying a "Choose Your Quiz" page.
	 */
	public ResponseEntity<List<Quiz>> getAllQuizzes() {
		try {
			List<Quiz> quizzes = quizDao.findAll();
			if (quizzes.isEmpty()) {
				return new ResponseEntity<>(new ArrayList<>(), HttpStatus.OK);
			}
			return new ResponseEntity<>(quizzes, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(new ArrayList<>(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}

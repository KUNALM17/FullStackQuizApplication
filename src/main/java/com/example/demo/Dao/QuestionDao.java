package com.example.demo.Dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.demo.Model.Question;

/**
 * 🗄️ QuestionDao - The Database Gateway for Questions!
 * 
 * This Data Access Object (DAO) interface is our bridge to the question database.
 * Think of it as a specialized librarian who knows exactly how to:
 * - Find questions by category 📚
 * - Pick random questions for quizzes 🎲
 * - Get all unique categories available 📋
 * - Perform all basic CRUD operations (inherited from JpaRepository) ⚙️
 * 
 * Spring JPA automatically implements all these methods for us!
 * We just define what we want, and Spring handles the SQL magic behind the scenes.
 * 
 * @author KUNAL M
 * @version 1.0
 */
@Repository
public interface QuestionDao extends JpaRepository<Question, Integer> {
	
	/**
	 * 🔍 Find All Questions in a Specific Category
	 * 
	 * Spring automatically generates this query based on the method name!
	 * "findByCategory" becomes "SELECT * FROM question WHERE category = ?"
	 * 
	 * Example: findByCategory("Java") returns all Java questions
	 */
	List<Question> findByCategory(String category);
	
	/**
	 * 🎲 Get Random Questions for Quiz Creation
	 * 
	 * This is where the magic happens! We use a native SQL query to:
	 * 1. Filter questions by category
	 * 2. Randomize the order (ORDER BY RANDOM())
	 * 3. Limit the results to the number requested
	 * 
	 * Perfect for creating diverse quizzes with different questions each time!
	 */
	@Query(value = "SELECT * FROM question q WHERE q.category = ?1 ORDER BY RANDOM() LIMIT ?2", nativeQuery = true)
	List<Question> findRandomQuestionsByCategory(String category, int numQ);
	
	/**
	 * 📋 Get All Available Question Categories
	 * 
	 * Returns a unique list of all categories we have questions for.
	 * Like asking "What subjects do we cover?"
	 * 
	 * Example result: ["Java", "Python", "JavaScript", "React", "Spring Boot"]
	 */
	@Query(value = "SELECT DISTINCT category FROM question", nativeQuery = true)
	List<String> findDistinctCategories();
}

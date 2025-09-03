import React, { useState, useEffect } from 'react';
import './index.css';

// 🔥 SHOCKING PREMIUM COMPONENTS - NO SCALING EFFECTS 🔥

// 💎 Premium Card Component
const Card = ({ children, variant = 'glass', className = '', ...props }) => {
  const variants = {
    glass: 'glass-card',
    elevated: 'card-elevated',
    neon: 'card-neon'
  };
  
  return (
    <div className={`${variants[variant]} ${className}`} {...props}>
      {children}
    </div>
  );
};

// 🚀 Premium Button Component
const Button = ({ children, variant = 'primary', size = 'md', loading = false, icon, className = '', ...props }) => {
  const variants = {
    primary: 'btn-primary',
    secondary: 'btn-secondary',
    ghost: 'btn-ghost',
    danger: 'btn-danger'
  };
  
  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  };
  
  return (
    <button 
      className={`${variants[variant]} ${sizes[size]} inline-flex items-center justify-center gap-2 ${className}`}
      disabled={loading || props.disabled}
      {...props}
    >
      {loading && <div className="spinner" />}
      {icon && !loading && <span className="text-lg">{icon}</span>}
      {children}
    </button>
  );
};

// 💎 Premium Input Component
const Input = ({ label, icon, error, className = '', ...props }) => {
  return (
    <div className="space-y-2">
      {label && (
        <label className="block text-sm font-semibold text-secondary-300">
          {label}
        </label>
      )}
      <div className="relative">
        {icon && (
          <div className="input-icon">
            <span className="text-lg">{icon}</span>
          </div>
        )}
        <input 
          className={`input-field w-full ${icon ? 'pl-12' : ''} ${error ? 'border-accent-50 focus:border-accent-50' : ''} ${className}`}
          {...props}
        />
      </div>
      {error && (
        <span className="text-sm text-accent-50">{error}</span>
      )}
    </div>
  );
};

// 📢 Premium Message Component
const Message = ({ type = 'info', children, className = '' }) => {
  const types = {
    success: 'status-success',
    warning: 'status-warning',
    error: 'status-error',
    info: 'status-info'
  };
  
  return (
    <div className={`${types[type]} ${className}`}>
      {children}
    </div>
  );
};

// 🌟 Compact Login Component - Fits in Single Page
const Login = ({ onLogin, onSwitchToRegister }) => {
  const [credentials, setCredentials] = useState({ username: '', password: '' });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!credentials.username || !credentials.password) {
      setError('Please fill in all fields');
      return;
    }

    setLoading(true);
    setError('');
    
    try {
      const response = await fetch('http://localhost:8080/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(credentials),
      });

      if (response.ok) {
        const data = await response.json();
        localStorage.setItem('token', data.token);
        localStorage.setItem('role', data.role);
        onLogin(data);
      } else {
        setError('Invalid credentials');
      }
    } catch (err) {
      setError('Connection failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <Card variant="neon" className="w-full max-w-md p-6 animate-fade-in">
        <div className="text-center mb-4">
          <h2 className="text-2xl font-bold text-gradient-electric mb-1">
            Welcome Back! 🔥
          </h2>
          <p className="text-secondary-400">Sign in to access premium quizzes</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-3">
          <Input
            label="Username"
            icon="👤"
            type="text"
            value={credentials.username}
            onChange={(e) => setCredentials({...credentials, username: e.target.value})}
            placeholder="Enter your username"
          />

          <Input
            label="Password"
            icon="🔒"
            type="password"
            value={credentials.password}
            onChange={(e) => setCredentials({...credentials, password: e.target.value})}
            placeholder="Enter your password"
          />

          {error && <Message type="error">{error}</Message>}

          <Button
            type="submit"
            className="w-full"
            loading={loading}
            icon="⚡"
          >
            Sign In
          </Button>
        </form>

        <div className="mt-4 text-center">
          <span className="text-secondary-400">Don't have an account? </span>
          <button
            onClick={onSwitchToRegister}
            className="text-accent-500 hover:text-accent-400 font-semibold"
          >
            Create Account
          </button>
        </div>

        {/* Demo Credentials */}
        <Card variant="glass" className="mt-4 p-3">
          <h3 className="text-accent-500 font-semibold mb-2 flex items-center gap-2">
            🎯 Demo Credentials
          </h3>
          <div className="space-y-1 text-sm text-secondary-300">
            <div><strong>Admin:</strong> admin / admin123</div>
            <div><strong>User:</strong> user / user123</div>
          </div>
        </Card>
      </Card>
    </div>
  );
};

// 🔐 Compact Register Component
const Register = ({ onRegister, onSwitchToLogin }) => {
  const [formData, setFormData] = useState({ username: '', password: '', confirmPassword: '' });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.username || !formData.password || !formData.confirmPassword) {
      setError('Please fill in all fields');
      return;
    }
    if (formData.password !== formData.confirmPassword) {
      setError('Passwords do not match');
      return;
    }

    setLoading(true);
    setError('');
    
    try {
      const response = await fetch('http://localhost:8080/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username: formData.username, password: formData.password }),
      });

      if (response.ok) {
        const data = await response.json();
        localStorage.setItem('token', data.token);
        localStorage.setItem('role', data.role);
        onRegister(data);
      } else {
        setError('Registration failed');
      }
    } catch (err) {
      setError('Connection failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <Card variant="neon" className="w-full max-w-md p-6 animate-fade-in">
        <div className="text-center mb-4">
          <h2 className="text-2xl font-bold text-gradient-electric mb-1">
            Join QuizMaster Pro! 🚀
          </h2>
          <p className="text-secondary-400">Create your premium account</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-3">
          <Input
            label="Username"
            icon="👤"
            type="text"
            value={formData.username}
            onChange={(e) => setFormData({...formData, username: e.target.value})}
            placeholder="Choose a username"
          />

          <Input
            label="Password"
            icon="🔒"
            type="password"
            value={formData.password}
            onChange={(e) => setFormData({...formData, password: e.target.value})}
            placeholder="Create a password"
          />

          <Input
            label="Confirm Password"
            icon="🔐"
            type="password"
            value={formData.confirmPassword}
            onChange={(e) => setFormData({...formData, confirmPassword: e.target.value})}
            placeholder="Confirm your password"
          />

          {error && <Message type="error">{error}</Message>}

          <Button
            type="submit"
            className="w-full"
            loading={loading}
            icon="✨"
          >
            Create Account
          </Button>
        </form>

        <div className="mt-4 text-center">
          <span className="text-secondary-400">Already have an account? </span>
          <button
            onClick={onSwitchToLogin}
            className="text-accent-500 hover:text-accent-400 font-semibold"
          >
            Sign In
          </button>
        </div>
      </Card>
    </div>
  );
};

// 🎮 Premium User Dashboard - Compact Design
const UserDashboard = ({ user, onLogout, onTakeQuiz, onViewQuestions }) => {
  const [quizzes, setQuizzes] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchQuizzes();
  }, []);

  const fetchQuizzes = async () => {
    try {
      const response = await fetch('http://localhost:8080/quiz/get/all', {
        headers: { 'Authorization': `Bearer ${localStorage.getItem('token')}` }
      });
      if (response.ok) {
        const data = await response.json();
        setQuizzes(data);
      }
    } catch (err) {
      console.error('Failed to fetch quizzes:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="spinner-large mb-4" />
          <p className="text-secondary-400">Loading premium content...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-dark">
      {/* Compact Header */}
      <header className="bg-dark-200/60 backdrop-blur-xl border-b border-dark-400/50 sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-4 py-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <h1 className="text-xl font-bold text-gradient-electric">QuizMaster Pro</h1>
              <span className="text-accent-500 font-semibold">🔥</span>
            </div>
            <div className="flex items-center gap-3">
              <span className="text-secondary-300">Welcome, {user.username}!</span>
              {user.role === 'ADMIN' && (
                <Button variant="ghost" size="sm" onClick={onViewQuestions} icon="⚙️">
                  Manage
                </Button>
              )}
              <Button variant="danger" size="sm" onClick={onLogout} icon="🚪">
                Logout
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Compact Content */}
      <main className="max-w-7xl mx-auto px-4 py-6">
        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <Card variant="glass" className="p-4">
            <div className="flex items-center gap-3">
              <div className="text-3xl">📊</div>
              <div>
                <h3 className="text-lg font-semibold text-secondary-200">Total Quizzes</h3>
                <p className="text-2xl font-bold text-accent-500">{quizzes.length}</p>
              </div>
            </div>
          </Card>
          
          <Card variant="glass" className="p-4">
            <div className="flex items-center gap-3">
              <div className="text-3xl">⚡</div>
              <div>
                <h3 className="text-lg font-semibold text-secondary-200">Premium Access</h3>
                <p className="text-lg font-bold text-accent-400">Active</p>
              </div>
            </div>
          </Card>
          
          <Card variant="glass" className="p-4">
            <div className="flex items-center gap-3">
              <div className="text-3xl">🏆</div>
              <div>
                <h3 className="text-lg font-semibold text-secondary-200">Your Rank</h3>
                <p className="text-lg font-bold text-accent-300">Pro User</p>
              </div>
            </div>
          </Card>
        </div>

        {/* Quiz Grid */}
        <div className="space-y-4">
          <h2 className="text-2xl font-bold text-gradient-electric flex items-center gap-2">
            Available Quizzes 🎯
          </h2>
          
          {quizzes.length === 0 ? (
            <Card variant="glass" className="p-8 text-center">
              <div className="text-6xl mb-4">🎮</div>
              <h3 className="text-xl font-semibold text-secondary-200 mb-2">No Quizzes Available</h3>
              <p className="text-secondary-400">Check back later for new premium content!</p>
            </Card>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {quizzes.map((quiz) => (
                <Card key={quiz.id} variant="elevated" className="p-4 group">
                  <div className="flex items-start justify-between mb-3">
                    <h3 className="text-lg font-semibold text-secondary-200 flex-1">
                      {quiz.title}
                    </h3>
                    <span className="text-2xl">🧠</span>
                  </div>
                  
                  <div className="space-y-2 mb-4">
                    <div className="flex items-center gap-2 text-sm text-secondary-400">
                      <span>📝</span>
                      <span>{quiz.questionsCount || 'Multiple'} Questions</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-secondary-400">
                      <span>⏱️</span>
                      <span>No Time Limit</span>
                    </div>
                  </div>
                  
                  <Button
                    variant="primary"
                    className="w-full"
                    onClick={() => onTakeQuiz(quiz.id)}
                    icon="🚀"
                  >
                    Start Quiz
                  </Button>
                </Card>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
};

// 🎯 Main App Component
export default function App() {
  const [currentPage, setCurrentPage] = useState('login');
  const [user, setUser] = useState(null);
  const [selectedQuizId, setSelectedQuizId] = useState(null);

  useEffect(() => {
    const token = localStorage.getItem('token');
    const role = localStorage.getItem('role');
    if (token && role) {
      setUser({ username: 'user', role });
      setCurrentPage('dashboard');
    }
  }, []);

  const handleLogin = (userData) => {
    setUser(userData);
    setCurrentPage('dashboard');
  };

  const handleRegister = (userData) => {
    setUser(userData);
    setCurrentPage('dashboard');
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role');
    setUser(null);
    setCurrentPage('login');
  };

  const handleTakeQuiz = (quizId) => {
    setSelectedQuizId(quizId);
    setCurrentPage('quiz');
  };

  const handleViewQuestions = () => {
    setCurrentPage('questions');
  };

  // Render current page
  switch (currentPage) {
    case 'login':
      return <Login onLogin={handleLogin} onSwitchToRegister={() => setCurrentPage('register')} />;
    
    case 'register':
      return <Register onRegister={handleRegister} onSwitchToLogin={() => setCurrentPage('login')} />;
    
    case 'dashboard':
      return (
        <UserDashboard
          user={user}
          onLogout={handleLogout}
          onTakeQuiz={handleTakeQuiz}
          onViewQuestions={handleViewQuestions}
        />
      );
    
    case 'quiz':
      return (
        <div className="min-h-screen flex items-center justify-center">
          <Card variant="neon" className="p-8 text-center">
            <h2 className="text-2xl font-bold text-gradient-electric mb-4">Quiz Feature Coming Soon! 🚀</h2>
            <p className="text-secondary-400 mb-6">We're building an amazing quiz experience for you.</p>
            <Button onClick={() => setCurrentPage('dashboard')} icon="🏠">
              Back to Dashboard
            </Button>
          </Card>
        </div>
      );
    
    case 'questions':
      return (
        <div className="min-h-screen flex items-center justify-center">
          <Card variant="neon" className="p-8 text-center">
            <h2 className="text-2xl font-bold text-gradient-electric mb-4">Question Management Coming Soon! ⚙️</h2>
            <p className="text-secondary-400 mb-6">Premium admin features are being developed.</p>
            <Button onClick={() => setCurrentPage('dashboard')} icon="🏠">
              Back to Dashboard
            </Button>
          </Card>
        </div>
      );
    
    default:
      return <Login onLogin={handleLogin} onSwitchToRegister={() => setCurrentPage('register')} />;
  }
}

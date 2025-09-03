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
        method: 'POST',
        body: { username, password },
      });
      if (!data?.token) throw new Error('No token in login response.');

      localStorage.setItem('quiz_app_token', data.token);
      setToken(data.token);
      const decoded = parseJwt(data.token);
      const roles = extractRoles(decoded);
      setUser({ username: decoded?.sub || decoded?.username || username, roles, });
      showMessage('Login successful!', 'success');
    } catch (error) {
      showMessage(error.message || 'Login failed. Check credentials.', 'error');
    }
  };

  const handleRegister = async (username, password, email) => {
    try {
      await apiFetch('/auth/register', {
        method: 'POST',
        body: { username, password, email },
      });
      showMessage('Registration successful! Please log in.', 'success');
      setPage('login');
    } catch (error) {
      showMessage(error.message || 'Registration failed.', 'error');
    }
  };

  const handleLogout = () => {
    setToken(null);
    setUser(null);
    localStorage.removeItem('quiz_app_token');
    setPage('login');
    showMessage('You have been logged out.', 'success');
  };

  // --- Navigation ---
  const navigateTo = (newPage) => setPage(newPage);
  const startQuiz = (quizId) => {
    setSelectedQuizId(quizId);
    setPage('quiz');
  };
  const editQuestion = (question) => {
    setSelectedQuestion(question);
    setPage('update_question');
  };

  // --- Component Rendering Logic ---
  const renderPage = () => {
    switch (page) {
      case 'register':
        return <Register onRegister={handleRegister} navigateTo={navigateTo} />;
      case 'user_dashboard':
        return <UserDashboard startQuiz={startQuiz} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'admin_dashboard':
        return <AdminDashboard navigateTo={navigateTo} />;
      case 'create_admin':
        return <CreateAdminUser navigateTo={navigateTo} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'manage_quizzes':
        return <ManageQuizzes navigateTo={navigateTo} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'manage_questions':
        return <ManageQuestions navigateTo={navigateTo} editQuestion={editQuestion} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'quiz':
        return <Quiz quizId={selectedQuizId} navigateTo={navigateTo} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'add_question':
        return <AddQuestion navigateTo={navigateTo} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'update_question':
        return <UpdateQuestion question={selectedQuestion} navigateTo={navigateTo} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'create_quiz':
        return <CreateQuiz navigateTo={navigateTo} apiFetch={apiFetch} showMessage={showMessage} />;
      case 'login':
      default:
        return <Login onLogin={handleLogin} navigateTo={navigateTo} />;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-50 via-primary-50 to-secondary-50">
      {/* 🎨 Premium Navigation Header */}
      <header className="sticky top-0 z-50 glass-card border-b border-white/20">
        <nav className="container mx-auto mobile-padding py-4">
          <div className="flex justify-between items-center">
            {/* Logo & Brand */}
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-r from-primary-600 to-secondary-600 rounded-xl flex items-center justify-center shadow-lg">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white">
                  <path d="M9 11H5a2 2 0 0 0-2 2v3c0 1.1.9 2 2 2h4m0-6V9a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-8a2 2 0 0 1-2-2z"/>
                  <circle cx="9" cy="9" r="1"/>
                  <path d="M19 15v-3"/>
                </svg>
              </div>
              <div className="hidden sm:block">
                <h1 className="text-xl font-bold text-gradient">QuizMaster Pro</h1>
                <p className="text-xs text-neutral-500">Premium Quiz Platform</p>
              </div>
            </div>
            
            {/* User Menu */}
            {user && (
              <div className="flex items-center space-x-4">
                <div className="hidden md:flex items-center space-x-3">
                  <div className="w-8 h-8 bg-gradient-to-r from-accent-500 to-accent-600 rounded-full flex items-center justify-center shadow-md">
                    <span className="text-white text-sm font-semibold">
                      {user.username.charAt(0).toUpperCase()}
                    </span>
                  </div>
                  <div className="hidden lg:block">
                    <p className="text-sm font-medium text-neutral-800">Welcome back,</p>
                    <p className="text-sm text-primary-600 font-semibold">{user.username}</p>
                  </div>
                </div>
                <button 
                  onClick={handleLogout} 
                  className="btn-ghost !p-2 !px-4 text-red-600 hover:bg-red-50 hover:text-red-700"
                  title="Logout"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                    <polyline points="16,17 21,12 16,7"/>
                    <line x1="21" y1="12" x2="9" y2="12"/>
                  </svg>
                  <span className="hidden sm:inline ml-2">Logout</span>
                </button>
              </div>
            )}
          </div>
        </nav>
      </header>

      {/* 🎭 Main Content Area */}
      <main className="container mx-auto mobile-padding py-8">
        {/* Status Messages */}
        {message.text && (
          <div className="mb-8 animate-slide-down">
            <Message text={message.text} type={message.type} />
          </div>
        )}
        
        {/* Page Content */}
        <div className="animate-fade-in">
          {renderPage()}
        </div>
      </main>

      {/* 🌟 Premium Footer */}
      <footer className="mt-auto py-8 text-center text-neutral-500 text-sm">
        <div className="container mx-auto mobile-padding">
          <p>&copy; 2025 QuizMaster Pro. Crafted with ❤️ for better learning.</p>
        </div>
      </footer>
    </div>
  );
}

// --- 🎨 Premium Reusable UI Components ---

// Enhanced Card Component with Glass Morphism
const Card = ({ children, className = '', variant = 'default' }) => {
  const variants = {
    default: 'card-premium',
    glass: 'glass-card p-8 rounded-2xl',
    elevated: 'bg-white p-8 rounded-2xl shadow-2xl border border-neutral-200',
    gradient: 'bg-gradient-to-br from-primary-50 to-secondary-50 p-8 rounded-2xl shadow-xl border border-white'
  };
  
  return (
    <div className={`${variants[variant]} animate-scale-in ${className}`}>
      {children}
    </div>
  );
};

// Premium Button Component
const Button = ({ 
  children, 
  onClick, 
  className = '', 
  type = 'button', 
  disabled = false, 
  variant = 'primary',
  size = 'md',
  loading = false,
  icon = null
}) => {
  const variants = {
    primary: 'btn-primary',
    secondary: 'btn-secondary',
    ghost: 'btn-ghost',
    danger: 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500/50'
  };
  
  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-sm',
    lg: 'px-8 py-4 text-base',
    xl: 'px-10 py-5 text-lg'
  };
  
  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled || loading}
      className={`${variants[variant]} ${sizes[size]} inline-flex items-center justify-center font-medium transition-all duration-200 ease-in-out border border-transparent rounded-xl shadow-lg hover:shadow-xl hover:scale-105 focus:outline-none focus:ring-4 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 ${className}`}
    >
      {loading && (
        <div className="loader mr-2"></div>
      )}
      {icon && !loading && (
        <span className="mr-2">{icon}</span>
      )}
      {children}
    </button>
  );
};

// Enhanced Input Component
const Input = ({ 
  id, 
  type = 'text', 
  placeholder, 
  value, 
  onChange, 
  required = false, 
  className = '',
  error = null,
  icon = null,
  label = null
}) => (
  <div className="form-group">
    {label && (
      <label htmlFor={id} className="form-label">
        {label}
        {required && <span className="text-red-500 ml-1">*</span>}
      </label>
    )}
    <div className="relative">
      {icon && (
        <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
          <span className="text-neutral-400">{icon}</span>
        </div>
      )}
      <input
        id={id}
        type={type}
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        required={required}
        className={`input-field ${icon ? 'pl-10' : ''} ${error ? 'border-red-500 focus:border-red-500 focus:ring-red-500/50' : ''} ${className}`}
      />
    </div>
    {error && <p className="form-error">{error}</p>}
  </div>
);

// Enhanced Select Component
const Select = ({ 
  id, 
  value, 
  onChange, 
  children, 
  required = false, 
  className = '',
  label = null,
  error = null 
}) => (
  <div className="form-group">
    {label && (
      <label htmlFor={id} className="form-label">
        {label}
        {required && <span className="text-red-500 ml-1">*</span>}
      </label>
    )}
    <select
      id={id}
      value={value}
      onChange={onChange}
      required={required}
      className={`input-field ${error ? 'border-red-500 focus:border-red-500 focus:ring-red-500/50' : ''} ${className}`}
    >
      {children}
    </select>
    {error && <p className="form-error">{error}</p>}
  </div>
);

// Premium Message Component
const Message = ({ text, type, onClose = null }) => {
  const getIcon = () => {
    switch (type) {
      case 'success':
        return (
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
          </svg>
        );
      case 'error':
        return (
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
          </svg>
        );
      default:
        return (
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
          </svg>
        );
    }
  };

  const statusClass = type === 'success' ? 'status-success' : type === 'error' ? 'status-error' : 'status-info';

  return (
    <div className={`${statusClass} animate-slide-down`}>
      <div className="flex items-center">
        {getIcon()}
        <div className="ml-3 flex-1">
          <p className="font-medium">
            {type === 'success' ? 'Success!' : type === 'error' ? 'Error!' : 'Info'}
          </p>
          <p className="text-sm opacity-90">{text}</p>
        </div>
        {onClose && (
          <button
            onClick={onClose}
            className="ml-4 p-1 rounded-full hover:bg-black/10 transition-colors"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
            </svg>
          </button>
        )}
      </div>
    </div>
  );
};

// Premium Loading Spinner
const Spinner = ({ size = 'md', text = null }) => {
  const sizes = {
    sm: 'h-8 w-8',
    md: 'h-16 w-16',
    lg: 'h-24 w-24'
  };

  return (
    <div className="flex flex-col justify-center items-center h-64 space-y-4">
      <div className={`animate-spin rounded-full border-4 border-primary-200 border-t-primary-600 ${sizes[size]}`}></div>
      {text && <p className="text-neutral-600 animate-pulse">{text}</p>}
    </div>
  );
};

// --- 🔐 Premium Authentication Pages ---
function Login({ onLogin, navigateTo }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      await onLogin(username, password);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-[80vh] flex items-center justify-center py-12">
      <div className="w-full max-w-md">
        {/* Login Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-gradient-to-r from-primary-600 to-secondary-600 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white">
              <path d="M15 3h6v6"/>
              <path d="M10 14 21 3"/>
              <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/>
            </svg>
          </div>
          <h1 className="text-3xl font-bold text-gradient mb-2">Welcome Back!</h1>
          <p className="text-neutral-600">Sign in to access your quiz dashboard</p>
        </div>

        {/* Login Form */}
        <Card variant="glass" className="backdrop-blur-xl">
          <form onSubmit={handleSubmit} className="space-y-6">
            <Input
              id="username"
              type="text"
              label="Username"
              placeholder="Enter your username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
              icon={
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
              }
            />
            
            <Input
              id="password"
              type="password"
              label="Password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              icon={
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              }
            />

            <Button 
              type="submit" 
              loading={loading}
              variant="primary"
              size="lg"
              className="w-full"
            >
              {loading ? 'Signing In...' : 'Sign In'}
            </Button>
          </form>

          <div className="mt-8 text-center">
            <p className="text-neutral-600">
              Don't have an account?{' '}
              <button 
                onClick={() => navigateTo('register')} 
                className="font-semibold text-primary-600 hover:text-primary-700 transition-colors"
              >
                Create Account
              </button>
            </p>
          </div>
        </Card>

        {/* Demo Credentials */}
        <div className="mt-6 p-4 bg-neutral-50 rounded-xl border border-neutral-200">
          <p className="text-xs text-neutral-500 text-center mb-2">🎯 Demo Credentials</p>
          <div className="grid grid-cols-2 gap-4 text-xs">
            <div className="text-center">
              <p className="font-medium text-neutral-700">Admin</p>
              <p className="text-neutral-500">admin / admin123</p>
            </div>
            <div className="text-center">
              <p className="font-medium text-neutral-700">User</p>
              <p className="text-neutral-500">user / user123</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function Register({ onRegister, navigateTo }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      await onRegister(username, password, email);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-[80vh] flex items-center justify-center py-12">
      <div className="w-full max-w-md">
        {/* Register Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-gradient-to-r from-accent-600 to-primary-600 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white">
              <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
              <circle cx="9" cy="7" r="4"/>
              <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
              <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
            </svg>
          </div>
          <h1 className="text-3xl font-bold text-gradient mb-2">Join QuizMaster!</h1>
          <p className="text-neutral-600">Create your account to start learning</p>
        </div>

        {/* Register Form */}
        <Card variant="glass" className="backdrop-blur-xl">
          <form onSubmit={handleSubmit} className="space-y-6">
            <Input
              id="username-reg"
              type="text"
              label="Username"
              placeholder="Choose a username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
              icon={
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
              }
            />

            <Input
              id="email-reg"
              type="email"
              label="Email"
              placeholder="your@email.com (optional)"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              icon={
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
                </svg>
              }
            />
            
            <Input
              id="password-reg"
              type="password"
              label="Password"
              placeholder="Create a secure password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              icon={
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              }
            />

            <Button 
              type="submit" 
              loading={loading}
              variant="primary"
              size="lg"
              className="w-full"
            >
              {loading ? 'Creating Account...' : 'Create Account'}
            </Button>
          </form>

          <div className="mt-8 text-center">
            <p className="text-neutral-600">
              Already have an account?{' '}
              <button 
                onClick={() => navigateTo('login')} 
                className="font-semibold text-primary-600 hover:text-primary-700 transition-colors"
              >
                Sign In
              </button>
            </p>
          </div>
        </Card>
      </div>
    </div>
  );
}

// --- 👤 Premium User Pages ---
function UserDashboard({ startQuiz, apiFetch, showMessage }) {
  const [quizzes, setQuizzes] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchQuizzes = async () => {
      try {
        const data = await apiFetch('/user/quiz/all');
        setQuizzes(Array.isArray(data) ? data : []);
      } catch (error) {
        showMessage(error.message || 'Failed to fetch quizzes.', 'error');
      } finally {
        setIsLoading(false);
      }
    };
    fetchQuizzes();
  }, [apiFetch, showMessage]);

  if (isLoading) return <Spinner size="lg" text="Loading your quizzes..." />;

  return (
    <div className="space-y-8">
      {/* Dashboard Header */}
      <div className="text-center py-12">
        <div className="w-20 h-20 bg-gradient-to-r from-primary-600 to-secondary-600 rounded-3xl flex items-center justify-center mx-auto mb-6 shadow-xl animate-bounce-gentle">
          <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white">
            <path d="M12 2L2 7l10 5 10-5-10-5z"/>
            <path d="M2 17l10 5 10-5"/>
            <path d="M2 12l10 5 10-5"/>
          </svg>
        </div>
        <h1 className="text-4xl font-bold text-gradient mb-4">Quiz Dashboard</h1>
        <p className="text-lg text-neutral-600 max-w-2xl mx-auto">
          Challenge yourself with our premium quiz collection. Track your progress and master new skills!
        </p>
      </div>

      {/* Quiz Statistics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card variant="gradient" className="text-center">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mx-auto mb-4">
            <svg className="w-6 h-6 text-primary-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <h3 className="text-2xl font-bold text-primary-800 mb-2">{quizzes.length}</h3>
          <p className="text-primary-700 font-medium">Available Quizzes</p>
        </Card>

        <Card variant="gradient" className="text-center">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mx-auto mb-4">
            <svg className="w-6 h-6 text-accent-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
          </div>
          <h3 className="text-2xl font-bold text-accent-800 mb-2">
            {quizzes.reduce((total, quiz) => total + (Array.isArray(quiz.questions) ? quiz.questions.length : 0), 0)}
          </h3>
          <p className="text-accent-700 font-medium">Total Questions</p>
        </Card>

        <Card variant="gradient" className="text-center">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mx-auto mb-4">
            <svg className="w-6 h-6 text-secondary-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <h3 className="text-2xl font-bold text-secondary-800 mb-2">∞</h3>
          <p className="text-secondary-700 font-medium">Learning Time</p>
        </Card>
      </div>

      {/* Available Quizzes */}
      <div>
        <div className="flex items-center justify-between mb-8">
          <h2 className="text-2xl font-bold text-neutral-800">Available Quizzes</h2>
          <div className="badge badge-primary">
            {quizzes.length} Quiz{quizzes.length !== 1 ? 'es' : ''}
          </div>
        </div>

        {quizzes.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {quizzes.map((quiz, index) => (
              <Card 
                key={quiz.id} 
                variant="elevated" 
                className="card-interactive group hover:shadow-glow transition-all duration-300"
                style={{ animationDelay: `${index * 0.1}s` }}
              >
                {/* Quiz Icon */}
                <div className="w-16 h-16 bg-gradient-to-r from-primary-500 to-secondary-500 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white">
                    <circle cx="12" cy="12" r="3"/>
                    <path d="M12 1v6m0 6v6"/>
                    <path d="M1 12h6m6 0h6"/>
                  </svg>
                </div>

                {/* Quiz Content */}
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-neutral-800 mb-3 group-hover:text-primary-600 transition-colors">
                    {quiz.title}
                  </h3>
                  
                  <div className="flex items-center text-neutral-600 mb-4">
                    <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span className="text-sm font-medium">
                      {Array.isArray(quiz.questions) ? quiz.questions.length : 0} Questions
                    </span>
                  </div>

                  <div className="flex items-center text-neutral-500 text-sm mb-6">
                    <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span>~{Math.ceil((Array.isArray(quiz.questions) ? quiz.questions.length : 0) * 1.5)} min</span>
                  </div>
                </div>

                {/* Start Quiz Button */}
                <Button
                  onClick={() => startQuiz(quiz.id)}
                  variant="primary"
                  size="md"
                  className="w-full group-hover:shadow-xl"
                  icon={
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h1.5a1.5 1.5 0 011.5 1.5v1a1.5 1.5 0 01-1.5 1.5H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  }
                >
                  Start Quiz
                </Button>
              </Card>
            ))}
          </div>
        ) : (
          <Card variant="glass" className="text-center py-16">
            <div className="w-20 h-20 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <svg className="w-10 h-10 text-neutral-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9.172 16.172a4 4 0 015.656 0M9 12h6m-6-4h6m2 5.291A7.962 7.962 0 0112 15c-2.34 0-4.467-.881-6.078-2.33l-.732-.732A7.937 7.937 0 014 9c0-4.418 3.582-8 8-8s8 3.582 8 8c0 1.537-.437 2.97-1.19 4.18l-.732.732A7.962 7.962 0 0112 15z" />
              </svg>
            </div>
            <h3 className="text-xl font-bold text-neutral-600 mb-2">No Quizzes Available</h3>
            <p className="text-neutral-500">Check back later for new challenges!</p>
          </Card>
        )}
      </div>
    </div>
  );
}

function Quiz({ quizId, navigateTo, apiFetch, showMessage }) {
  const [questions, setQuestions] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState({});
  const [isLoading, setIsLoading] = useState(true);
  const [result, setResult] = useState(null);

  useEffect(() => {
    const fetchQuestions = async () => {
      if (!quizId) return;
      try {
        const data = await apiFetch(`/user/quiz/get/${quizId}`);
        setQuestions(Array.isArray(data) ? data : []);
      } catch (error) {
        showMessage(error.message || 'Failed to load quiz questions.', 'error');
      } finally {
        setIsLoading(false);
      }
    };
    fetchQuestions();
  }, [quizId, apiFetch, showMessage]);

  const handleSelect = (qId, option) => setAnswers((prev) => ({ ...prev, [qId]: option }));

  const handleSubmit = async () => {
    const responses = questions.map((q) => ({ id: q.id, response: answers[q.id] || '' }));
    try {
      const data = await apiFetch(`/user/quiz/submit/${quizId}`, { method: 'POST', body: responses });
      const score = typeof data === 'number' ? data : data?.score;
      setResult(score ?? 0);
      showMessage('Quiz submitted!', 'success');
    } catch (error) {
      showMessage(error.message || 'Failed to submit quiz.', 'error');
    }
  };

  if (isLoading) return <Spinner size="lg" text="Loading quiz questions..." />;

  // Quiz Results Screen
  if (result !== null) {
    const percentage = Math.round((result / questions.length) * 100);
    const isExcellent = percentage >= 90;
    const isGood = percentage >= 70;
    const isPassing = percentage >= 50;

    return (
      <div className="max-w-2xl mx-auto">
        <Card variant="glass" className="text-center py-16">
          {/* Result Icon */}
          <div className={`w-24 h-24 mx-auto mb-8 rounded-full flex items-center justify-center ${
            isExcellent ? 'bg-gradient-to-r from-yellow-400 to-yellow-600' :
            isGood ? 'bg-gradient-to-r from-accent-500 to-accent-600' :
            isPassing ? 'bg-gradient-to-r from-primary-500 to-primary-600' :
            'bg-gradient-to-r from-neutral-400 to-neutral-600'
          } shadow-xl animate-scale-in`}>
            {isExcellent ? (
              <svg className="w-12 h-12 text-white" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
            ) : isGood ? (
              <svg className="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            ) : isPassing ? (
              <svg className="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L7 11v9m7-10h-2M7 20H5a2 2 0 01-2-2v-6a2 2 0 012-2h2.5" />
              </svg>
            ) : (
              <svg className="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            )}
          </div>

          {/* Result Message */}
          <h2 className="text-4xl font-bold text-gradient mb-4">Quiz Complete!</h2>
          <p className="text-lg text-neutral-600 mb-8">
            {isExcellent ? "🎉 Outstanding performance!" :
             isGood ? "✨ Great job!" :
             isPassing ? "👍 Well done!" :
             "📚 Keep practicing!"}
          </p>

          {/* Score Display */}
          <div className="bg-white/50 backdrop-blur rounded-2xl p-8 mb-8 max-w-sm mx-auto">
            <p className="text-sm font-medium text-neutral-600 mb-2">Your Score</p>
            <div className="text-6xl font-bold text-gradient mb-2">
              {result}<span className="text-2xl text-neutral-500">/{questions.length}</span>
            </div>
            <div className="progress-bar mb-2">
              <div 
                className="progress-fill" 
                style={{ width: `${percentage}%` }}
              ></div>
            </div>
            <p className="text-lg font-semibold text-neutral-700">{percentage}%</p>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button 
              onClick={() => navigateTo('user_dashboard')} 
              variant="primary"
              size="lg"
              icon={
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                </svg>
              }
            >
              Back to Dashboard
            </Button>
            <Button 
              onClick={() => window.location.reload()} 
              variant="secondary"
              size="lg"
              icon={
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
              }
            >
              Retake Quiz
            </Button>
          </div>
        </Card>
      </div>
    );
  }

  const q = questions[currentIndex];
  if (!q) return <p>No questions found.</p>;
  
  const options = [q.option1, q.option2, q.option3, q.option4].filter(Boolean);
  const progress = ((currentIndex + 1) / questions.length) * 100;

  return (
    <div className="max-w-4xl mx-auto">
      {/* Quiz Header */}
      <div className="mb-8">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center space-x-3">
            <Button
              onClick={() => navigateTo('user_dashboard')}
              variant="ghost"
              size="sm"
              icon={
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" />
                </svg>
              }
            >
              Exit Quiz
            </Button>
          </div>
          <div className="text-sm font-medium text-neutral-600">
            Question {currentIndex + 1} of {questions.length}
          </div>
        </div>
        
        {/* Progress Bar */}
        <div className="progress-bar">
          <div 
            className="progress-fill transition-all duration-500 ease-out" 
            style={{ width: `${progress}%` }}
          ></div>
        </div>
      </div>

      {/* Question Card */}
      <Card variant="elevated" className="mb-8">
        <div className="flex items-start space-x-4 mb-8">
          <div className="w-12 h-12 bg-gradient-to-r from-primary-500 to-secondary-500 rounded-xl flex items-center justify-center flex-shrink-0">
            <span className="text-white font-bold">{currentIndex + 1}</span>
          </div>
          <div className="flex-1">
            <h2 className="text-2xl font-bold text-neutral-800 leading-relaxed">
              {q.question_title}
            </h2>
          </div>
        </div>

        {/* Answer Options */}
        <div className="space-y-4">
          {options.map((opt, i) => {
            const optionLabels = ['A', 'B', 'C', 'D'];
            const isSelected = answers[q.id] === opt;
            
            return (
              <button
                key={i}
                onClick={() => handleSelect(q.id, opt)}
                className={`quiz-option ${isSelected ? 'quiz-option-selected' : ''} group`}
              >
                <div className="flex items-center space-x-4">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm transition-all ${
                    isSelected 
                      ? 'bg-primary-500 text-white' 
                      : 'bg-neutral-100 text-neutral-600 group-hover:bg-primary-100 group-hover:text-primary-600'
                  }`}>
                    {optionLabels[i]}
                  </div>
                  <span className="flex-1 text-left font-medium">{opt}</span>
                  {isSelected && (
                    <svg className="w-5 h-5 text-primary-500" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                    </svg>
                  )}
                </div>
              </button>
            );
          })}
        </div>
      </Card>

      {/* Navigation */}
      <div className="flex justify-between items-center">
        <Button
          onClick={() => setCurrentIndex((i) => i - 1)}
          disabled={currentIndex === 0}
          variant="secondary"
          size="lg"
          icon={
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" />
            </svg>
          }
        >
          Previous
        </Button>

        <div className="flex space-x-2">
          {questions.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentIndex(index)}
              className={`w-3 h-3 rounded-full transition-all ${
                index === currentIndex 
                  ? 'bg-primary-500 scale-125' 
                  : answers[questions[index]?.id] 
                    ? 'bg-accent-500' 
                    : 'bg-neutral-300 hover:bg-neutral-400'
              }`}
            />
          ))}
        </div>

        {currentIndex === questions.length - 1 ? (
          <Button
            onClick={handleSubmit}
            variant="primary"
            size="lg"
            disabled={!answers[q.id]}
            icon={
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            }
          >
            Submit Quiz
          </Button>
        ) : (
          <Button
            onClick={() => setCurrentIndex((i) => i + 1)}
            variant="primary"
            size="lg"
            icon={
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 5l7 7-7 7" />
              </svg>
            }
          >
            Next
          </Button>
        )}
      </div>
    </div>
  );
}

// --- Admin Pages ---
function AdminDashboard({ navigateTo }) {
  return (
    <Card>
      <h2 className="text-3xl font-bold text-center mb-8">Admin Dashboard</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div onClick={() => navigateTo('manage_quizzes')} className="p-8 bg-blue-500 text-white rounded-lg text-center cursor-pointer hover:bg-blue-600 transition-colors">
          <h3 className="text-2xl font-bold">Manage Quizzes</h3>
          <p className="mt-2">View, create, and delete quizzes.</p>
        </div>
        <div onClick={() => navigateTo('manage_questions')} className="p-8 bg-green-500 text-white rounded-lg text-center cursor-pointer hover:bg-green-600 transition-colors">
          <h3 className="text-2xl font-bold">Manage Questions</h3>
          <p className="mt-2">View, create, update, and delete questions.</p>
        </div>
        <div onClick={() => navigateTo('create_admin')} className="p-8 bg-purple-500 text-white rounded-lg text-center cursor-pointer hover:bg-purple-600 transition-colors">
            <h3 className="text-2xl font-bold">Create User</h3>
            <p className="mt-2">Register a new user with a specific role.</p>
        </div>
      </div>
    </Card>
  );
}

function CreateAdminUser({ navigateTo, apiFetch, showMessage }) {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [email, setEmail] = useState('');
    const [role, setRole] = useState('ADMIN');

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await apiFetch('/auth/admin/register', {
                method: 'POST',
                body: { username, password, email, role },
            });
            showMessage(`User '${username}' registered successfully with role ${role}!`, 'success');
            navigateTo('admin_dashboard');
        } catch (error) {
            showMessage(error.message || 'Registration failed.', 'error');
        }
    };

    return (
        <Card>
            <h2 className="text-3xl font-bold text-center mb-6">Create New User</h2>
            <form onSubmit={handleSubmit} className="space-y-6 max-w-lg mx-auto">
                <div>
                    <label htmlFor="username-admin-reg" className="block text-sm font-medium text-gray-700">Username</label>
                    <Input id="username-admin-reg" type="text" value={username} onChange={(e) => setUsername(e.target.value)} required />
                </div>
                <div>
                    <label htmlFor="email-admin-reg" className="block text-sm font-medium text-gray-700">Email (Optional)</label>
                    <Input id="email-admin-reg" type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
                </div>
                <div>
                    <label htmlFor="password-admin-reg" className="block text-sm font-medium text-gray-700">Password</label>
                    <Input id="password-admin-reg" type="password" value={password} onChange={(e) => setPassword(e.target.value)} required />
                </div>
                <div>
                    <label htmlFor="role-select" className="block text-sm font-medium text-gray-700">Role</label>
                     <Select id="role-select" value={role} onChange={(e) => setRole(e.target.value)} required>
                        <option value="ADMIN">ADMIN</option>
                        <option value="USER">USER</option>
                    </Select>
                </div>
                <div className="flex space-x-4 pt-4">
                    <Button type="button" onClick={() => navigateTo('admin_dashboard')} className="bg-gray-500 hover:bg-gray-600">Cancel</Button>
                    <Button type="submit">Create User</Button>
                </div>
            </form>
        </Card>
    );
}

function ManageQuizzes({ navigateTo, apiFetch, showMessage }) {
  const [quizzes, setQuizzes] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  const fetchQuizzes = useCallback(async () => {
    setIsLoading(true);
    try {
      const data = await apiFetch('/user/quiz/all');
      setQuizzes(Array.isArray(data) ? data : []);
    } catch (error) {
      showMessage(error.message || 'Failed to fetch quizzes', 'error');
    } finally {
      setIsLoading(false);
    }
  }, [apiFetch, showMessage]);

  useEffect(() => { fetchQuizzes(); }, [fetchQuizzes]);

  const deleteQuiz = async (id) => {
    if (window.confirm('Are you sure you want to delete this quiz?')) {
      try {
        await apiFetch(`/admin/quiz/delete/${id}`, { method: 'DELETE' });
        showMessage('Quiz deleted successfully.', 'success');
        fetchQuizzes();
      } catch (error) {
        showMessage(error.message || 'Failed to delete quiz.', 'error');
      }
    }
  };

  if (isLoading) return <Spinner />;
  return (
    <Card>
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-3xl font-bold">Manage Quizzes ({quizzes.length})</h2>
        <div className="flex space-x-4">
          <Button onClick={() => navigateTo('create_quiz')} className="w-auto bg-green-500 hover:bg-green-600">Create Quiz</Button>
          <Button onClick={() => navigateTo('admin_dashboard')} className="w-auto bg-gray-500 hover:bg-gray-600">Back</Button>
        </div>
      </div>
      <div className="max-h-[60vh] overflow-y-auto space-y-3 pr-2">
        {quizzes.length > 0 ? (
          quizzes.map((quiz) => (
            <div key={quiz.id} className="bg-gray-50 p-4 rounded-lg flex justify-between items-center border">
              <div><p className="font-semibold">{quiz.title}</p><p className="text-sm text-gray-500">{Array.isArray(quiz.questions) ? quiz.questions.length : 0} questions</p></div>
              <button onClick={() => deleteQuiz(quiz.id)} className="px-3 py-1 bg-red-500 text-white text-sm rounded hover:bg-red-600">Delete</button>
            </div>
          ))
        ) : <p className="text-gray-500">No quizzes created yet.</p>}
      </div>
    </Card>
  );
}

function ManageQuestions({ navigateTo, editQuestion, apiFetch, showMessage }) {
  const [questions, setQuestions] = useState([]);
  const [categories, setCategories] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [filter, setFilter] = useState('All');

  const fetchData = useCallback(async () => {
    setIsLoading(true);
    try {
      const [qs, cats] = await Promise.all([
        apiFetch('/admin/question/allQuestions'),
        apiFetch('/admin/question/categories'),
      ]);
      setQuestions(Array.isArray(qs) ? qs : []);
      setCategories(['All', ...(Array.isArray(cats) ? cats : [])]);
    } catch (error) {
      showMessage(error.message || 'Failed to fetch data', 'error');
    } finally {
      setIsLoading(false);
    }
  }, [apiFetch, showMessage]);

  useEffect(() => { fetchData(); }, [fetchData]);

  const deleteQuestion = async (id) => {
    if (window.confirm('Are you sure you want to delete this question?')) {
      try {
        await apiFetch(`/admin/question/delete/${id}`, { method: 'DELETE' });
        showMessage('Question deleted successfully.', 'success');
        fetchData();
      } catch (error) {
        showMessage(error.message || 'Failed to delete question.', 'error');
      }
    }
  };

  const filteredQuestions = filter === 'All' ? questions : questions.filter((q) => q.category === filter);

  if (isLoading) return <Spinner />;
  return (
    <Card>
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-3xl font-bold">Manage Questions ({filteredQuestions.length})</h2>
        <div className="flex space-x-4">
          <Button onClick={() => navigateTo('add_question')} className="w-auto bg-blue-500 hover:bg-blue-600">Add Question</Button>
          <Button onClick={() => navigateTo('admin_dashboard')} className="w-auto bg-gray-500 hover:bg-gray-600">Back</Button>
        </div>
      </div>
      <div className="flex justify-end items-center mb-4">
        <label htmlFor="category-filter" className="mr-2">Filter by Category:</label>
        <Select id="category-filter" value={filter} onChange={(e) => setFilter(e.target.value)} className="w-48">
          {categories.map((cat) => <option key={cat} value={cat}>{cat}</option>)}
        </Select>
      </div>
      <div className="max-h-[60vh] overflow-y-auto space-y-3 pr-2">
        {filteredQuestions.length > 0 ? (
          filteredQuestions.map((q) => (
            <div key={q.id} className="bg-gray-50 p-3 rounded-lg border">
              <p className="font-semibold">{q.question_title}</p>
              <p className="text-sm text-gray-500">Category: {q.category}</p>
              <div className="mt-2 flex space-x-2">
                <button onClick={() => editQuestion(q)} className="px-3 py-1 bg-yellow-500 text-white text-sm rounded hover:bg-yellow-600">Update</button>
                <button onClick={() => deleteQuestion(q.id)} className="px-3 py-1 bg-red-500 text-white text-sm rounded hover:bg-red-600">Delete</button>
              </div>
            </div>
          ))
        ) : <p className="text-gray-500">No questions found for this category.</p>}
      </div>
    </Card>
  );
}

function AddQuestion({ navigateTo, apiFetch, showMessage }) {
  const [formData, setFormData] = useState({ question_title: '', option1: '', option2: '', option3: '', option4: '', right_answer: '', difficultylevel: '', category: '' });
  const handleChange = (e) => setFormData({ ...formData, [e.target.id]: e.target.value });
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await apiFetch('/admin/question/addQuestions', { method: 'POST', body: formData });
      showMessage('Question added!', 'success');
      navigateTo('manage_questions');
    } catch (error) {
      showMessage(error.message || 'Failed to add question.', 'error');
    }
  };
  return (
    <Card>
      <h2 className="text-3xl font-bold mb-6">Add New Question</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <Input id="question_title" placeholder="Question Title" value={formData.question_title} onChange={handleChange} required />
        <Input id="option1" placeholder="Option 1" value={formData.option1} onChange={handleChange} required />
        <Input id="option2" placeholder="Option 2" value={formData.option2} onChange={handleChange} required />
        <Input id="option3" placeholder="Option 3" value={formData.option3} onChange={handleChange} required />
        <Input id="option4" placeholder="Option 4" value={formData.option4} onChange={handleChange} required />
        <Input id="right_answer" placeholder="Right Answer" value={formData.right_answer} onChange={handleChange} required />
        <Input id="difficultylevel" placeholder="Difficulty Level" value={formData.difficultylevel} onChange={handleChange} required />
        <Input id="category" placeholder="Category" value={formData.category} onChange={handleChange} required />
        <div className="flex space-x-4 pt-4">
          <Button type="button" onClick={() => navigateTo('manage_questions')} className="bg-gray-500 hover:bg-gray-600">Cancel</Button>
          <Button type="submit">Add Question</Button>
        </div>
      </form>
    </Card>
  );
}

function UpdateQuestion({ question, navigateTo, apiFetch, showMessage }) {
  const [formData, setFormData] = useState(question || {});
  const handleChange = (e) => setFormData({ ...formData, [e.target.id]: e.target.value });
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await apiFetch(`/admin/question/update/${question.id}`, { method: 'PUT', body: formData });
      showMessage('Question updated!', 'success');
      navigateTo('manage_questions');
    } catch (error) {
      showMessage(error.message || 'Failed to update question.', 'error');
    }
  };

  if (!question) return <Card>No question selected.</Card>;
  return (
    <Card>
      <h2 className="text-3xl font-bold mb-6">Update Question</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <Input id="question_title" placeholder="Question Title" value={formData.question_title || ''} onChange={handleChange} required />
        <Input id="option1" placeholder="Option 1" value={formData.option1 || ''} onChange={handleChange} required />
        <Input id="option2" placeholder="Option 2" value={formData.option2 || ''} onChange={handleChange} required />
        <Input id="option3" placeholder="Option 3" value={formData.option3 || ''} onChange={handleChange} required />
        <Input id="option4" placeholder="Option 4" value={formData.option4 || ''} onChange={handleChange} required />
        <Input id="right_answer" placeholder="Right Answer" value={formData.right_answer || ''} onChange={handleChange} required />
        <Input id="difficultylevel" placeholder="Difficulty Level" value={formData.difficultylevel || ''} onChange={handleChange} required />
        <Input id="category" placeholder="Category" value={formData.category || ''} onChange={handleChange} required />
        <div className="flex space-x-4 pt-4">
          <Button type="button" onClick={() => navigateTo('manage_questions')} className="bg-gray-500 hover:bg-gray-600">Cancel</Button>
          <Button type="submit">Update Question</Button>
        </div>
      </form>
    </Card>
  );
}

function CreateQuiz({ navigateTo, apiFetch, showMessage }) {
  const [category, setCategory] = useState('');
  const [numQ, setNumQ] = useState('');
  const [title, setTitle] = useState('');
  const [categories, setCategories] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchCategories = async () => {
      try {
        const data = await apiFetch('/admin/question/categories');
        setCategories(Array.isArray(data) ? data : []);
      } catch (error) {
        showMessage(error.message || 'Failed to fetch categories.', 'error');
      } finally {
        setIsLoading(false);
      }
    };
    fetchCategories();
  }, [apiFetch, showMessage]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const params = new URLSearchParams({ category, numQ, title });
    try {
      await apiFetch(`/admin/quiz/create?${params.toString()}`, { method: 'POST' });
      showMessage('Quiz created successfully!', 'success');
      navigateTo('manage_quizzes');
    } catch (error) {
      showMessage(error.message || 'Failed to create quiz.', 'error');
    }
  };
  if (isLoading) return <Spinner />;
  return (
    <Card>
      <h2 className="text-3xl font-bold mb-6">Create New Quiz</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <Input id="title" placeholder="Quiz Title" value={title} onChange={(e) => setTitle(e.target.value)} required />
        <Select id="category" value={category} onChange={(e) => setCategory(e.target.value)} required>
          <option value="" disabled>Select a Category</option>
          {categories.map((cat) => <option key={cat} value={cat}>{cat}</option>)}
        </Select>
        <Input id="numQ" type="number" placeholder="Number of Questions" value={numQ} onChange={(e) => setNumQ(e.target.value)} required />
        <div className="flex space-x-4 pt-4">
          <Button type="button" onClick={() => navigateTo('manage_quizzes')} className="bg-gray-500 hover:bg-gray-600">Cancel</Button>
          <Button type="submit">Create Quiz</Button>
        </div>
      </form>
    </Card>
  );
}
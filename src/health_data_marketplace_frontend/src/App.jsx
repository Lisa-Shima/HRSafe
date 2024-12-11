import React from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import LoginPage from "./pages/LoginPage";
import RegistrationPage from "./pages/RegistrationPage";

export default function App() {
  return (
    <Router>
      <div className="bg-gray-100 min-h-screen">
        <header className="bg-blue-600 p-4 text-white text-center">
          <h1 className="text-3xl font-bold">Healthcare System</h1>
        </header>
        <nav className="p-4 bg-white shadow-md flex justify-center space-x-4">
          <Link
            to="/login"
            className="text-blue-500 hover:text-blue-700 font-medium"
          >
            Login
          </Link>
          <Link
            to="/register"
            className="text-blue-500 hover:text-blue-700 font-medium"
          >
            Register
          </Link>
        </nav>
        <main className="p-6">
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/register" element={<RegistrationPage />} />
          </Routes>
        </main>
        <footer className="bg-blue-600 p-4 text-white text-center">
          <p>&copy; 2024 Healthcare System</p>
        </footer>
      </div>
    </Router>
  );
}

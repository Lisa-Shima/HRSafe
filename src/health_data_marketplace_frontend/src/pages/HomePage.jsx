import { Link } from "react-router-dom";

export default function HomePage() {
  return (
    <div className="min-h-screen bg-black flex flex-col justify-center items-center text-white py-10 px-4">
      <h1 className="text-5xl font-extrabold text-center mb-10">
        Welcome to the Healthcare System
      </h1>
      <nav className="space-y-4">
        <Link
          to="/login"
          className="text-lg font-semibold bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-lg transition duration-300"
        >
          Go to Login
        </Link>
        <Link
          to="/register"
          className="text-lg font-semibold bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-lg transition duration-300"
        >
          Go to Registration
        </Link>
      </nav>
    </div>
  );
}

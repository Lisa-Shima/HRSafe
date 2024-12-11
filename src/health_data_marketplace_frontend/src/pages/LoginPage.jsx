import React from "react";

export default function LoginPage() {
  return (
    <div className="max-w-md mx-auto bg-white shadow-lg rounded-lg p-6">
      <h2 className="text-2xl font-bold text-center text-blue-600 mb-4">
        Login
      </h2>
      <form>
        <div className="mb-4">
          <label className="block text-gray-700 mb-2" htmlFor="id">
            ID
          </label>
          <input
            type="text"
            id="id"
            className="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring focus:ring-blue-300"
          />
        </div>
        <div className="mb-4">
          <label className="block text-gray-700 mb-2" htmlFor="password">
            Password
          </label>
          <input
            type="password"
            id="password"
            className="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring focus:ring-blue-300"
          />
        </div>
        <button
          type="submit"
          className="w-full bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700 transition duration-300"
        >
          Login
        </button>
      </form>
    </div>
  );
}

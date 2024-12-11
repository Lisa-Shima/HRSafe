import React from "react";
import RegistrationForm from "../components/RegistrationForm";

export default function RegistrationPage() {
  return (
    <div className="min-h-screen bg-gray-100 py-10 px-4">
      <h1 className="text-4xl font-bold text-center text-gray-800 mb-10">
        Registration
      </h1>
      <div className="max-w-4xl mx-auto space-y-10">
        {/* Patient Registration */}
        <div className="bg-white shadow-lg rounded-lg p-6">
          <h2 className="text-2xl font-semibold text-gray-700 mb-4">
            Patient Registration
          </h2>
          <RegistrationForm role="patient" />
        </div>

        {/* Doctor Registration */}
        <div className="bg-white shadow-lg rounded-lg p-6">
          <h2 className="text-2xl font-semibold text-gray-700 mb-4">
            Doctor Registration
          </h2>
          <RegistrationForm role="doctor" />
        </div>
      </div>
    </div>
  );
}

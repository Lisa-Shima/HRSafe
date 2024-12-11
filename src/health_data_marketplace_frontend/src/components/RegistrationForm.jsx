import React, { useState } from "react";
import { registerPatient, registerDoctor } from "../services/api";

export default function RegistrationForm({ role }) {
  const [formData, setFormData] = useState({
    id: "",
    name: "",
    age: "",
    address: "",
    contact: "",
    ...(role === "patient"
      ? { insuranceTitle: "", insuranceNumber: "" }
      : {
          email: "",
          hospitalName: "",
          hospitalLocation: "",
          specialization: "",
        }),
    password: "",
  });
  const [message, setMessage] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    const result =
      role === "patient"
        ? await registerPatient(formData)
        : await registerDoctor(formData);

    if (result.ok) {
      setMessage("Registration successful!");
    } else {
      setMessage(`Registration failed: ${result.err}`);
    }
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>{role === "patient" ? "Patient" : "Doctor"} Registration</h2>
      {Object.keys(formData).map((key) => (
        <input
          key={key}
          type="text"
          name={key}
          placeholder={key}
          value={formData[key]}
          onChange={handleChange}
        />
      ))}
      <button type="submit">Register</button>
      {message && <p>{message}</p>}
    </form>
  );
}

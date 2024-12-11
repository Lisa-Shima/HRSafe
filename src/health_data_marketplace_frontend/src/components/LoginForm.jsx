import React, { useState } from "react";
import { loginPatient, loginDoctor } from "../services/api";

export default function LoginForm({ role }) {
  const [id, setId] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    const result =
      role === "patient"
        ? await loginPatient(id, password)
        : await loginDoctor(id, password);

    if (result.ok) {
      setMessage("Login successful!");
    } else {
      setMessage(`Login failed: ${result.err}`);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>{role === "patient" ? "Patient" : "Doctor"} Login</h2>
      <input
        type="text"
        placeholder="ID"
        value={id}
        onChange={(e) => setId(e.target.value)}
      />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />
      <button type="submit">Login</button>
      {message && <p>{message}</p>}
    </form>
  );
}

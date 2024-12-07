import React, { useState, useEffect } from "react";
import { AuthClient } from "@dfinity/auth-client";
import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory } from "declarations/health_data_marketplace_backend";

const App = () => {
  const [authClient, setAuthClient] = useState(null);
  const [actor, setActor] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState(null);
  const [name, setName] = useState("");
  const [role, setRole] = useState("Patient");

  useEffect(() => {
    AuthClient.create().then(async (client) => {
      setAuthClient(client);
      const isLoggedIn = await client.isAuthenticated();
      setIsAuthenticated(isLoggedIn);
      if (isLoggedIn) {
        initActor(client);
      }
    });
  }, []);

  const initActor = async (client) => {
    const identity = client.getIdentity();
    const agent = new HttpAgent({
      host: "localhost",
      port: "5943",
      identity: identity,
    });
    const newActor = Actor.createActor(idlFactory, {
      agent,
      canisterId: process.env.CANISTER_ID,
    });
    setActor(newActor);
    console.log(identity);
    console.log(process.env.CANISTER_ID);

    // const result = await newActor.getRole();
    // if (result.ok) {
    //   setUser(result.ok);
    // }
  };

  const login = async () => {
    await authClient.login({
      identityProvider: process.env.II_URL,
      onSuccess: () => {
        setIsAuthenticated(true);
        initActor(authClient);
      },
    });
  };

  const logout = async () => {
    await authClient.logout();
    setIsAuthenticated(false);
    setUser(null);
    setActor(null);
  };

  const register = async () => {
    if (actor) {
      const result = await actor.register(name, { [role]: null });
      if (result.ok) {
        alert("Registration successful");
        const loginResult = await actor.login();
        if (loginResult.ok) {
          setUser(loginResult.ok);
        }
      } else {
        alert(`Registration failed: ${result.err}`);
      }
    }
  };

  if (!isAuthenticated) {
    return (
      <div>
        <h1>Please log in</h1>
        <button onClick={login}>Login</button>
      </div>
    );
  }

  return (
    <div>
      <h1>Welcome, {user ? user.name : "User"}</h1>
      <button onClick={logout}>Logout</button>
      {!user && (
        <div>
          <h2>Register</h2>
          <input
            type="text"
            placeholder="Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
          <select value={role} onChange={(e) => setRole(e.target.value)}>
            <option value="Patient">Patient</option>
            <option value="Doctor">Doctor</option>
            <option value="Researcher">Researcher</option>
          </select>
          <button onClick={register}>Register</button>
        </div>
      )}
      {/* Add more components for health record management here */}
    </div>
  );
};

export default App;

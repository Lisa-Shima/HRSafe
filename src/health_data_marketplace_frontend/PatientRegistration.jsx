// import React, { useState } from 'react';
// import { Actor, HttpAgent } from '@dfinity/agent';
// import { idlFactory } from '../declarations/health_data_marketplace_backend/health_data_marketplace_backend.did.js';

// const canisterId = "bkyz2-fmaaa-aaaaa-qaaaq-cai"; // Replace with your canister ID
// const agent = new HttpAgent();

// if (process.env.DFX_NETWORK === "local") {
//   agent.fetchRootKey().catch((err) => {
//     console.error("Unable to fetch root key:", err);
//   });
// }

// const healthDataMarketplace = Actor.createActor(idlFactory, {
//   agent,
//   canisterId,
// });

// const PatientRegistration = () => {
//   const [patientInfo, setPatientInfo] = useState({
//     id: '',
//     name: '',
//     age: '',
//     address: '',
//     contact: '',
//     insurance: '',
//   });

//   const [message, setMessage] = useState('');

//   const handleInputChange = (e) => {
//     const { name, value } = e.target;
//     setPatientInfo({
//       ...patientInfo,
//       [name]: value,
//     });
//   };

//   const handleSubmit = async (e) => {
//     e.preventDefault();
    
//     const { id, name, age, address, contact, insurance } = patientInfo;
    
//     try {
//       const result = await healthDataMarketplace.registerPatient(
//         BigInt(id), name, BigInt(age), address, contact, insurance
//       );
//       setMessage(result);
//     } catch (err) {
//       console.error("Error registering patient:", err);
//       setMessage("An error occurred while registering the patient.");
//     }
//   };

//   return (
//     <div>
//       <h2>Patient Registration</h2>
//       <form onSubmit={handleSubmit}>
//         <label>
//           Patient ID:
//           <input
//             type="text"
//             name="id"
//             value={patientInfo.id}
//             onChange={handleInputChange}
//             required
//           />
//         </label>
//         <label>
//           Name:
//           <input
//             type="text"
//             name="name"
//             value={patientInfo.name}
//             onChange={handleInputChange}
//             required
//           />
//         </label>
//         <label>
//           Age:
//           <input
//             type="text"
//             name="age"
//             value={patientInfo.age}
//             onChange={handleInputChange}
//             required
//           />
//         </label>
//         <label>
//           Address:
//           <input
//             type="text"
//             name="address"
//             value={patientInfo.address}
//             onChange={handleInputChange}
//             required
//           />
//         </label>
//         <label>
//           Contact Info:
//           <input
//             type="text"
//             name="contact"
//             value={patientInfo.contact}
//             onChange={handleInputChange}
//             required
//           />
//         </label>
//         <label>
//           Insurance:
//           <input
//             type="text"
//             name="insurance"
//             value={patientInfo.insurance}
//             onChange={handleInputChange}
//             required
//           />
//         </label>
//         <button type="submit">Register Patient</button>
//       </form>
//       <p>{message}</p>
//     </div>
//   );
// };

// export default PatientRegistration;

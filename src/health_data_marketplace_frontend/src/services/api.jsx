import { createActor } from "declarations/health_data_marketplace_backend";

const backendActor = createActor(process.env.CANISTER_ID);

export const loginPatient = async (id, password) => {
  return await backendActor.loginPatient(id, password);
};

export const loginDoctor = async (id, password) => {
  return await backendActor.loginDoctor(id, password);
};

export const registerPatient = async (patientData) => {
  return await backendActor.registerPatient(
    patientData.id,
    patientData.name,
    patientData.age,
    patientData.address,
    patientData.contact,
    patientData.insuranceTitle,
    patientData.insuranceNumber,
    patientData.password
  );
};

export const registerDoctor = async (doctorData) => {
  return await backendActor.registerDoctor(
    doctorData.id,
    doctorData.name,
    doctorData.age,
    doctorData.address,
    doctorData.contact,
    doctorData.email,
    doctorData.hospitalName,
    doctorData.hospitalLocation,
    doctorData.specialization,
    doctorData.password
  );
};

export const searchPatients = async (token, searchTerm) => {
  return await backendActor.searchPatients(token, searchTerm);
};

export const getPatientRecords = async (token, patientId) => {
  return await backendActor.getPatientRecords(token, patientId);
};

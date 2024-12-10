import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
module {

    public type PatientID = Text;
    public type DoctorID = Text;

    public type InsuranceDetails = {
        title : Text;
        number : Text;
    };
    public type hospitalDetails = {
        name : Text;
        location : Text;
    };

    public type MedicalRecord = {
        patientId : PatientID;
        doctorId : DoctorID;
        date : Text;
        medicalHistory : Text;
        symptoms : [Text];
        diagnoses : [Text];
        prescriptions : [Text];
        treatmentPlan : Text;
    };

    public type Patient = {
        id : PatientID;
        name : Text;
        age : Nat;
        address : Text;
        contact : Text;
        insuranceDetails : InsuranceDetails;
        password : Text;
    };
    public type Doctor = {
        id : DoctorID;
        name : Text;
        age : Nat;
        address : Text;
        contact : Text;
        email : Text;
        hospital : hospitalDetails;
        specialization : Text;
        password : Text;
    };
    public type Patients = HashMap.HashMap<PatientID, Patient>;
    public type Doctors = HashMap.HashMap<DoctorID, Doctor>;
    public type MedicalRecords = HashMap.HashMap<Text, MedicalRecord>;

    public type RegistrationResult = {
        #success : Text;
        #failure : Text;
    };
};

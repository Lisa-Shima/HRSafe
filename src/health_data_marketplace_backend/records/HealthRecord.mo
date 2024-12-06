import Types "../types/Types";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Result "mo:base/Result";

module {

    public func createRecords() : Types.Records {
        HashMap.HashMap<Principal, [Types.HealthRecord]>(10, Principal.equal, Principal.hash);
    };

    public func addRecord(records : Types.Records, record : Types.HealthRecord) : async Result.Result<Text, Text> {
        let patientRecords = switch (records.get(record.patientId)) {
            case (?recList) { recList };
            case null { [] };
        };
        records.put(record.patientId, Array.append(patientRecords, [record]));
        #ok("Record added successfully");
    };

    public func getRecords(records : Types.Records, patientId : Principal) : async [Types.HealthRecord] {
        switch (records.get(patientId)) {
            case (?recList) { recList };
            case null { [] };
        };
    };
};

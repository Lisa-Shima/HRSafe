import Types "../types/Types";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

module {
    // public type Users = HashMap.HashMap<Principal, Types.User>;
    
    public func createUsers() : Types.Users {
        HashMap.HashMap<Principal, Types.User>(10, Principal.equal, Principal.hash)
    };

    public func registerUser(users: Types.Users, user : Types.User) : async Result.Result<Text, Text> {
    switch (users.get(user.id)) {
        case (?_) { #err("User already exists") };
        case null {
            users.put(user.id, user);
            #ok("User registered successfully")
        };
    }
};

public func loginUser(users: Types.Users, principal : Principal) : async Result.Result<Types.User, Text> {
    switch (users.get(principal)) {
        case (?user) { #ok(user) };
        case null { #err("User not found") };
    }
};

    public func getRole(users: Types.Users, principal : Principal) : ?Types.Role {
        switch (users.get(principal)) {
            case (?user) { ?user.role };
            case null { null };
        }
    };
};
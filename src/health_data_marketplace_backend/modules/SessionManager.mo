import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Time "mo:base/Time";
import Int "mo:base/Int";

module {
    public type Session = {
        userId : Text;
        token : Text;
        timestamp : Time.Time;
    };

    public class SessionManager() {
        private var sessions : ?HashMap.HashMap<Text, Session> = null;

        private func getSessions() : HashMap.HashMap<Text, Session> {
            switch (sessions) {
                case (null) {
                    let newSessions = HashMap.HashMap<Text, Session>(10, Text.equal, Text.hash);
                    sessions := ?newSessions;
                    newSessions;
                };
                case (?s) { s };
            };
        };

        public func createSession(userId : Text) : Text {
            // let token = Principal.toText(Principal.fromText(userId)) # "-" # Int.toText(Time.now());
            let token = userId # "-" # Int.toText(Time.now());
            let session = {
                userId = userId;
                token = token;
                timestamp = Time.now();
            };
            getSessions().put(token, session);
            token;
        };

        public func getSession(token : Text) : ?Session {
            getSessions().get(token);
        };

        public func expireSession(token : Text) : Bool {
            switch (getSessions().get(token)) {
                case (?session) {
                    let currentTime = Time.now();
                    if (currentTime > session.timestamp + 3600_000_000_000) {
                        ignore getSessions().remove(token);
                        true;
                    } else {
                        false;
                    };
                };
                case (null) {
                    false;
                };
            };
        };
    };
};

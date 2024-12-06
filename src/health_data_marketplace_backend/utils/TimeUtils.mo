import Int "mo:base/Int";

module {

    // Converts a millisecond timestamp into a formatted text date
    public func formatTimestamp(ts : Int) : Text {
        // Convert milliseconds to seconds
        let seconds = ts / 1000;
        // Create a custom date string (manual formatting)
        let dateStr = "Custom Date: " # Int.toText(seconds);
        return dateStr;
    };
};

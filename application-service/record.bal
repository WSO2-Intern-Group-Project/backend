type config record {
    string baseUrl;
    string primaryKey;
};
type request record {|
    string id?;
    string userEmail;
    string gnDomain;
    string reason;
    string requestedDate;
    string requestedBy;
    string requestType;
    boolean identityVerificationStatus;
    boolean addressVerificationStatus;
    boolean policeVerificationStatus;
    string overallStatus;
    string createdAt;
    string lastUpdatedAt;

|};
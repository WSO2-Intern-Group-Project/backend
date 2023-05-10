import ballerina/time;
import ballerina/sql;

# Result retrieved after a successfull database operation
# 
# + affectedRowCount - Rows affected by the operation  
# + lastInsertId - Inserted id by the operation
public type DbOperationSuccessResult record {|
    int? affectedRowCount;
    string|int? lastInsertId?;
|};

# Description
#
# + requestId - Field Description  
# + userEmail - Field Description  
# + gnDomain - Field Description  
# + reason - Field Description  
# + requestedDate - Field Description  
# + requestedBy - Field Description  
# + requestType - Field Description  
# + identityVerificationStatus - Field Description  
# + addressVerificationStatus - Field Description  
# + policeVerificationStatus - Field Description  
# + overallStatus - Field Description  
# + createdAt - Field Description  
# + lastUpdatedAt - Field Description
public type Request record {|
    @sql:Column {name: "request_id"}
    int requestId?;
    @sql:Column {name: "user_email"}
    string userEmail;
    @sql:Column {name: "gn_domain"}
    string gnDomain;
    string reason?;
    @sql:Column {name: "requested_date"}
    string requestedDate;
    @sql:Column {name: "requested_by"}
    string requestedBy?;
    @sql:Column {name: "type"}
    string requestType?;
    @sql:Column {name: "identity_verification_status"}
    string identityVerificationStatus?;
    @sql:Column {name: "address_verification_status"}
    string addressVerificationStatus?;
    @sql:Column {name: "police_verification_status"}
    string policeVerificationStatus?;
    @sql:Column {name: "overall_status"}
    string overallStatus;
    @sql:Column {name: "created_at"}
    time:Civil createdAt?;
    @sql:Column {name: "last_updated_at"}
    time:Civil lastUpdatedAt?;
|};
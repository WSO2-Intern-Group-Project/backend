import ballerina/http;

# 404 Not Found response 
# 
# + body - error message
public type AppNotFoundError record {|
    *http:NotFound;
    AppError body;
|};

# 500 Internal server error response 
# 
# + body - error message
public type AppServerError record {|
    *http:InternalServerError;
    AppError body;
|};

# 200 OK response 
# 
# + body - payload with success details
public type AppSuccess record {|
    *http:Ok;
    DbOperationSuccessResult body;
|};

# 400 Bad Request Error response
# 
# + body - error message
public type AppBadRequestError record{|
    *http:BadRequest;
    AppError body;
|};

# 401 Unauthorized response
#
# + body - error message
public type AppUnauthorizedError record {|
    *http:Unauthorized;
    AppError body;
|};

# 403 Forbidden response
#
# + body - error message
public type AppForbiddenError record {|
    *http:Forbidden;
    AppError body;
|};
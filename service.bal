import ballerina/http;
import ballerinax/azure_cosmosdb as cosmosdb;
import ballerina/log;
import ballerina/time;
import ballerina/uuid;
configurable config cosmosConfig = ?;

final cosmosdb:ConnectionConfig configuration = {
    baseUrl: cosmosConfig.baseUrl,
    primaryKeyOrResourceToken: cosmosConfig.primaryKey
};
final cosmosdb:DataPlaneClient azureCosmosClient = check new (configuration);

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function get requestsByUser(string userEmail) returns json[]|error {
        string query = string `SELECT c.id, c.userEmail, c.gnDomain, c.reason, c.requestedDate, c.requestedBy, c.requestType, c.identityVerificationStatus, c.addressVerificationStatus, c.policeVerificationStatus, c.overallStatus, c.createdAt, c.lastUpdatedAt FROM c WHERE c.userEmail = '${userEmail}'`;
        stream<request, error?> result = check azureCosmosClient->queryDocuments("grama-db", "requestContainer", query);

        json[] outputs = check from request request in result  select request.toJson();
        return outputs;
           
    }
    resource function get requestsByDomain(string gnDomain) returns json[]|error {
        string query = string `SELECT c.id, c.userEmail, c.gnDomain, c.reason, c.requestedDate, c.requestedBy, c.requestType, c.identityVerificationStatus, c.addressVerificationStatus, c.policeVerificationStatus, c.overallStatus, c.createdAt, c.lastUpdatedAt FROM c WHERE c.gnDomain = '${gnDomain}'`;
        stream<request, error?> result = check azureCosmosClient->queryDocuments("grama-db", "requestContainer", query);

        json[] outputs = check from request request in result  select request.toJson();
        return outputs;
           
    }
    resource function get requestById(string id) returns json|error {
        string query = string `SELECT c.id, c.userEmail, c.gnDomain, c.reason, c.requestedDate, c.requestedBy, c.requestType, c.identityVerificationStatus, c.addressVerificationStatus, c.policeVerificationStatus, c.overallStatus, c.createdAt, c.lastUpdatedAt FROM c WHERE c.id = '${id}'`;
        stream<request, error?> result = check azureCosmosClient->queryDocuments("grama-db", "requestContainer", query);

        json[] outputs = check from request request in result  select request.toJson();
        if(outputs.length() == 1){
            return outputs[0];
        }else{
            //add meaningful error msgs
            return {"error":"error"};
        }
        // request|error result = azureCosmosClient->getDocument("grama-db","requestContainer",id,id);
        // if (result is error) {
        //     log:printError(result.message());
        // }
        // else {
        //     log:printInfo(result.toString());
        //     log:printInfo("Success!");
        // }
        // return [];
           
    }

    # Description
    #
    # + req - Parameter Description
    # format of the body of the request
    # {
    # "requestType" : "Identity",
    # "requestedBy" : "Name",
    # "userEmail" : "user@abc.com",
    # "gnDomain" : "514",
    # "reason" : "The reason for the request"
    # }
    # + return - Return Value Description
    resource function post addRequest (http:Request req) returns http:Response|error{
      json payload = check req.getJsonPayload();
      log:printInfo(payload.toString());

      request request = {
        createdAt: time:utcToString(time:utcNow()),
        lastUpdatedAt: time:utcToString(time:utcNow()),
        requestedDate: time:utcToString(time:utcNow()).substring(0,10),
        requestType: <string> check payload.requestType,
        requestedBy: <string> check payload.requestedBy,
        userEmail: <string> check payload.userEmail,
        gnDomain: <string> check payload.gnDomain,
        reason: <string> check payload.reason,
        identityVerificationStatus: false, 
        addressVerificationStatus: false, 
        policeVerificationStatus: false, 
        overallStatus: "Pending"
        };

      // write to cosmos db
      string partitionKey = uuid:createType1AsString();
      cosmosdb:DocumentResponse|error result = check azureCosmosClient->createDocument ("grama-db","requestContainer", partitionKey, request, partitionKey);
      if (result is error) {
          log:printError(result.message());
          http:Response response = new;
          response.statusCode = 500;
          response.setPayload({"error":result.message()});
          return response;
      }
      else {
          log:printInfo(result.toString());
          log:printInfo("Success!");
          http:Response response = new;
          response.statusCode = 200;
          response.setPayload({"message":"success"});
          return response;
      }
  }

  resource function put setStatusOfRequest (http:Request req) returns http:Response|error{
      json payload = check req.getJsonPayload();
      log:printInfo(payload.toString());

      request request = {
        createdAt: <string> check payload.createdAt,
        lastUpdatedAt: time:utcToString(time:utcNow()),
        requestedDate: <string> check payload.requestedDate,
        requestType: <string> check payload.requestType,
        requestedBy: <string> check payload.requestedBy,
        userEmail: <string> check payload.userEmail,
        gnDomain: <string> check payload.gnDomain,
        reason: <string> check payload.reason,
        identityVerificationStatus: <boolean> check payload.identityVerificationStatus, 
        addressVerificationStatus: <boolean> check payload.addressVerificationStatus,
        policeVerificationStatus: <boolean> check payload.policeVerificationStatus, 
        overallStatus: <string> check payload.overallStatus
        };

        // write to cosmos db
      string partitionKey = <string> check payload.id;
      cosmosdb:DocumentResponse|error result = check azureCosmosClient->replaceDocument("grama-db","requestContainer", partitionKey, request, partitionKey);
      if (result is error) {
          log:printError(result.message());
          http:Response response = new;
          response.statusCode = 500;
          response.setPayload({"error":result.message()});
          return response;
      }
      else {
          log:printInfo(result.toString());
          log:printInfo("Success!");
          http:Response response = new;
          response.statusCode = 200;
          response.setPayload({"message":"success"});
          return response;
      }
  }

}



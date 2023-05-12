import ballerina/http;
import ballerinax/azure_cosmosdb as cosmosdb;
configurable config cosmosConfig = ?;

final cosmosdb:ConnectionConfig configuration = {
    baseUrl: cosmosConfig.baseUrl,
    primaryKeyOrResourceToken: cosmosConfig.primaryKey
};
final cosmosdb:DataPlaneClient azureCosmosClient = check new (configuration);

# A service representing a network-accessible API
# bound to port `9090`.

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowMethods: ["GET", "POST", "PUT", "PATCH", "DELETE"],
        allowHeaders: ["Authorization", "Content-Type", "Content-Type", "Accept", "JWTAssertion"],
        allowCredentials: false,
        maxAge: 84900
    }
}
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

}





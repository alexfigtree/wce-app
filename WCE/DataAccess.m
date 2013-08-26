//
//  DataAccess.m
//  WCE
//
//  Created by  Brian Beckerle on 8/2/13.
//

/**
 Database access and update methods
 **/

#import "DataAccess.h"
#import "WCEAppDelegate.h"

@implementation DataAccess




/**
 Get path of database in the app
 **/
-(NSString *)getDatabasePath{
    WCEAppDelegate *appDelegate = (WCEAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSString *dbPath = [appDelegate databasePath];
    
    return dbPath;
}


//Location Access Methods
//location names are enforced as unique so a name can be used as an id

/**
 Get all the locations in the database 
 Returned as an array of Location objects defined in Location.h
 **/
-(NSMutableArray *)getLocations{
    
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    //wrap in try catch blocks!!
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM location"];
    
    while([results next])
    {
        Location *curLocation = [[Location alloc] init];
        
        NSInteger nsi = 1;
        int i = [results intForColumn:@"id"];
        nsi = i;
        
        curLocation.locationId = nsi;
        
        curLocation.name = [results stringForColumn:@"name"];
        
         NSLog(@" Current Location id %i current location name: %@", nsi, curLocation.name);
        
        curLocation.contact = [results stringForColumn:@"contact"];
        
        curLocation.phone = [results stringForColumn:@"phone"];
        
        curLocation.address = [results stringForColumn:@"address"];
        
        curLocation.city = [results stringForColumn:@"city"];
        
        curLocation.zip = [results stringForColumn:@"zip"];
        
        curLocation.country = [results stringForColumn:@"country"];
        
        curLocation.language = [results stringForColumn:@"language"];
    
        [locations addObject:curLocation];
    }

    [db close];

    return locations;

}

/**
 return a location for a given name
 **/
-(Location *)getLocationForName:(NSString *)name{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    //wrap in try catch blocks!!
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM location WHERE name = ?", name];
    
    Location *curLocation = [[Location alloc] init];
    
    if([results next]){
        
        NSInteger nsi = 1;
        int i = [results intForColumn:@"id"];
        nsi = i;
        
        curLocation.locationId = nsi;
        
        curLocation.name = [results stringForColumn:@"name"];
        
        NSLog(@" Current Location id %i name: %@", nsi, curLocation.name);
        
        curLocation.contact = [results stringForColumn:@"contact"];
        
        curLocation.phone = [results stringForColumn:@"phone"];
        
        curLocation.address = [results stringForColumn:@"address"];
        
        curLocation.city = [results stringForColumn:@"city"];
        
        curLocation.zip = [results stringForColumn:@"zip"];
        
        curLocation.country = [results stringForColumn:@"country"];
        
        curLocation.language = [results stringForColumn:@"language"];
    }
    
    [db close];
    
    return curLocation;
}

/**
 get a locationId for a given name
 **/
-(NSInteger)getLocationIdForName:(NSString *)name{
    Location *cur = [self getLocationForName:name];
    
    NSLog(@"Location id returned %i for name: %@", cur.locationId, cur.name);
    
    return cur.locationId;
}


/**
 Insert location into database
 **/
-(BOOL)insertLocation:(Location *) location{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];

    [db open];

    BOOL success =  [db executeUpdate:@"INSERT INTO location (name, contact, phone, address, city, zip, country, language) VALUES (?, ?, ?, ?, ?, ?, ?, ?);", location.name, location.contact, location.phone, location.address, location.city, location.zip, location.country, location.language, nil];
    
    [db close];
    
    return success;

}


/**
 Update a given location in the database
 **/
-(BOOL)updateLocation:(Location *) location{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];

    //wrap in try catch blocks!!
    [db open];

    BOOL success = [db executeUpdate:@"UPDATE location SET name = ?, contact = ?, phone = ?, address = ?, city = ?, zip = ?, country = ?, language = ? WHERE name = ?;", location.name, location.contact, location.phone, location.address, location.city, location.zip, location.country, location.language, location.name];
    
    if (!success){
        NSLog(@"%@", [db lastErrorMessage]);
    }

    [db close];
    
    return success;
}


/**
 Use this method to update a location with a name change
 **/
-(BOOL)updateLocation:(Location *) location withName:(NSString *)name{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    //wrap in try catch blocks!!
    [db open];
    
    BOOL success = [db executeUpdate:@"UPDATE location SET name = ?, contact = ?, phone = ?, address = ?, city = ?, zip = ?, country = ?, language = ? WHERE name = ?;", location.name, location.contact, location.phone, location.address, location.city, location.zip, location.country, location.language, name];
    
    if (!success){
        NSLog(@"%@", [db lastErrorMessage]);
    }
    [db close];
    
    
    return success;
}

/**
 Delete a given location in the database
 **/
-(BOOL)deleteLocation:(Location *)location{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    //wrap in try catch blocks
    [db open];
    
    BOOL success = [db executeUpdate:@"DELETE FROM location WHERE name=?;", location.name];
    
    if (!success){
        NSLog(@"%@", [db lastErrorMessage]);
    }
    [db close];
    
    
    return success;
}

//Partner access methods
//partner names are not guaranteed to be unique so partnerId must be used as an id
//partners also need a location id in order to show up in the application
/**
 return partners for a given location name
 **/
-(NSMutableArray *)getPartnersForLocationName:(NSString *)name{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM partner WHERE locationId = (SELECT id FROM location WHERE name=?)", name];
    
    NSMutableArray *partners = [[NSMutableArray alloc] init];
    
    while([results next]){
        Partner *curPartner = [[Partner alloc] init];
        curPartner.partnerId = [results intForColumn:@"id"];
        curPartner.locationId = [results intForColumn:@"locationId"];
        curPartner.name = [results stringForColumn:@"name"];
        [partners addObject:curPartner];
    }
    
    [db close];
    
    return partners;
}


/**
 Insert partner into database
 A partner NEEDS a valid location id in order to show up in the application
 use getLocationIdForPartner to obtain it
 **/
-(BOOL)insertPartner:(Partner *) partner{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO partner (name, locationId) VALUES (?, ?);", partner.name, [NSNumber numberWithInteger:partner.locationId], nil];
    
    [db close];
    
    return success;
}


/**
 Use this method to update a partner 
 needs a valid partner id for updating
 **/
-(BOOL)updatePartner:(Partner *) partner {
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    [db open];
    
    BOOL success = [db executeUpdate:@"UPDATE partner SET name = ? WHERE id= ?;", partner.name, [NSNumber numberWithInteger:partner.partnerId]];
    
    if (!success){
        NSLog(@"%@", [db lastErrorMessage]);
    }
    [db close];
    
    return success;
}


/**
 Delete a given partner in the database
 needs a valid partner id
 **/
-(BOOL)deletePartner:(Partner *) partner{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    
    [db open];
    
    BOOL success = [db executeUpdate:@"DELETE FROM partner WHERE id=?;", [NSNumber numberWithInteger:partner.partnerId]];
    
    if (!success){
        NSLog(@"%@", [db lastErrorMessage]);
    }
    [db close];
    
    
    return success;
}

@end




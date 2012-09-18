#import "User.h"
#import "StringUtil.h"
#import "ChineseToPinyin.h"

@implementation User

@synthesize userId;
@synthesize screenName;
@synthesize name;
@synthesize province;
@synthesize city;
@synthesize location;
@synthesize description;
@synthesize url;
@synthesize profileImageUrl;
@synthesize profileLargeImageUrl;
@synthesize domain;
@synthesize gender;
@synthesize followersCount;
@synthesize friendsCount;
@synthesize statusesCount;
@synthesize favoritesCount;
@synthesize createdAt;
@synthesize following;
@synthesize verified;
@synthesize allowAllActMsg;
@synthesize geoEnabled;
@synthesize userKey;
@synthesize avatarImage;
@synthesize cellIndexPath;
@synthesize topicCount;
@synthesize verifiedReason;
@synthesize pinyin;

- (UserCDItem*)updateUserCDItem:(UserCDItem*)us
{
    us.allowAllActMsg       = [NSNumber numberWithBool:self.allowAllActMsg];
    us.avatarImage          = UIImageJPEGRepresentation(self.avatarImage, 1);
    us.city                 = self.city;
    us.createdAt            = [NSNumber numberWithLong:self.createdAt];
    us.domain               = self.domain;
    us.followersCount       = [NSNumber numberWithInt:self.followersCount];
    us.favoritesCount       = [NSNumber numberWithInt:self.favoritesCount];
    us.following            = [NSNumber numberWithBool:self.following];
    us.friendsCount         = [NSNumber numberWithInt:self.friendsCount];
    us.gender               = [NSNumber numberWithInt:self.gender];
    us.geoEnabled           = [NSNumber numberWithBool:self.geoEnabled];
    us.location             = self.location;
    us.name                 = self.name;
    us.profileImageUrl      = self.profileImageUrl;
    us.profileLargeImageUrl = self.profileLargeImageUrl;
    us.province             = self.province;
    us.screenName           = self.screenName;
    us.statusesCount        = [NSNumber numberWithInt:self.statusesCount];
    us.theDescription       = self.description;
    us.url                  = self.url;
    us.userId               = [NSNumber numberWithLongLong:self.userId];
    us.userKey              = self.userKey;
    us.verified             = [NSNumber numberWithBool:self.verified];
    
    return us;
}

-(User*)updateUserFromUserCDItem:(UserCDItem*)us
{
    self.allowAllActMsg = us.allowAllActMsg.boolValue;
    
    UIImage *img = [[UIImage alloc] initWithData:us.avatarImage]; 
    self.avatarImage = img;
    [img release];
    
    self.city = us.city;
    self.createdAt = us.createdAt.longValue;
    self.domain = us.domain;              
    self.followersCount = us.followersCount.intValue;
    self.followersCount = us.favoritesCount.intValue;
    self.following = us.following.boolValue;           
    self.friendsCount = us.friendsCount.intValue;       
    self.gender = us.gender.intValue;              
    self.geoEnabled = us.geoEnabled.boolValue;        
    self.location = us.location;            
    self.name = us.name;                
    self.profileImageUrl = us.profileImageUrl;     
    self.profileLargeImageUrl = us.profileLargeImageUrl;
    self.province = us.province;           
    self.screenName = us.screenName;          
    self.statusesCount = us.statusesCount.intValue;       
    self.description = us.theDescription;      
    self.url = us.url;                 
    self.userId = us.userId.longLongValue;              
    self.userKey = us.userKey;             
    self.verified = us.verified.boolValue;  
    
    return self;
}

- (User*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    self.avatarImage = nil;
	[userKey release];
    [screenName release];
    [name release];
	[province release];
	[city release];
    [location release];
    [description release];
    [url release];
    [profileImageUrl release];
	[domain release];
    
    userId          = [[dic objectForKey:@"id"] longLongValue];
    userKey			= [[NSNumber alloc] initWithLongLong:userId];
	screenName      = [dic objectForKey:@"screen_name"];
    self.pinyin          = [ChineseToPinyin pinyinFromChiniseString:screenName];
    name            = [dic objectForKey:@"name"];
	self.verifiedReason = [dic objectForKey:@"verified_reason"];
	//int provinceId = [[dic objectForKey:@"province"] intValue];
	//int cityId = [[dic objectForKey:@"city"] intValue];
	province		= @"";
	city			= @"";
	
	location        = [dic objectForKey:@"location"];
	description     = [dic objectForKey:@"description"];
	url             = [dic objectForKey:@"url"];
    profileImageUrl = [dic objectForKey:@"profile_image_url"];
	domain			= [dic objectForKey:@"domain"];
	
	NSString *genderChar = [dic objectForKey:@"gender"];
	if ([genderChar isEqualToString:@"m"]) {
		gender = GenderMale;
	}
	else if ([genderChar isEqualToString:@"f"]) {
		gender = GenderFemale;
	}
	else {
		gender = GenderUnknow;
	}

	
    followersCount  = ([dic objectForKey:@"followers_count"] == [NSNull null]) ? 0 : [[dic objectForKey:@"followers_count"] longValue];
    friendsCount    = ([dic objectForKey:@"friends_count"]   == [NSNull null]) ? 0 : [[dic objectForKey:@"friends_count"] longValue];
    statusesCount   = ([dic objectForKey:@"statuses_count"]  == [NSNull null]) ? 0 : [[dic objectForKey:@"statuses_count"] longValue];
    favoritesCount  = ([dic objectForKey:@"favourites_count"]  == [NSNull null]) ? 0 : [[dic objectForKey:@"favourites_count"] longValue];

    following       = ([dic objectForKey:@"following"]       == [NSNull null]) ? 0 : [[dic objectForKey:@"following"] boolValue];
    verified		= ([dic objectForKey:@"verified"]       == [NSNull null]) ? 0 : [[dic objectForKey:@"verified"] boolValue];
    allowAllActMsg	= ([dic objectForKey:@"allow_all_act_msg"]       == [NSNull null]) ? 0 : [[dic objectForKey:@"allow_all_act_msg"] boolValue];  
    geoEnabled		= ([dic objectForKey:@"geo_enabled"]   == [NSNull null]) ? 0 : [[dic objectForKey:@"geo_enabled"] boolValue];
    
	NSString *stringOfCreatedAt   = [dic objectForKey:@"created_at"];
    if ((id)stringOfCreatedAt == [NSNull null]) {
        stringOfCreatedAt = @"";
    }
    createdAt = (long)[stringOfCreatedAt longLongValue];
	
    if ((id)screenName == [NSNull null]) screenName = @"";
    if ((id)name == [NSNull null]) name = @"";
    if ((id)province == [NSNull null]) province = @"";
    if ((id)city == [NSNull null]) city = @"";
    if ((id)location == [NSNull null]) location = @"";
    if ((id)description == [NSNull null]) description = @"";
    if ((id)url == [NSNull null]) url = @"";
    if ((id)profileImageUrl == [NSNull null]) profileImageUrl = @"";
    if ((id)domain == [NSNull null]) domain = @"";
    
    [screenName retain];
    [name retain];
	[province retain];
	[city retain];
    location = [[location unescapeHTML] retain];
    description = [[description unescapeHTML] retain];
    [url retain];
    [profileImageUrl retain];
	[domain retain];
	profileLargeImageUrl = [[profileImageUrl stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"] retain];
}


+ (User*)userWithJsonDictionary:(NSDictionary*)dic
{
	//int userId = [[dic objectForKey:@"id"] intValue];
    User *u;
    
    u = [[User alloc] initWithJsonDictionary:dic];
    return [u autorelease];
}

- (void)dealloc
{
    [pinyin release];
    [verifiedReason release];
    [cellIndexPath release];
	[userKey release];
    [screenName release];
    [name release];
	[province release];
	[city release];
    [location release];
    [description release];
    [url release];
    [profileImageUrl release];
	[profileLargeImageUrl release];
	[domain release];
   	[super dealloc];
}





@end

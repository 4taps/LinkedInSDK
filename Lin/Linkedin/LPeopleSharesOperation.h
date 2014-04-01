//
//  LPeopleSharesOperation.h
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import "LInBaseOperation.h"

//Child nodes of share
#define kLinShareParam @"share"
//Text of member's comment. (Similar to deprecated current-status field.)
//Post must contain comment and/or (content/title and content/submitted-url). Max length is 700 characters (bytes).
#define kLinCommentParam @"comment"
//Parent node for information on shared document
#define kLinContentParam @"content"
//Title of shared document	Post must contain comment and/or (content/title and content/submitted-url). Max length is 200 characters (bytes).
#define kLinTitleParam @"title"
//URL for shared content	Post must contain comment and/or (content/title and content/submitted-url).
#define kLinSubmittedURLParam @"submitted-url"
//URL for image of shared content	Invalid without (content/title and content/submitted-url).
#define kLinSubmittedImageURLParam @"submitted-image-url"
//Description of shared content	Max length of 256 characters (bytes).
#define kLinDescriptionParam @"description"
//Parent node for visibility information
#define kLinVisibilityParam @"visibility"
//One of anyone: all members or connections-only: connections only.
#define kLinCodeParam @"code"

/**********
 Sample Request
 
 <share>
 <comment>Check out the LinkedIn Share API!</comment>
 <content>
 <title>LinkedIn Developers Documentation On Using the Share API</title>
 <description>Leverage the Share API to maximize engagement on user-generated content on LinkedIn</description>
 <submitted-url>https://developer.linkedin.com/documents/share-api</submitted-url>
 <submitted-image-url>http://m3.licdn.com/media/p/3/000/124/1a6/089a29a.png</submitted-image-url>
 </content>
 <visibility>
 <code>anyone</code>
 </visibility>
 </share>
 */

@interface LPeopleSharesOperation : LInBaseOperation

@end

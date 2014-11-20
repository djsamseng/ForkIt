/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2014 by Speaktoit, Inc. (https://www.speaktoit.com)
 * https://www.api.ai
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ***********************************************************************************************************************/

#import "ApiAI.h"
#import "AIDataService.h"
#import "AITextRequest.h"
#import "AIVoiceRequest.h"
#import "ApiAI_ApiAI_Private.h"

@interface ApiAI ()

@end

@implementation ApiAI

- (AIRequest *)requestWithType:(AIRequestType)requestType
{
    if (requestType == AIRequestTypeText) {
        return [[AITextRequest alloc] initWithDataService:_dataService];
    } else {
        return [[AIVoiceRequest alloc] initWithDataService:_dataService];
    }
    
    return nil;
}

- (void)setConfiguration:(id<AIConfiguration>)configuration
{
    _configuration = configuration;
    
    self.dataService = [[AIDataService alloc] initWithConfiguration:configuration];
}

- (void)enqueue:(AIRequest *)request
{
    [_dataService enqueueRequest:request];
}

@end

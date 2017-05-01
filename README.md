# Group Project - *KulTure*
*KapiL - There is a huge list of features that can be done but at this time we will stretch to build only about 25% of the feature of the idea.*

## User Stories

The following **required** functionality is completed:

- [ ] First Screen of the app

- [ ] Parent setup screen
   - [ ] Get parent details
   - [ ] Save in the DB
   
- [ ] Parent Home Screen

- [ ] Parent: Invite Screen
   - [ ] capture parent email id for future reference
   - [ ] Ability to add email for 1-3 people
   - [ ] Ability to add invitation message
   - [ ] Ability to choose categories for content sharing
   - [ ] Ability to enter additional / custom category
   - [ ] Ability to send 1-3 email(s) with custom content to invitees - consider using a unique code BLABRRR
   - [ ] book keep the invites sent to show who has responded

- [ ] Family: Accept invite flow
   - [ ] click on link in email and download the app
   - [ ] identify the invite link and customize the app [optional] [Highly recommended]
   - [ ] Enter details (email) and show the welcome message [BLABRRR]

- [ ] Family: Action requested workflow.
   - [ ] show the actions of the request to family member / friend. To let them know what they are asked for
   - [ ] actions should be interaction enabled and on clicking should take the user into data entry screen. 
	   - [ ] organize by category(greetings, food, dance) - supported content type can be entered
	   	- [ ] enter text section
		- [ ] enter images section [limit the size of image to 2MB] - even better would be to downsize the image automatically (Optional - highly recommended)
		- [ ] enter link to video (add disclaimer about age of the kid and that the responsibility lies on the parent to monitor the content being served to the kid)

- [ ] Family: History workflow - this workflow displays the liking for the content being shared by the parent.
	- [ ] displays all content shared by the member
	- [ ] displays the views on each content item

- [ ] Family: view the requested content by parent
   - [ ] Tapping on a user image should bring up that user's profile page

- [ ] Parent - audit mode - all new content shared to the kid lands up here and the parent has to approve this.
   - [ ] Ability to see all content
   - [ ] Ability to approve the content

- [ ] Kids View - the kid watches the shared content through this screen
	- [ ] profile images view
	- [ ] content based view
	- [ ] ability to like the content
	- [ ] [optional] ability to capture a pic/text and respond to the content watched

- [ ] Create Schema 
	- [ ] Validate schema to support the known workflows
	- [ ] Validate if the schema can support some of the known optional features
	- [ ] Review schema with team
	- [ ] Create Schema

- [ ] create database queries
	- [ ] for workflows
	- [ ] for optional workflows [optional]

- [ ] create Data Models 
	- [ ] based on the schema create the data models
	- [ ]

- [ ] Create API layer 
	- [ ] Support CRUD from schema over network
	- [ ] Error handling
	- [ ] graceful degradation and user interface messaging

- [ ] Parent Approval Workflow
	- [ ] Parent gets to view all content before it gets published to the kids

- [ ] Invite Email content design

- [ ] Connect invited users with the Invitee workflow
	- [ ] Users invited to the app should be able to see the customized content on the splash screens
	- [ ] Users should have a way to connect with parent from the app

The following **optional** features are implemented:
- [ ] Splash screen for the APP
- [ ] First Time use screens for Parents
- [ ] First Time use screens for Family members
- [ ] First Time use screens for Kids
- [ ] Parent List of all invites sent screen and accepted invites


The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/FutureXInc/kulture/blob/master/AppProgressTimeLine/KulTure0.1.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

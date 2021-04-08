# README - Invisible Cities BackEnd v. 0.1 2/16/21

Hey! Invisible Cities was my first stab at a chat app. This is the backend.

I developed this as my final project for a full-stack web developmenmt bootcamp called FlatIron. To explore the technologies I learned over the course of 12 weeks, I chose to design a chat app in the style of the app MarcoPolo. It turns out that was an overly ambitious idea for my current level, but somehow after designing and redesigning this app over the course of 5 weeks, I have something that, for the most part, works.

There is room for improvement, but it's time to turn this in. In this document, you'll find my notes relevant to the backend data model, controllers, and some of the things I'd like to develop when I get a chance to work on the next version of this app.

# Ruby:

- This is Rails 6.0.3 on top of Ruby 2.6.1

# Configuration

- This is a rails API, using JWT and bcrypt for auth, and postgres for the db.  
  You should be good to go with a bundle install, but just in case, be sure to get the bcrypt and JWT gems.

# Database creation

- rails db:create will get the migrations going, and you should be good to go

# Database initialization

- There are a LOT of dependancies between these tables. I never wrote a db:seed, I relied on the frontEnd to add data as I added functionality.
- The user table is a has_many-through with itself through the Follow table, and separately through the Block table as well.
- When a user is created, they can request other users, add them as friends, or choose to block them. Once a user has friends, they can create user_groups out of lists their friends. Each user group requires multiple entries in UserGroup, one for each member.
- once a group is created, any user that's a member in the group can send a message to the group. This involves inserts into Message (to keep track of the message_body) & MessageRecipient (to keep track of who to deliver it to)
- If a user decides to delete their account, they need to be removed from Follow, Block, UserGroup, User, Message, and MessageRecipient. It gets a little crazy and you can check it out in follow#delete in the follow controller.

# Future development

- Currently the table Group isn't being used. Ideally, when User group is created, Group would be the primary, where we generate the group_id, and associate a custom name to the group. I think it would also be cool to add a 'last modified' to it so we can tell who changed the name of the group
- When there is only two members to a chat, maybe we could change the way that chat is handled to remove the option to add extra people. This would give a distinct difference between group chat and dm's.
- There is currently no testing suite. A set of tests is definitely needed.
- Websockets would be great. Right now useEffect is simulating it and its oh so slow.

Frontend can be found here: https://github.com/s-satsangi/invisible-cities-frontend

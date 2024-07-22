## JuliaChat

JuliaChat is a chat client, which utilizes [Sessionless][sessionless], and [Julia][julia] to provide users with a chat experience that has _no persisted identifier_ for others to contact them with.

### Overview

There are plenty of chat apps out there. 
If you try any of them, pretty much the first thing they do is ask you for your phone number.
The next thing is to import your contacts.

This is all well and good, as it's reasonable to expect that if you send someone sms texts, you may also want to send them AR filtered snaps. 
The problem though is now you have duplicate lists of contacts to manage, _and_ you're discoverable.
Maybe you didn't want to delete your aunt's contact info, but maybe you didn't need her being able to find you on noplace.

I didn't much care about this, but then in 2021 the US Supreme Court decided that people could text you no matter how they got your phone number.
And even then it didn't matter until this year when the US presidential election decided I needed to get more messages from my affiliated party than a rejected incel (more on this later).

Email's been ruined for years.
Now my phone number's ruined.

I'm old enough to remember when "You've got mail" was exciting.
I wanted an app that tried to do that.
Where if anyone wanted to find me, they couldn't, and I didn't have to feel bad about not connecting with them.

That's the idea behind JuliaChat.
Only connect with people that you want to connect with.
Revoke that connection at any time, and they can't find you again (goodbye rejected incels).

### How it works

So if JuliaChat doesn't use your phone number or email, how does it know it's you?
It uses an authentication protocol called [Sessionless][sessionless], which grants you a unique identifier (a UUID) that it pairs with a public key that your JuliaChat client generates.
From an authentication standpoint you are anonymous[^1], but the UUID provides continuity across and between devices.

So everyone has a UUID, but there is no discovery mechanism for UUIDs, so even if someone has your UUID they can't actually use it to contact you in any way.
Instead you generate a one-time use code for the other person to enter into their app.

How you exchange that code is up to you, and outside of the purview of JuliaChat for now.

Once they enter the code, you have the ability to accept it.
Once accepted you can message each other.
Both parties are able to revoke the connection at any time.
Once revoked, you'll have to go through the one-time code process again to connect.

And that's it.
Just message who you want, and never worry about spam, bots, pushy exes, people you vaguely remember from high school who for some reason like all your posts, etc. etc.

### Roadmap

* iOS - About 50% done
* Android - About 10% done
* Desktop - I kinda just want to build a CLI... we'll see
* Web - Might just leave this to someone else unless there's some big demand for it



[sessionless]: https://www.github.com/planet-nine-app/sessionless
[julia]: https://www.github.com/planet-nine-app/julia

[ht1]: ## "Anonymity in chat clients is pretty easy to obtain with burner phone numbers, and so this isn't a feature of JuliaChat.
It's just a side effect of an authentication protocol that doesn't need personal information to operate."


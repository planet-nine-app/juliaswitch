# Van Gogh

Van Gogh is a framework for the tracking of things privately.
What things you track are up to you.
Predictive modeling based on that tracking are also up to you.

It is called Van Gogh because although I have never had a "period", Van Gogh did, and periods are something to track. 
Van Gogh's periods were of course references to artistic preferences.
Should there be any homonyms in English that are also trackable is something to be inferred by those capable of linguistic inference.

## Motivation

As more and more of the world's creative output moves online, the prevailing monetization strategy is advertising.
Advertising works best with a concept called "segmentation," which allows advertisers, and businesses, to target segments of the population most likely to purchase their goods and services.
Thus there is a lot of time and money spent trying to figure out who you are, and what you do, and what you're into.

For the tinfoil hat big brother types out there, the government doesn't need to be a surveilance state.
Advertisers are doing it for free, and selling it to anyone who cares to pay. 

Now if you've ever been on the internet you know that ads are ubiquotous, but there is a lot of computing hardware behind presenting the right ad to you at the right time. 
Going into all of that is beyond the scope of this doc, but I will highlight one big advertising concept--life moments.

So advertisers know that consumers don't change their behavior often. 
If you purchase groceries from your regional chain, it's unlikely you'll just one day decide to go to Whole Foods instead.
But life-moments are the one known time the people do change their shopping habits. 
The four big life-moments for advertisers are: marriage, retiring, or graduation, having a child. 

Marriage, retiring, and graduation are all easily discoverable, and schedulable in advance (weekend elopements in Vegas notwithstanding).
But even meticulous planning with respect to pregnancy doesn't assure anyone that biology will cooperate, and thus of these four life moments, the most challenging to know, and thus the most lucrative to sell is having a child.

Now of course, Van Gogh here is simply a framework for the tracking of things that are your business with the effort being put in to keep whatever it is you are tracking from being used by advertisers. 
And if we can't do that, we'll let you know why.

## Cybersecurity

The whole realm of cybersecurity is beyond the scope of this, but some basic groundwork is helpful.
First, you should assume that anything sent to a cloud is insecure. 
Anything stored on a device is insecure if the device is compromised.
Insecure things should be encrypted, and the encryption is only as good as the encryption key upholds the last two sentences.

When considering options for keeping data safe, the cybersecurity term for assessing risk is establishing a threat model. 
Threats can come in many forms, but some high level considerations:

* The state passes some law that all of your tracked data needs to be handed over by you or your chosen vendor
* Non-state actors use some method to steal existing data
* An individual steals your data
* The state uses some extra-judicial action to steal existing data

Considering these it might seem overwhelming to consider keeping tracked data safe. 
The flipside is there're a number of folks with their bank account passwords saved in text files on their machines that are being synced to a cloud without their knowledge. 
Security often comes simply from the fact that there are a lot of people who aren't you.

## This project

This project is an endeavor to provide visibility to the threats enumerated above, and to provide a way of tracking things where these threats are ideally mitigated, and if not than hopefully reduced.
It will primarily focus on the first three threats, as the solution for the fourth is to throw all your devices in a river. 

It's primary technological goal is to remove all instances of digital fingerprinting and subsequent tracking from any apps that use this framework. 
For this purpose I'm leaning towards using [Tauri](https://tauri.app) with vanilla html, js, and css for the UI. 

Anything that connects to the internet, right now likely just a simple cloud backup, will be encrypted and stored only temporarily on a non-cloud-based server. 
This will be optional, and clearly explained as introducing risk.

Deployment introduces tracking so this project will be open source with build instructions for sideloading onto mobile devices.
It will also be (perhaps optionall?) obfuscated so that a snooper won't know right off hand what they're looking at. 

Data will be expungable at any point in time, and (perhaps optionally?) remotely. 

No pii will be taken of any kind--no email, no name, no birthdate, none of that. 

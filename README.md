# Tattletrail

There are many stories behind why this project came about.  Here's one that I think we've probably all had some kind of experience with:

> I walked into the office on a Thursday morning.  One of my favorite developers ( who am I kidding, they're all my favorite ) came to me with
> a problem regarding the pipelines in the dev envionment.  Apparently nothing had been building since yesterday afternoon.  Upon inspection
> I realized that traffic was not flowing out of the subnet like it should be.  Everything else was working fine, we could get to the UI,
> and we could ssh into the jenkins master and the agents.
> What we found was that the default route for the subnet had been removed.  I asked the team if anyone knew anything about any actions
> regarding routing.  There were no immediate responses, so I went to cloudtrail to see if I could figure out what was going on.
> Now, granted, the goal here isn't to rat the person out, or call them out directly.  Creating a blameless culture is the cornerstone
> of trust, and trust makes finding out what happens easier.
> Our goal here was to simply find out what happened so that we could fix it, understand the problem, and maybe find some way to prevent it
> in the future.
> CT told us that DevOpsEngineer1 ( DOE1 for short ) had removed the route late in the afternoon the day before.
> Apparently DOE1 and the lead architecht had been expeirmenting with some routing changes on Wednesday afternoon.  Instead of deleting
> their experimental routes, they deleted the primary routes, which caused the jenkins agents to effectivly blow chunks.
> All totalled we spent around 90 minutes start to finish figuring out what was going on and what we had to do to fix it.

This project is aimed at addressing this user story as well as a few others in this realm.  If I had come in on Thursday and talked with the
developer I would have immediattly checked my TT report.  Ideally my report would have flagged the route deletion as a high threat level
item.  I would have gained a few valuable pieces of infromation from this report:

* Who did it.  This wouldn't have told me what DOE1 was doing, but at least I would have had something to tell me where to start.  My thinking here is that I could have talked directly to this person to start with and maybe saved some debugging time with a conversation.  Instead we had the debugging time, then the conversation.  It's a small optimization that could have saved a little time.
* In this case, knowing what happened and who did it would have given me a clear idea of what I had to do to fix the probelem.

There are other, more intense scenarios in which an operator might do something like open all TCP/UDP traffic to 0.0.0.0/0 on a production network, maybe even a Jenkins server or some other
important production resource.  In these cases it would be very helpful to have a dashboard of some sort that would show the highest threat level items over the last 24 hours.

At the very least this might give us insight into what's really going on with our accounts.

In the ideal world everyone follows the rules and we have IAM gates to make sure these things don't happen.  In the real world, that's not always the case.

# Blog posts

* [Starting project](https://krogebry.github.io/devops/cloudtrail/2017/07/29/tattle-trail-start.html)

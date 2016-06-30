# wsbootstrap
Cross-(likely-)platform development environment

# The Problem
I'm a developer. Once in a while, I have to set up a new development machine. There are a lot of reasons, and they have slightly different requirements. Here's the top 3:

* New computer
* New job
* New team

In each of those scenarios, the story is a little different. When switching between companies, I may move from a primarily Node.JS development environment to a primarily Java environment. I may be switching between OSX and Ubuntu (or rhel5 if I ever end up back at AMZN :|). I may be switching between AWS and GCloud tooling. A lot of the tools for these environments have some overhead (I think it's nvm that's currently hurting my shell launch time), so I'd like to only activate (and even install) the ones that I need for a given machine.

I started searching. I found [this guy](https://github.com/cowboy/dotfiles) and I like the cut of his jib. I also started thinking that I like the idea of *-available and *-enabled from apache/nginx and the like. I like idea of automatic version checking (but not forcing an update) from gcloud (and way more tools before it, just front of mind). 

Most importantly, I like the idea of being able to customize something locally without modifying the source repo, so I can more easily take upstream changes. 

So I'm going to take a lot of the ideas cowboy had and run with them, but I'm going to try to make user-specific customization a little cleaner. I'm going to start with my dotfiles, and work from there. 

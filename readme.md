Welcome to the app that is just for me. Not you, not anybody else. Just me. The idea is simple, I wanted to explore some new tech and maybe improve my life along the way. I use it as a playground for phone features.

It's written in Swift because... why not?

### Features
* Shows some of the HOV tolls on interstate 405
* Tracks my location and sends it to an Azure function that privately saves my location history
* Gives me local notifications when I enter certain geo-fences. Basically, I get an alert when I arrive at home or work.
* Survives death. Even if the app is killed, it can re-activate in response to location changes.
* Raygun for error logging

### What I Learned

* Local notifications are eaten unless you have the right AppDelegate method that says not to eat them
* Swift is crazy about nullable (nilable?) types
* Reading from a plist is a huge pain
* Parsing JSON is vastly improved in Swift 4
* Every swift version has dramatic changes from its predecessor. This makes it super fun searching for examples.
# 'Doro app

Jared Sinclair recently announced his new podcast app, called 'sodes. 

https://twitter.com/jaredsinclair/status/756480795586375680

This announcement was very well received in the iOS community (there's already a set of great podcast apps like Pocket Casts and Marco Arment's Overcast, so this will no doubt add to the vibrant podcasting ecosystem on  platforms)

So, Inspired from (epi)sodes. Here's 'doro the pomodoro app.

Feature set I started out with (neither exhaustive nor aimed at - this is basically the feature set I'd plan for if this was to be an app worthy of the App Store).

- **Set pomodoro durations and alarm tones** - There's a reason the guys at Kayako mentioned this. It does seem like a basic feature every user needs.
- **Actionable directly from the lockscreen** - this was important because most apps depend on insidious tricks like [keeping the phone screen on indefinitely](http://stackoverflow.com/questions/125619/how-do-i-prevent-the-iphone-screen-from-dimming-or-turning-off-while-my-applicat) so that the app remains in the foreground, and is thus not flushed out by iOS. And while I've **not** implemented this feature currently, I've ascertained this to be fairly possilbe. However, there's no app on the App Store that does this currently. So I *might* be missing something but this remains a killer feature
- **Integration with [gyrosco.pe](https://gyrosco.pe) or any tracking app** - well this was a personal feature I wanted. Turns out, you have to contact the guys over at gyroscope to do this ¯\\_(ツ)_/¯ 

# The thought process 

The first problem I tackled was the model layer of the app - the Pomodoro tracker. All the functions related to the *pomodoro* needed to be here. The PomodoroTracker would then send *messages* to the rest of the system regarding the change in its state. This would be done using a delegation pattern (like in the MainTimerViewController) or through an NSNotification broadcast.

![ Obligatory post from NSHipster: http://nshipster.com/nsnotification-and-nsnotificationcenter ](https://i.imgur.com/p4dJcdV.png)

Pomodoros depend on user input to work properly (There's no way to know if your user's dozing off when he/she's supposed to be working or Programming hard during a break period. So, a Pomodoro can exist in the following states: 

- **HasntStarted** - an init state before the user starts a session
- **Work** - during a work period
- **Break** - during a break period
- **Waiting** - an intermediary state where we wait for user input. This lasts for 30 seconds by default, after which we assume a failed/abandoned pomodoro.
- **Success** - a successful pomodoro cycle
- **Failure** - an abandoned cycle. Default back to HasntStarted

The pomodoro class contains methods that can trigger state transitions (for example, a user pressing a button, or a timer running out). It also contains a swift computed property that external views can refer to do get the current time left.

Now that the hard part is over, let's move on to the easy stuff.

# The main timer screen
This screen has 2 labels - one displaying the time left and another representing the current state. The timer updates itself via an NSTimer method that's(according to the docs) optimised to run alongside the main thread. If this wasn't true, I'd probably setup a dispatch queue with a delay that'd automatically call itself.

Here's a few screenshots :

- HasntStarted : ![](http://i.imgur.com/eqA0LMI.png)
- Work :  ![](http://i.imgur.com/yOnaT1X.png)
- Break : ![](http://i.imgur.com/bZcXsVW.png)
- Waiting :  (Notice the ominous background) ![](http://i.imgur.com/YX5VVnv.png)


# The settings screen
This lets the user set the timer durations. It basically sets a dictionary key in the `NSUserDefaults` which is the key value store generally used for things like user settings etc.

Apple doesn't let developers change the look of the Picker UI component, so I had to resort to certain hacky solutions. Had this been a production app, I would've implemented my own custom UI control.

Here's a screenshot: http://imgur.com/aAWWmYK

# The song selection screen

Lets the users set the sound to play. Again uses the default picker control. The sounds by themselves are `aiff` files I added to the resource bundle from Garageband beats.

This would be a LOT prettier in a production app. Also, ideally along with the rest of the settings.

Here's a screenshot: http://imgur.com/3LDOVcL

# The charts screen
Ah, the charts. This was actually the hardest to implement. Turns out, Realm doesn't let you store enums in the database. Had to add an extra key in the `PomodoroTracker` class, which I hate. 10/10 would use 's Core Data framework or the SQLite C++ API next time, even though I'd have to probably write an Objective-C bridging header or something.

As for the library, I was heart set on using PhilackM's [Scrollable Graph View](https://github.com/philackm/Scrollable-GraphView) because of it's buttery smooth 60fps-iness. This, by the way is unsurprisingly achieved by deleting and adding points on the graph depending on scroll position (I spent way too much time reverse engineering how it worked, so here's a gif of what I'm talking about) : 

![](http://i.imgur.com/q5xcI8H.gif)

Unfortunately, the library didn't support stacked bar charts (and adding that capability was beyond the scope of a take home project) so I had to use another one instead (I've forked the repo for now, and I'll probably end up adding stacked bar charts out of pure spite) . I eventually settled on [this](https://github.com/i-schuetz/SwiftCharts). 

There's nothing special going on here otherwise, and realm is super fast with querying so I can get the latest pomodoro objects on the main thread itself.

Obligatory screenshot: ![](http://i.imgur.com/49JQvvV.png)

# Realm

Realm by the awesome guys at [Realm.io](http://realm.io/) came highly recommended (The android devs over at Housing labs were using it). The docs were pretty, and they've [sponsored](https://realm.io/news/jorge-ortiz-unit-testing-swift-2/) several [amazing iOS events](https://realm.io/news/slug-edward-jiang-server-side-swift/). They also happen to be maintaining the documentation engine as well as the linter that I'm using, so I guess I'm kinda sorta indebted to them.

Other than the enum fiasco, it's worked solidly for me and I'm super happy with the results.

# Linting

I'm using [swiftlint](https://github.com/realm/SwiftLint) by realm, with strictest rules(I like to call it the highest difficulty level) following Github's [Swift Style Guide](https://github.com/github/swift-style-guide). I'ms stuck on ~6 errors, one of which is a false positive that I've documented and the other 5 are things I really need to fix (having 7 switch cases seems a little too much, if you ask me, but I'm not sure how I'd fix it).

# Documentation

I'm using [jazzy](https://github.com/realm/jazzy/) by (surprise) Realm, which is neat because it works using the `xcodebuild` command line tool and generates docs exactly like Apple's. No seriously, check out the `docs` folder.

# Unit Tests
I've written [Unit tests in other languages before]](https://github.com/codeOfRobin/howToThinkLikeAComputerScientist), but not a lot in Swift. So I decide to hit up Treehouse and see how [Unit Testing in iOS](https://teamtreehouse.com/library/unit-testing-in-ios-2) worked (There's also the great lecture by Realm in one of the links above). 

Swift, being a statically typed language eliminates huge common classes of errors you'd normally see in, say Javascript or Python. It also has unique features like optionals to prevent common runtime errors (like `indexOutOfRange` or `Nil` errors), so that removes a lot of Unit Tests I'd normally have to write (no point writing an `AssertNil()` if the compiler can guarantee the nil state of an object or an `AssertType()` if the types of objects are known at compile time). That leaves other cases like preventing regressions when someone else edits your code, so I've written a tiny unit test to make sure my `timeLeft` stored property returns the right values.

# UI Tests
UI testing isn't really a mature thing right now. There was an older thing called KIF(Keep It Functional), but AFAIK it isn't maintained after Apple introduced a first party solution. It's still relatively young, and I haven't explored it as much.

# Things to improve
**Humblebrag** I've tried to keep errors to a mininmum, and I haven't seen a run time crash yet, so ~🖖~ (Apparently, that's the vulcan salute and not a fingers-crossed emoji). 
There are, however around 5 TODOs scattered around the app, involving making the code neater like declaring strings as constants and DRYing(Don't Repeat Yourself) up the code. I'd get to it, but this was a take home project.

# Credits

Credit to https://thenounproject.com/mikkimikki for the settings icon
Credit to https://thenounproject.com/jardson/ for the music icon
Credit to https://thenounproject.com/kapklam/ for the bar chart icon 


#### INTERNAL TODO FOR SUPER SECRET INTERNAL TODO PURPOSES :
- [ ] Send message to all VCs to dismiss once timer finishes so user can affirm
- [x] Add buttons for dismiss and stuff
- [x] Case for failure and success 
- [x] Save to DB on failure and/or successo
- [ ] Notification Actions.
- [x] Graphs
- [x] Comments
- [x] Docs
- [x] Lint
- [x] Unit tests to make sure timeLeft() works well

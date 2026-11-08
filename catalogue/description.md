Orbit is the Hb UI framework and homescreen: the user interface of Symbian^4, the Symbian Foundation's planned next release.
It was published as open source in 2010 and never shipped on a phone. This package makes it run on Phorepoc OS.

It adds a second shell next to the standard one: after installing it, open Settings, then Device, then UI shell, pick Orbit and
restart. You get the Orbit homescreen with its clock widget, status bar and application library; the standard applications
keep working under it. Pick the standard shell the same way to go back, or hold the Menu key while the phone starts to get the
standard shell for that start. If Orbit does not start twice in a row, the phone goes back to the standard shell by itself and
tells you.

Orbit needs the Qt package (Qt 4.8, from Catalogue); install it first. Nothing in the system needs Orbit, and no Phorepoc image
carries it. Hb is LGPL 2.1 with the Nokia Qt LGPL Exception; the rest is under the Eclipse Public License 1.0. The package
installs the licences and the source offer in `\resource\phe\orbit\licences\`.

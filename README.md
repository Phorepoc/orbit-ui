# orbit-ui

Orbit for Phorepoc OS: the Hb UI framework (with its theme server and device dialogs), the Qt homescreen and its plug-ins, and the
Qt service framework, content arsenal and activity framework they use. Orbit was the UI of Symbian^4, the Symbian Foundation's
planned next release, published as open source in 2010 and never shipped on a phone.

It is a shell you install through the Catalogue; no system image carries it (nor Qt, which it needs; it also needs the image's GL stack, libEGL and friends: the
[qt-symbian](https://github.com/Phorepoc/qt-symbian) package, "Qt"). The release has one SIS, built for x32 (the PC image):
`orbit-ui-x32.sis`, package "Orbit". ARM follows once the phone's WSERV panic in Hb's background thread is fixed.

## How a shell is installed

`shell/orbit.txt` is installed as `\resource\phe\shells\orbit.txt`: the shell's id, name, start list and launcher
(core: `os/src/phedevmenu/pheshells.h`). The boot-time selector (`pheshellsel`) merges the installed shells with the built-in
ones; Settings, Device, UI shell, the developer menu and the power menu list them all. A shell that fails to come up twice
in a row is given up for the standard one (with a note); the Menu key held at boot forces the standard shell. `shell/orbit.start`
is what the selector starts before Orbit's launcher.

## Building

Check out core, the [pdk](https://github.com/Phorepoc/pdk), qt-symbian and this repository side by side, run
`phe source export -a`, then in the toolchain's web image with `PHOREPOC_S4=1 PHOREPOC_QT48=1`:

```sh
bash recipes/prebuild.sh                       # Qt 4.8 (if not built), Orbit's configure, the exports, host tools, the Z: data lists
phe component build -arch x32 $(. ./package.conf; echo $COMPONENTS_x32)   # Qt + Qt Mobility first: link providers only
bash recipes/sis.sh                            # $PHOREPOC_BUILD/sis/orbit-ui-x32.sis
```

`recipes/prebuild.sh` runs core's `os/tools/phorepoc-s4/` (the S^4 configure scripts, ported from the private tree, not yet run end to end in CI) after Qt 4.8 is built.

## License

Our files are BSD-2-Clause. Hb is LGPL-2.1 with the Nokia Qt LGPL Exception 1.1; the other Symbian Foundation parts are under the
Eclipse Public License 1.0. `NOTICE` and `SOURCE-OFFER.txt` have the details.

Contributions are welcome under the same terms. Add your name to `AUTHORS` in your first pull request.

# protocols_test
Testing swift protocols

This project was created in Xcode to test swift's protocols and structs.

The idea behind the test is to run multiple MacOS related checks including:
  Firewall Status
  Filevault
  Active Directory binding
  etc...
  
Once the shell command runs for the various checks, the return will include a array of strings with the first element stating "good" or "bad" and the second element with the text to update the NSTextField label.  The first element changes the NSImage to either a green checkmark if the check returned good or a red restricted image if the check failed.

Since there are multiple checks that run in the background, the idea is to put the checks in a dispatch group that will HIDE the "Refresh" button until all checks are complete.

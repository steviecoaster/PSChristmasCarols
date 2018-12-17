# Christmas tunes....Powershell style!

In the spirit of Christmas, I figured it would be fun to play some christmas carols via `[console]::beep()`

So, me and a few buddies decided to do a pair-programming session, and thus PSChristmasCarols was born.

I've included some sample JSON data that you can use to play around with, and see how easy it is to create songs!

Sample usage:

```powershell
$data = Get-Content .\JingleBells.json | ConvertFrom-Json
$data | Resolve-Note
```
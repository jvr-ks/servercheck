# Servercheck

The app can execute some Windows (network-test) commands.  
  
Currently:  
* NSLookup
* Ping  
* Traceroute (tracert)  
  
#### App-start  
**servercheck.exe** 64 bit Windows  
**servercheck32.exe** 32 bit Windows  
  
#### Download  
* From time to time there are some false positiv virus detections
[Virusscan](#virusscan) at Virustotal, see below.  

from github, these files are essential:  
  
List of Server-Urls:  
[servercheck.txt](https://github.com/jvr-ks/servercheck/raw/main/servercheck.txt)  
and  
[servercheck.exe 64bit](https://github.com/jvr-ks/servercheck/raw/main/servercheck.exe)  
or  
[servercheck32.exe 32bit](https://github.com/jvr-ks/servercheck/raw/main/servercheck32.exe)  
  
**Directory must be writable by the app!**

**Be shure to use only one of the \*.exe at a time!**  
  
#### Modifiers  
Placed after the servername.  
  
Modifier | Description  
------------ | -------------  
\[unhidden] | use an unhidden console window  
\[autoclose] | closes the console window after running the command (in conjunction with \[unhidden])
\[locale] | replace "[locale]" with the language code, like "en_US"  
\[all other text] | undefined modifier are treated as a comment

Modifiers are not case-sensitive. 

#### Sourcecode: [Autohotkey format](https://www.autohotkey.com)  
* "servercheck.ahk"  
 
#### Requirements  
* Windows 10 or later only.  
  
#### Sourcecode  
Github URL [github](https://github.com/jvr-ks/servercheck).

#### Latest changes: 
  
Version (>=)| Change
------------ | -------------
0.012 | NSLookup added
0.010 | Github repo changed from "master" to "main"
0.009 | A32 ANSI version removed


#### License: MIT  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANT-ABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Copyright (c) 2021 J. v. Roos

<a name="virusscan"></a>
##### Virusscan at Virustotal 
[Virusscan at Virustotal, servercheck.exe 64bit-exe, Check here](https://www.virustotal.com/gui/url/ec5d9043ddd5483bbd8d96b198dbf5b51729ed9ac0ab2c0e80b558c9a5603390/detection/u-ec5d9043ddd5483bbd8d96b198dbf5b51729ed9ac0ab2c0e80b558c9a5603390-1697179845
)  
[Virusscan at Virustotal, servercheck32.exe 32bit-exe, Check here](https://www.virustotal.com/gui/url/62e61f85ee8e4e784fe91f244587ece12339144451a421428f628738f8fcc30b/detection/u-62e61f85ee8e4e784fe91f244587ece12339144451a421428f628738f8fcc30b-1697179845
)  

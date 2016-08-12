# MatzKatz

This is an IRC bot to run a little game for early risers: the first
person to send a single dot "." to the channel in the morning, after  
5 am, is earning a point. ".scores" prints out a simple list of the
current scores. 

Additionally the bot is using encryption compatible with weechat's
[crypt.py script](https://weechat.org/scripts/source/crypt.py.html/).

You're probably not interested in running this bot as-is. The most
interesting part to reuse is the `openssl enc` compatible encryption
algorithm in `MatzKatz::OpensslEnc`, especially the key derivation.

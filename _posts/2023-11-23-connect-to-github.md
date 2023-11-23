---
title: (Re-)connect to Github
description: 
date: 2023-11-23 09:35 +0100
---

I recently had to reset my computer and get it back up and running for coding which for the most part when super smooth with most things being in the cloud these days.

However, when I had to do my first push after the reset, I received this error:

```
% git push origin HEAD
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

After doing a bit of googling, it wasn't really clear to me how to 'log back into' Github. It seemed like it was necessary to add some sort of personal access token.

However, I found that the easiest thing was to connect to Github using a SSH key.

You set it up like this:

### Step 1: Generate key

Run this command: `ssh-keygen -t rsa -b 4096 -C 'your@email.com'`

```
% ssh-keygen -t rsa -b 4096 -C 'your@email.com'
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/username/.ssh/id_rsa): enter
Enter passphrase (empty for no passphrase): enter
Enter same passphrase again: enter
```

Just press enter when it asks for a file and passphrase.

Now, you have a key saved as `id_rsa` in your `.ssh` folder.

Verify it by running this command: `ls ~/.ssh/`

```
% ls ~/.ssh/
id_rsa		id_rsa.pub	known_hosts
```

### Step 2: Copy key

Next, run this command to read the content of your key: `cat ~/.ssh/id_rsa.pub`

```
% cat ~/.ssh/id_rsa.pub
ssh-rsa AAA[...]zQ4Sw== your@email.com
```

Copy the key to your clipboard (starting with 'ssh-rsa' and ending with 'your@email.com').

### Step 3: Add to Github

1. Go to github.com > Settings > SSH And GPG keys.
2. Click 'New SSH Key'.
3. Give a descriptive title. I'd use something to identify the device/computer your are using.
4. Select 'Authentication Key' as the key type.
5. Paste the key.
6. Click 'Add SSH Key'.

### Step 4: Authenticate

Authenticate using your new SSH key by running this command: `ssh -T git@github.com`

```
% ssh -T git@github.com

Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

### Step 5: Get back to work

That's it! Now, whenever you push to Github it uses your SSH key and life is a breeze again.
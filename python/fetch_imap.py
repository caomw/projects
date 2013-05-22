#!/usr/bin/python

import imaplib
import sys
import os
import re # Perl-style regular expressions

mail = imaplib.IMAP4_SSL('imap.gmail.com')
# It is unsafe to put passwords here
mail.login('', '')
mail.list()
# Out: list of "folders" aka labels in gmail.
mail.select("inbox") # connect to inbox.

# data[0] is like '1 2 3 4'
result, data = mail.uid('search', None, "ALL") # search and return uids instead

#for d in data:
#    print("d is ", d)

latest_email_uid = data[0].split()[-1]
result, data = mail.uid('fetch', latest_email_uid, '(RFC822)')
raw_email = data[0][1]
#type, msg_data = mail.fetch(latest_email_uid, '(BODY.PEEK[HEADER])')
#print("id is ", latest_email_uid)
print(raw_email)

I have experienced an issue conducting a search using regular expressions and `$or`.

The search I'm trying to make work is: 

```coffeescript
r = new RegExp '^' + preg_quote(q), 'i'
Contacts.find {'$or': [ {firstName: r}, {lastName: r} ] }
```

i.e. Give me all the contacts whose first or last name starts with "A".

I've created a repo showing this here: https://github.com/johnston/meteor-mongo-or-bug

After launching the app `mrt` and visiting `http://localhost:3000`, what should happen is clicking each letter causes the following names to appear:

* A = Albert Einstein
* B = Bruce Willis & Bob Marley
* C = Chris Rock

but what actually happens is when you click each letter, you might get one name appearing but never all three.

The server correctly outputs:

```
Filtering by "A" gives 1 results: Albert Einstein
Filtering by "B" gives 2 results: Bruce Willis, David Brown
Filtering by "C" gives 1 results: Chris Rock
```

But in the browser's console you get:

```
Filtering by "A" gives 0 results: 
Filtering by "B" gives 0 results:
Filtering by "C" gives 0 results:
```

Now, just add a single blank line to end of the `test.html` and save it. This triggers a page reload. This time the last letter click has the correct result, but none of the others do.

It works on the first name alone if you change it to:

```coffeescript
Contacts.find { firstName: r }
```

(to do this using the repo, open an editor and comment out line 11 and 52. Comment in line 14 and 55. It now works.)

I can only assume from this there is some issue with `$or` searches?
Schemer
=======

On-the-fly ActiveRecord schema changes for extremely rapid prototyping.

Description
-----------

Loosely define your schema in your ActiveRecord model and have it created and
updated for you without worrying about migrations. Useful for when you want to
play around with real data handling during extremely rapid prototyping but you
really don't care about keeping the data or how it's defined.

**WARNING:** This will create and delete data definitions on the fly with no
warning! Only use this with volatile data! Never attach it to an existing model
you care about as it will start adding and dropping columns without your 
consent!

Usage
-----

    class User < ActiveRecord::Base
      schema :username, :password
    end
    
Creates a `users` table if it doesn't exist, complete with `username` and 
`password` columns the first time you call `User.new`.

Need another column to play with?

    class User < ActiveRecord::Base
      schema :username, :password, :email
    end
    
Adds an `email` column the next time `User.new` is called.

Don't want a column anymore?

    class User < ActiveRecord::Base
      schema :password, :email
    end
    
Removes the `username` column the next time `User.new` is called.

Installation
------------

    $ gem sources -a http://gems.github.com (you only have to do this once)
    $ sudo gem install citrusbyte-schemer

License
-------

Copyright (c) 2009 Ben Alavi for Citrusbyte

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

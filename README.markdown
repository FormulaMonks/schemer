Schemer
=======

On-the-fly schema changes for very rapid prototyping, for ActiveRecord and
Sequel ORMs.

Description
-----------

Loosely define your schema in your model and have it created and updated for
you without worrying about migrations.

Useful for when you want to play around with real data handling during
prototyping but you really don't care about keeping the data or how it's
defined.

This isn't meant to be a replacement for migrations, it is simply a way to get
started on a project quickly while you iron out your data definitions.

**WARNING:** This will create and delete data definitions on the fly with no
warning! Only use this with volatile data! Never attach it to an existing model
you care about as it will start adding and dropping columns without your
consent!

Install
-------

    $ gem install schemer

ActiveRecord
------------
    
    require "schemer/active_record"
    
    class User < ActiveRecord::Base
      schema :username, :password
    end

Creates a `users` table if it doesn't exist, complete with `username` and 
`password` columns the first time the User class is loaded.

Need another column to play with?

    class User < ActiveRecord::Base
      schema :username, :password, :email
    end

Adds an `email` column the next time `User` class is loaded.

Want a relationship? (but fear commitment...)

    class Widget < ActiveRecord::Base
      schema :user_id, :name
  
      belongs_to :user
    end

Works just fine, and you can drop it at any time!

    class Widget < ActiveRecord::Base
      schema :name
    end

Removes the `user_id` column the next time the `Widget` class is loaded.

Have a need for a particular type of column?

    class Widget < ActiveRecord::Base
      schema :name, { :size => :integer }, :description
    end
    
Will create `size` as an `:integer` column so you can take advantage of type
loading.

Feeling more confident and ready to make that big leap to migrations? Run:

    rake schemer:migration

To get:

    Migration from schema declarations in User, Widget

    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :email
    end

    create_table :widgets do |t|
      t.string :name
      t.integer :size
      t.string :description
    end

Then you can paste the output into a migration file, setup your columns (don't
forget your indexes!) and get rid of your `schema` calls in the listed classes
and you're on your way to the big leagues!

**NOTE:** All columns are created as string columns unless type is given.

Sequel
------

    require "schemer/sequel"

    class Widget < Sequel::Model
      plugin Schemer::Sequel
      
      schema :name, { :size => :integer }, :description
    end
    
Usage is as above w/ ActiveRecord

Test
----

    $ rake
    
Thanks!
-------

Michel Martens ([soveran](http://github.com/soveran)) + Cyril David
([cyx](http://github.com/cyx)) for helping with Sequel support.

License
-------

Copyright (c) 2009-2011 Ben Alavi for Citrusbyte

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

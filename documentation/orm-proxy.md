Populate ME : ORM Proxy
=========================




Method Clashes
----------------





Just in case we don’t have time to talk, I have been thinking about the ORM adapters and explored the solution of using a proxy.
The reason being that Proxies are better than adapters when you want to leave sthe original class mostly untouched.
This is what we would want here because we don’t want to interfere too much with ActiveRecord or whatever ORM it links to.

The other requirements are that each AR class needs to have a proxy class which is always the same but with each method overridable.

So you might start with a code which looks like this:


module PopulateMe
 module ActiveRecordProxy
   def self.included base
     base.class_eval do
       class Proxy
         # Put all the methods needed here
         # As if it was the class itself
       end
     end
   end
 end
end


What this code does is that when this module is included into a class, it will create a class under its name space which is called Proxy and this is the one that we are going to reference in PopulateMe.

So when you do this:

require ‘populate_me/active_record_proxy'
class BlogPost < ActiveRecord
 include PopulateMe::ActiveRecordProxy
 # The rest of your normal AR code
end

It actually does this:

class BlogPost < ActiveRecord
 class Proxy
   # All your PopulateMe methods here
 end
 # The rest of your AR code
end

It means that in PopulateMe, the class you are using is BlogPost::Proxy.
There might be problems with this method but I cannot figure it out without testing.

Then for writing your proxy methods, here is a simple example with a class method and an instance method:


module PopulateMe
 module ActiveRecordProxy
   def self.included base
     base.class_eval do
       class Proxy
         def initialize(*args)
            @target = base.new(*args)
         end
         def self.[] id
           base.find(id)
         end
         def to_s
           @target.to_s
         end
       end
     end
   end
 end
end


I think you can use `base` in them and it will reference the class you put the class into (the target).
Let me know if this doesn’t work and we’ll find another solution.



module PopulateMe
module ActiveRecordProxy
  def self.included base
    base.const_set :Proxy, Class.new{
        def initialize(*args)
           @target = Target.new(*args)
        end
        def self.[] id
          Target.find(id)
        end
        def to_s
          @target.to_s
        end
    }
    base::Proxy.const_set :Target, base
  end
end
end
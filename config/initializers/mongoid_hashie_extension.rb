require 'hashie'

module Mongoid
  module Extensions
    module Mash

      module ClassMethods

        def demongoize(object)
          ::Hashie::Mash.new(object)
        end

        def mongoize(object)
          case object
          when ::Hashie::Mash, ::Hash
            object.mongoize
          else
            super
          end
        end
      end # ClassMethods
    end # Mash
  end # Extensions
end # Mongoid

::Hashie::Mash.__send__(:include, Mongoid::Extensions::Mash)
::Hashie::Mash.__send__(:extend, Mongoid::Extensions::Mash::ClassMethods)
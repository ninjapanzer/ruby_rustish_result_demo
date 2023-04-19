## Copied from https://gist.github.com/Freaky/76fb032225680ab559fbaeecf0be4773

module Rustish
  module Result
    ResultMisuse = Class.new(StandardError)
    FailedUnwrap = Class.new(ResultMisuse)
    ExpectationFailed = Class.new(ResultMisuse)

    Empty = Object.new

    module InstanceMethods
      def initialize(item)
        @item = item
      end

      def map()
        enum_for(__method__) unless block_given?
        self
      end

      def map_err()
        enum_for(__method__) unless block_given?
        self
      end

      def unwrap() expect("unwrap failed") end

      def err?() !ok? end
    end

    class Base
      private

      def ensure_result(ret)
        unless Base === ret
          raise ResultMisuse, "Expected Ok/Err, got #{ret.class}: #{ret.inspect}"
        end

        ret
      end
    end

    class Ok < Base
      include InstanceMethods
      include Enumerable

      def map()
        enum_for(__method__) unless block_given?
        Ok(yield(@item))
      end

      def ok?() true end

      def expect(str) @item end
      def unwrap_or(other) @item end
      def unwrap_or_else
        enum_for(__method__) unless block_given?

        ensure_result @item
      end

      def unwrap_err
        raise FailedUpwrap, "Err expected"
      end

      def each()
        enum_for(__method__) unless block_given?

        yield(@item)
      end

      def and(thing)
        ensure_result thing
      end

      def and_then
        enum_for(__method__) unless block_given?

        ensure_result yield(@item)
      end

      def or(thing)
        ensure_result thing
      end

      def or_else
        enum_for(__method__) unless block_given?

        self
      end
    end

    class Err < Base
      include InstanceMethods
      include Enumerable

      def map_err()
        enum_for(__method__) unless block_given?
        Err(yield(@item))
      end

      def unwrap_err()
        @item
      end

      def ok?() false end

      def expect(str) raise(ExpectationFailed, str) end
      def unwrap_or(other) other end
      def unwrap_or_else
        enum_for(__method__) unless block_given?

        ensure_result yield
      end

      def each()
        enum_for(__method__) unless block_given?
        self
      end

      def and(thing)
        self
      end

      def and_then
        enum_for(__method__) unless block_given?

        self
      end

      def or(thing)
        ensure_result thing
      end

      def or_else
        enum_for(__method__) unless block_given?

        ensure_result yield
      end
    end
  end

  def Ok(item = Result::Empty)
    Result::Ok.new(item)
  end

  def Err(item = Result::Empty)
    Result::Err.new(item)
  end
end

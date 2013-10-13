module Chassis
  class Repo
    class NullAdapter
      def initialize_storage!
        @counter = 0
      end

      def create(record)
        @counter = @counter + 1
        record.id ||= @counter
      end

      def update(*)

      end

      def delete(*)

      end

      def find(*)

      end

      def first(*)

      end

      def last(*)

      end

      def sample(*)

      end

      def clear

      end

      def count(*)
        0
      end

      def first(*)

      end

      def all(klass)
        [ ]
      end

      def query(*)

      end

      def graph_query(*)

      end
    end
  end
end

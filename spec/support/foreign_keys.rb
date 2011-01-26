# make test env work with foreign_keys
# http://kopongo.com/2008/7/25/postgres-ri_constrainttrigger-error

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      def disable_referential_integrity(&block)
         transaction {
           begin
             execute "SET CONSTRAINTS ALL DEFERRED"
             yield
           ensure
             execute "SET CONSTRAINTS ALL IMMEDIATE"
           end
         }
      end
    end
  end
end

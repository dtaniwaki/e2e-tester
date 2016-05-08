class AsyncRecordJob < ApplicationJob
  include Sidekiq::Worker

  sidekiq_options queue: :async_record, retry: true, backtrace: true, unique: :while_executing

  def perform(klass, id, method_name)
    record = klass.constantize.find_by_id!(id)
    record.public_send(method_name)
  end
end

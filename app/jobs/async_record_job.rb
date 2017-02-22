class AsyncRecordJob < ApplicationJob
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: true, backtrace: true, unique: :while_executing

  def perform(klass, id, method_name)
    record = klass.constantize.find_by!(id: id)
    record.public_send(method_name)
  end
end

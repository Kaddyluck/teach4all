namespace :messages do
  namespace :deleted do
    desc 'Delete messages removed by both sender and receiver'
    task :cleanup => :environment do
      deleted_messages = Message.left_outer_joins(:receipts)
                                .where(receipts: { id: nil })
      deleted_messages_count = deleted_messages.size
      deleted_message_ids = deleted_messages.pluck(:id)

      deleted_messages.destroy_all

      puts "#{Time.zone.now}"
      puts " #{deleted_messages_count} mesages deleted"
      puts "ids: #{deleted_message_ids}\n"
    end
  end

  namespace :trashed do
    desc 'Delete receipts trashed earlier than a week ago'
    task :cleanup => :environment do
      receipts_to_delete = Receipt.where('trashed = true AND updated_at < ?', 1.week.ago)
      receipts_count = receipts_to_delete.size
      receipt_ids = receipts_to_delete.pluck(:id)

      receipts_to_delete.destroy_all

      puts "#{Time.zone.now}"
      puts " #{receipts_count} receipts deleted from trash"
      puts "ids: #{receipt_ids}\n"
    end
  end
end

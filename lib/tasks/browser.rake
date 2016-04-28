namespace :browser do
  desc 'Update browsers'
  task update: ['update:local', 'update:browserstack']

  namespace :update do
    desc 'Update local browsers'
    task local: :environment do
      Browser::Local.update_all!
    end

    desc 'Update browserstack browsers'
    task browserstack: :environment do
      Browser::Browserstack.update_all!
    end
  end
end

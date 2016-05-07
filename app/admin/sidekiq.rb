ActiveAdmin.register_page 'Sidekiq' do
  menu priority: 999_999

  content do
    # redirect_to "/admin/sidekiq_web"
    render '/shared/iframe', src: '/admin/sidekiq_web'
  end
end

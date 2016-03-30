ActiveAdmin.register_page "Sidekiq" do
  content do
    #redirect_to "/admin/sidekiq_web"
    render "/shared/iframe", src: "/admin/sidekiq_web"
  end
end

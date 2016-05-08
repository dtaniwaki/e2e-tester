ActiveAdmin.register User do
  permit_params :username, :name, :email, :password, :password_confirmation,
                :confirmation_token, :confirmed_at,
                :reset_password_token, :reset_password_setn_at,
                :unlock_token, :unlocked_at

  scope :all, default: true
  scope :invitation_accepted
  scope :invitation_not_accepted
  scope :with_deleted
  scope :only_deleted

  index do
    selectable_column
    id_column
    column :username
    column :name
    column :email
    column :created_at
    column :updated_at
    actions
  end
end

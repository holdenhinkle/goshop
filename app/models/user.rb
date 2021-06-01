class User < ApplicationRecord
  belongs_to :account
  acts_as_tenant :account

  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable,
        #  :confirmable, 
         :timeoutable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates_with EmailAddress::ActiveRecordValidator, field: :email
  validates :email, presence: true, uniqueness: { scope: :account_id, case_sensitive: false }
  validates :password, presence: true, length: { :in => 6..20 }, :if => :password_required?

  protected

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end

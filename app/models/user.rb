class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable

  devise :omniauthable, :omniauth_providers => [:yammer, :github]

  belongs_to :network
  ACCEPTABLE_ORGS={'IoraHealth' => 1}.freeze

  def self.find_for_github_oauth(auth)
    network = nil
    ACCEPTABLE_ORGS.keys.find do |org|
      if Github::API.new.member_of(org, auth.info.nickname)
        network = Network.find_or_create_by(nid: ACCEPTABLE_ORGS[org], name: org)
      end
    end

    return nil unless network

    user = where(provider: auth[:provider], uid: "#{auth[:uid]}").first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.network = network
    end
    user.update({
      access_token: auth.credentials.token,
      name: auth.info.name,
      image: auth.info.image,
      network: network,
      email: auth.info.email
    })
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.yammer_data"] && session["devise.yammer_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end

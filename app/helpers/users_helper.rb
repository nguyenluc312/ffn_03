module UsersHelper
  def avatar_for_user user, option = {}
    size = option[:size] || Settings.user.avatar.sizes.default
    image_tag user.avatar, alt: user.name, width: size, height: size,
      class: "avatar-user"
  end
end

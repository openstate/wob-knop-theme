UserController.class_eval do
  def change_telephone_number
    # "authenticated?" has done the redirect to signin page for us
    return unless authenticated? || ask_to_login(
      web: _('To change your telephone number used on {{site_name}}',
             site_name: site_name),
      email: _('Then you can change your telephone number used on {{site_name}}',
               site_name: site_name),
      email_subject: _('Change your telephone number used on {{site_name}}',
                       site_name: site_name)
    )

    unless params[:submitted_telephone_number_do]
      render action: 'change_telephone_number'
      return
    end

    @user.telephone_number = params[:change_telephone_number][:telephone_number]
    if not @user.valid?
      @change_telephone_number = @user
      render :action => 'change_telephone_number'
      return
    end

    @user.save!
    flash[:notice] = _('You have now changed your telephone number used on {{site_name}}', :site_name => site_name)
    redirect_to user_url(@user)
  end
end
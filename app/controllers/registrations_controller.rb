class RegistrationsController < ApplicationController
  
  def index
    session[:registration_params] = {}
    @registration = Registration.new()
    # @registration.current_step = session[:registration_step]
    session[:registration] = @registration
  end

  def thanks
  end

  def create
    # session[:registration_params].deep_merge!(params[:registration]) if params[:registration]
    @registration = session[:registration]
    @registration.apply(params[:registration]) if params[:registration];
    # @registration.current_step = session[:registration_step]
    
    if (@registration.current_voornaam.blank? && 
        !@registration.current_achternaam.blank? && 
        (@registration.current_geslacht == nil || @registration.current_geslacht.blank?))
      @registration.current_achternaam = ''
      @registration.remove_last_child
    end

    if @registration.valid?
      if params[:back_button]
        @registration.previous_step
        if @registration.current_step == 'child'
          lastname = @registration.current_achternaam
          @registration.new_child
          @registration.current_achternaam = lastname
        end
      elsif params[:add_child_button]
        lastname = @registration.current_achternaam || params[:registration][:current_achternaam]
        @registration.new_child
        @registration.current_achternaam = lastname
      elsif @registration.last_step?
        @registration.send_mail if @registration.all_valid?
      else
        @registration.next_step
      end
      session[:registration_step] = @registration.current_step
    end
    session[:registration] = @registration

    unless @registration.mail_sent?
      render "index"
    else
      session[:registration_step] = session[:registration_params] = nil
      flash[:notice] = "Registration doorgezonden!"
      redirect_to :action => :thanks
    end
  end  
end

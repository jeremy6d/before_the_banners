class CompaniesController < ApplicationController
  def edit
    @company = current_user.company
  end

  def update
    @company = current_user.company

    if @company.update_attributes company_params
      redirect_to edit_company_path, notice: "Company settings updated."
    else
      render :edit, alert: "Your settings could not be updated."
    end
  end

private
  def company_params
    params.require(:company).permit :title,
                                    :email_domain,
                                    :logo,
                                    :logo_cache
  end
end
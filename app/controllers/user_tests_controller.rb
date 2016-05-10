class UserTestsController < BaseController
  def create
    @test = Test.find(params[:test_id])
    authorize @test, :show?
    @user = User.find_or_invite_by({ email: params[:email] }, current_user)
    if @user.valid?
      @user_test = @test.user_tests.with_user(@user).first_or_initialize
      authorize @user_test
      @user_test.assigned_by = current_user

      if @user_test.save
        flash[:notice] = 'Successfully invited the user'
      else
        flash[:alert] = 'Failed to invite the user'
      end
    else
      flash[:alert] = 'Failed to invite the user'
    end
    redirect_to test_path(@test)
  end

  def update
    @user_test = UserTest.find(params[:id])
    authorize @user_test

    if @user_test.update_attributes(permitted_params)
      flash[:notice] = 'Successfully updated the user test'
    else
      flash[:alert] = 'Failed to update the user test'
    end
    redirect_to test_path(@user_test.test)
  end

  def index
    @test = Test.find(params[:test_id])
    authorize @test, :show?
    @user_tests = policy_scope(@test.user_tests).eager_load(:user).page(params[:page]).per(20)
  end

  def destroy
    @user_test = UserTest.find(params[:id])
    authorize @user_test

    @user_test.destroy!

    flash[:notice] = 'Successfully deleted the user test'

    redirect_to test_path(@user_test.test)
  end

  private

  def permitted_params
    params.require(:user_test).permit(user_test_variables_attributes: [:id, :name, :value, :_destroy])
  end
end

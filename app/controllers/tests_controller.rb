class TestsController < BaseController
  before_action :assign_base_test_step_set, only: [:new, :create, :edit, :update]
  before_action :assign_browsers, only: [:new, :create, :edit, :update]

  def index
    @tests = policy_scope(current_user.accessible_tests).latest.page(params[:page]).per(20)
  end

  def show
    @test = Test.find(params[:id])
    authorize @test

    @test_versions = @test.test_versions.preload(test_browsers: :browser).latest.limit(10)
    @user_test = @test.user_tests.with_user(current_user).includes(:user_test_variables).first
    @user_tests = @test.user_tests.eager_load(:user).limit(10)
    @integrations = current_user.user_integrations.limit(10)
  end

  def new
    @test = current_user.tests.build
    authorize @test

    @base_test_step_set ||= @test.updating_test_version
  end

  def create
    @test = current_user.tests.build
    authorize @test

    @test.assign_attributes(permitted_params)
    @test.updating_test_versions.each do |t|
      t.assign_attributes(user: current_user, base_test_step_set: @base_test_step_set)
    end
    if @test.save
      flash[:notice] = t('shared.create_success', target: Test.model_name.human)
      redirect_to test_path(@test)
      return
    end

    @base_test_step_set = @test.updating_test_version
    render :new
  end

  def edit
    @test = Test.find(params[:id])
    authorize @test

    @base_test_step_set ||= @test.updating_test_version
  end

  def update
    @test = Test.find(params[:id])
    authorize @test

    @test.assign_attributes(permitted_params)
    @test.updating_test_versions.each do |t|
      t.assign_attributes(user: current_user, base_test_step_set: @base_test_step_set || @test.current_test_version)
    end
    if @test.save
      flash[:notice] = t('shared.update_success', target: Test.model_name.human)
      redirect_to test_path(@test)
      return
    end

    @base_test_step_set = @test.updating_test_version
    render :edit
  end

  def destroy
    @test = Test.find(params[:id])
    authorize @test

    if @test.destroy
      flash[:notice] = t('shared.destroy_success', target: Test.model_name.human)
    else
      flash[:alert] = t('shared.destroy_failure', target: Test.model_name.human, errors: @test.errors.full_messages.join(', '))
    end
    redirect_to tests_path
  end

  private

  def assign_browsers
    @browser_sets = BrowserSet.includes(:browsers).all
    @browsers = Browser::Base.active.all.group_by(&:class).map { |gk, bs| [gk, bs.group_by { |b| [b.os, b.os_version] }] }
  end

  def assign_base_test_step_set
    @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    return if @base_test_step_set.nil?
    authorize @base_test_step_set, :show?
    @base_test_step_set = @base_test_step_set.becomes TestVersion
  end

  def permitted_params
    params.require(:test).permit(
      updating_test_versions_attributes: [
        :title, :description,
        test_steps_attributes:
          [:test_step_type, :_destroy, :shared_test_step_set_id, data: [:message, :selector, :javascript, :variable, :value, :url, :width, :height, :duration]],
        browser_ids: []
      ]
    )
  end
end

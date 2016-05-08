module UrlHelper
  include Rails.application.routes.url_helpers

  def polymorphic_test_step_set_path(test_step_set, options = {})
    if test_step_set.is_a?(TestVersion)
      test_version_position_path(test_step_set, options)
    elsif test_step_set.is_a?(SharedTestStepSet)
      test_step_set_path(test_step_set, options)
    else
      raise NotImplementedError
    end
  end

  def test_version_position_path(test_version, options = {})
    test_test_version_path(test_version.test, test_version.position, options)
  end

  def test_version_position_url(test_version, options = {})
    test_test_version_url(test_version.test, test_version.position, options)
  end

  def doc_url(type)
    # TODO: Make it i18n
    case type
    when :markdown
      'https://daringfireball.net/projects/markdown/basics'
    when :browserstack
      'https://www.browserstack.com/'
    when :browserstack_credential
      'https://www.browserstack.com/accounts/settings'
    end
  end
end

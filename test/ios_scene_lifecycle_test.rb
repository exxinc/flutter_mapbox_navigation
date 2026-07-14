# frozen_string_literal: true

require "minitest/autorun"

class IosSceneLifecycleTest < Minitest::Test
  SWIFT_SOURCES = Dir[File.expand_path("../ios/Classes/**/*.swift", __dir__)]

  def test_navigation_does_not_resolve_ui_from_application_delegate_window
    offenders = SWIFT_SOURCES.map do |path|
      next unless File.read(path).include?("UIApplication.shared.delegate?.window")

      path.delete_prefix(File.expand_path("..", __dir__) + "/")
    end.compact

    assert_empty offenders,
                 "UIScene apps must resolve navigation UI from an active UIWindowScene: #{offenders.join(', ')}"
  end

  def test_navigation_factory_handles_missing_presenter_without_force_casting
    source = File.read(File.expand_path("../ios/Classes/NavigationFactory.swift", __dir__))

    assert_includes source, "foregroundActive"
    refute_match(/as!\s+FlutterViewController/, source)
  end
end

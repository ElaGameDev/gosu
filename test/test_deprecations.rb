# Encoding: UTF-8
require_relative 'test_helper'

class TestDeprecations < Minitest::Test
  include TestHelper
  
  @@win = Gosu::Window.new(100, 100)
  
  def test_gosu_module_constants
    # Backward compatibility
    assert_output "", /DEPRECATION WARNING: Gosu::GOSU_COPYRIGHT_NOTICE is deprecated; use LICENSES instead./ do
      assert_equal Gosu::LICENSES, Gosu::GOSU_COPYRIGHT_NOTICE
    end
    
    assert_output "", /DEPRECATION WARNING: Gosu::Sample is deprecated; use Gosu::Sound instead./ do
      Gosu::Sample.new(media_path('0614.ogg'))
    end
  end

  def test_only_warn_once_per_origin
    assert_output("", /DEPRECATION WARNING/) { single_origin }
    assert_silent { single_origin }
  end

  def single_origin
    @@win.set_mouse_position(1, 2)
  end
  
  def test_window_no_longer_needed
    assert_output("", /DEPRECATION WARNING: Passing a Window to Sample#initialize has been deprecated in Gosu 0.7.17./) do
      assert_raises(::ArgumentError) { Gosu::Sample.new(@@win) }
    end

    assert_output("", /DEPRECATION WARNING: Passing a Window to Song#initialize has been deprecated in Gosu 0.7.17./) do
      assert_raises(::ArgumentError) { Gosu::Song.new(@@win) }
    end

    assert_output("", /DEPRECATION WARNING: Passing a Window to Image#initialize has been deprecated in Gosu 0.9./) do
      assert_raises(::NoMethodError) { Gosu::Image.new(@@win) }
    end

    assert_output("", /DEPRECATION WARNING: Passing a Window to Image.from_text has been deprecated in Gosu 0.9./) do
      assert_raises(::TypeError) { Gosu::Image.from_text(@@win, 2, 3, 4) }
      assert_raises(::TypeError) { Gosu::Image.from_text(@@win, 2, 3, 4, 5, 6, 7) }
    end
  end
end

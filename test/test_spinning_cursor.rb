require 'helper'

class TestSpinningCursor < Test::Unit::TestCase
  context "when an action block is passed it" do
    should "start the cursor, run block content and kill the cursor" do
      # Hide any output
      capture_stdout do |out|
        SpinningCursor.start do
          action { sleep 0.1 }
        end
        # Give it some time to abort
        assert_equal false, SpinningCursor.alive?
      end
    end

    should "Parser#outer_scope_object point to 'caller'" do
      capture_stdout do |out|
        SpinningCursor.start { }
        parsed = SpinningCursor.instance_variable_get(:@parsed)
        assert_equal self, parsed.outer_scope_object
        SpinningCursor.stop
      end
    end

    should "evalute the block from the calling class" do
      @num = 1
      capture_stdout do |out|
        SpinningCursor.start do
          action { @num += 1 }
        end

        assert_equal 2, @num
      end
    end
  end

  context "when an action block isn't passed it" do
    should "start the cursor, and keep it going until stop is called" do
      capture_stdout do |out|
        SpinningCursor.start do
          banner "no action block"
        end
        sleep 0.5
        assert_equal true, SpinningCursor.alive?
        SpinningCursor.stop
        sleep 0.1
        assert_equal false, SpinningCursor.alive?
      end
    end
  end

  context "whilst running it" do
    should "allow you to change the end message" do
      capture_stdout do |out|
        SpinningCursor.start do
          action do
            SpinningCursor.set_message "Failed!"
          end
          message "Finished!"
        end

        assert_equal true, (out.string.end_with? "Failed!\n")
      end
    end

    should "stop and display error if an unmanaged exception is thrown" do
      capture_stdout do |out|
        SpinningCursor.start do
          action do
            raise "An exception!"
          end
        end

        assert_equal true, (out.string.include? "An exception!")
      end
    end

    should "not stop if an exception is handled" do
      capture_stdout do |out|
        SpinningCursor.start do
          action do
            begin
              raise "An exception!"
            rescue
              # rescued!
            end
          end
        end

        assert_equal true, (out.string.end_with? "Done\n")
      end
    end

    should "allow you to change the banner" do
      capture_stdout do |out|
        SpinningCursor.start do
          delay 0.2
          action do
            # Guessed that assertions are not working from inside action block
            # This assert false should fail but it pass
            # TODO: Find another way to 'assert'
            assert false
            # Have to give it time to print the banners
            sleep 0.1
            assert_equal true, (out.string.include? "Loading")
            sleep 0.1
            SpinningCursor.set_banner "Finishing up"
            sleep 0.2
            assert_equal true, (out.string.include? "Finishing up")
            sleep 0.1
          end
        end
      end
    end
  end

  context "when running for the second time" do
    should "(without a block) return similar timing values" do
      capture_stdout do |out|
        SpinningCursor.start
        sleep 0.2
        result = SpinningCursor.stop
        timing_1 = result[:elapsed_time]

        SpinningCursor.start
        sleep 0.2
        result = SpinningCursor.stop
        timing_2 = result[:elapsed_time]

        assert_equal (timing_1*10).round, (timing_2*10).round,
        "t1 #{timing_1} and t2 #{timing_2} should be equal"
      end
    end

    should "(with a block) return similar timing values" do
      capture_stdout do |out|
        result =
        SpinningCursor.start do
          action do
            sleep 0.2
          end
        end
        timing_1 = result[:elapsed_time]

        result =
        SpinningCursor.start do
          action do
            sleep 0.2
          end
        end
        timing_2 = result[:elapsed_time]

        assert_equal (timing_1*10).round, (timing_2*10).round,
        "t1 #{timing_1} and t2 #{timing_2} should be equal"
      end
    end
  end
end

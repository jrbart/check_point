defmodule CheckPoint.CheckTest do
	use ExUnit.Case
	doctest CheckPoint.Check
	alias CheckPoint.Check

describe "Check.ping/1" do
		test "function exists" do

		assert Check.ping == :ok
		end
	end
end

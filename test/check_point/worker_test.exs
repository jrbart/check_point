defmodule CheckPoint.WorkerTest do
	use ExUnit.Case
	doctest CheckPoint.Worker
 require Logger
	alias CheckPoint.Worker

  describe "Worker.check/3" do
		test "function exists" do
		  assert Worker.check(fn _ -> :ok end, %{}, %{})
		end

    test "worker takes args map" do
      {:ok, pid} = Worker.check(fn echo -> echo end, {:ok}, %{})
      assert {:ok} == GenServer.call(pid,:ok)
    end

    test "worker takes options map" do
      {:ok, pid} = Worker.check(fn echo -> echo end, {:ok}, %{delay: 5})
      assert {:ok} == GenServer.call(pid,:ok)
    end

    test "exercise worker" do
      {:ok, pid} = Worker.check(fn echo -> echo end, {:up}, %{delay: 5})
      # for now anything passed through call or cast is ignored
      assert {:up} == GenServer.call(pid,:blah)
      assert GenServer.cast(pid,:blah)
      Process.sleep(100) # give it time to loop a few
      assert :ok ==GenServer.stop(pid,:normal)
    end

  end


end

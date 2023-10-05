defmodule CheckPoint.WorkerTest do
	use ExUnit.Case
	doctest CheckPoint.Worker
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
      {:ok, pid} = Worker.check(fn echo -> IO.puts("loop") end, {:ok}, %{delay: 5})
      assert :ok == GenServer.call(pid,:ok)
      assert GenServer.cast(pid,:ok)
      Process.sleep(100)
      assert :ok ==GenServer.stop(pid,:normal)
    end

  end


end

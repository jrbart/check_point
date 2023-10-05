defmodule CheckPoint.Worker do
  use GenServer

  @moduledoc """
  Each checkpoint is a function being run in a genserver.  If the function returns :ok
  then it will log the fact that it ran and its results and sleep for a given duration.
  If it returns :error it will call the Alert moddule which will handle the escalation.
  """
    # API
  @doc """
  Create a checker (GenServer) to repeat a check function.

    iex> {:ok, pid} = CheckPoint.Worker.check(fn echo -> echo end, %{args: {:ok}}, %{delay: 5})
  """

  def check(check_function, args, opts) do
    start_link(%{fn: check_function, args: args, opts: opts})
  end

  # Client 
  def start_link(%{fn: check_function} = params) when is_function(check_function) do
    %{args: args} = params
    delay = Map.get(params.opts, :delay, %{delay: 5 * 60 * 1_000}) # delault delay to 5 minutes
    GenServer.start_link(__MODULE__, {check_function, args, Map.put(params.opts,:delay,delay)})
  end

  # Callbacks

  # the initialization showld quckly return so the engine can move on to 
  # initializing the rest of the checks.
  @impl true
  def init(init_tup) do
    {:ok, init_tup, {:continue, :start}}
  end

  # call the check function and wait for the results
  @impl true
  def handle_call(_request, _from, state) do
    {check_fn, args, _opts} = state
    reply = check_fn.(args)
    {:reply, reply, state}
  end

  # the main loop will run the check funtion that was passed
  # in and record the result.  Then if the result was not :ok
  # it should notify the alert handler.  If everything was ok
  # then it should send_after to wake up later
  @impl true
  def handle_cast(_request, state) do
    {check_fn, args, opts} = state
    check_fn.(args)
    # send_after takes a delay that is minutes * seconds * milliseconds
    %{delay: delay} = opts
    Process.send_after(self(), :looping, delay) 
    {:noreply, state} 
  end

  # this is the main loop
  @impl true
  def handle_info(:looping, state) do
    {check_fn, args, opts} = state
    check_fn.(args)
    # send_after takes a delay that is minutes * seconds * milliseconds
    %{delay: delay} = opts
    Process.send_after(self(), :looping, delay) 
    {:noreply, state} 
  end

  # this will be used to change the status level
  # normally the level will be :up
  # if a check fails, the level will change to :warn
  # and the frequency of the check will be increased
  # after a number of failures the level will change to :down
  # and the frequency will back off so it doesn't flood
  # something that is already having problems
  @impl true
  def handle_info(msg, state) do
    IO.puts("info")
    IO.inspect(msg)
    IO.inspect(state)
    {:noreply, state}
  end
    
  # continue with any setup that needs to be done on init
  @impl true
  def handle_continue(_continue_arg, state) do
    {:noreply, state}
  end

end
